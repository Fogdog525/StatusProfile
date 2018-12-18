//
//  FDTabController.m
//  FDHybridTableView
//
//  Created by 黄智浩 on 2018/12/15.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import "FDTabController.h"
#import "FDTabBarScrollView.h"
#import "FDPageController.h"
#import "FDCoverProtocol.h"
#import "SinaFile.h"
@interface FDTabController ()<FDPageControllerDelegate,FDTabDelegate,FDTabDataSource>
@property(strong,nonatomic)FDPageController *pageController;
@property(nonatomic)CGFloat topInset;
@property(nonatomic)CGFloat tabX;
@property(nonatomic)CGFloat tabW;
@property(nonatomic)CGFloat tabH;
@property(nonatomic)BOOL cannotScrollSwipeTableViewWhenLandscapeScrolling;
@property(nonatomic,strong,readwrite)UIImageView *scrollStretchView;
@end

@implementation FDTabController
- (void)tabDragWithOffset:(CGFloat)offset{
    self.tabBarView.frame = CGRectMake([self tabX], [self tabScrollTopWithContentOffset:offset], [self tabW], [self tabH]);
}
- (CGFloat)tabScrollTopWithContentOffset:(CGFloat)offset{
    
    CGFloat top = [self tabY] - offset;
    if (offset >= 0) {
        if (top <= self.minPullUp) {
            top = self.minPullUp;
        }
    }else{
        if (top >= self.maxPullDown) {
            top = self.maxPullDown;
        }
    }
    return top;
}
- (CGFloat)topInset{
    return self.tabBarView.frame.origin.y;
}
- (void)pageViewControllerDidTransitionToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController{
    
    if ([fromViewController conformsToProtocol:@protocol(FDPageSubControllerDataSource)]) {
        UIViewController<FDPageSubControllerDataSource> *tempFromVC = (UIViewController<FDPageSubControllerDataSource> *)fromViewController;
        tempFromVC.swipeTableView.scrollsToTop = NO;
    }
    if ([toViewController conformsToProtocol:@protocol(FDPageSubControllerDataSource)]) {
        UIViewController<FDPageSubControllerDataSource> *tempToVC = (UIViewController<FDPageSubControllerDataSource> *)toViewController;
        tempToVC.swipeTableView.scrollsToTop = YES;
    }
}
- (void)changeToSubViewController:(UIViewController *)toViewController{
    
    if (!toViewController || [self numberOfTab] <= 1) {
        self.cannotScrollSwipeTableViewWhenLandscapeScrolling = NO;
        return;
    }
    if ([toViewController conformsToProtocol:@protocol(FDPageSubControllerDataSource)]) {
        UIViewController<FDPageSubControllerDataSource> *tempToVC = (UIViewController<FDPageSubControllerDataSource> *)toViewController;
        NSInteger newIndex = [self.pageController indexOfController:tempToVC];
        CGFloat topDistance = [self pageSwipeTableViewTopInsetAtIndex:newIndex];
        CGFloat top = [self tabScrollTopWithContentOffset:([tempToVC swipeTableView].contentOffset.y + topDistance)];
        if (fabs(top - self.topInset) > 0.1) {
            CGFloat scrollOffset = [self swipeTableViewOffsetAtIndex:newIndex];
            self.cannotScrollSwipeTableViewWhenLandscapeScrolling = NO;
            [tempToVC swipeTableView].contentOffset = CGPointMake(0, scrollOffset);
        }else{
            self.cannotScrollSwipeTableViewWhenLandscapeScrolling = NO;
        }
    }else{
        self.cannotScrollSwipeTableViewWhenLandscapeScrolling = NO;
    }
}
- (CGFloat)swipeTableViewOffsetAtIndex:(NSInteger)index{
    return [self tabY] - self.topInset - [self pageSwipeTableViewTopInsetAtIndex:index];
}
- (void)reloadData{
    
    [self reloadPage];
    [self reloadTab];
}
- (void)reloadPage{

    [self.pageController updateCurrentIndex:[self defaultTabIndex]];
    self.pageController.view.frame = [self pageFrame];
    [self.pageController reloadPage];
}
- (void)reloadTab{
    
    [self.tabBarView removeFromSuperview];
    self.tabBarView = nil;
    [self configTabBarView];
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maxPullDown = KSCREEN_HEIGHT;
    self.minPullUp = 64;
    [self configPageController];
    [self configTabBarView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.cannotScrollSwipeTableViewWhenLandscapeScrolling = NO;
    [self.pageController beginAppearanceTransition:YES animated:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.pageController endAppearanceTransition];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.cannotScrollSwipeTableViewWhenLandscapeScrolling = YES;
    [self.pageController beginAppearanceTransition:NO animated:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.pageController endAppearanceTransition];
}
- (void)configPageController{
    
    self.pageController = [[FDPageController alloc]init];
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    [self.pageController updateCurrentIndex:[self preferDisplayPageIndex]];
    self.pageController.view.frame = [self pageFrame];
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}
- (UIViewController *)visibleViewController{
    return [self.pageController controllerForIndex:self.pageController.currentPageIndex];
}
- (void)configTabBarView{
    
    if ([self numberOfControllers] <= 1) { return;}
    if (!self.tabBarView) {
        self.tabBarView = [[FDTabBarScrollView alloc]initWithFrame:[self tabBarViewFrame] dataSource:self delegate:self];
        self.scrollStretchView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self tabW], [self tabY] + [self tabH])];
        [self.scrollStretchView sd_setImageWithURL:[NSURL URLWithString:[self stretchBackgroundImageViewURL]]];
    }
     [self.view addSubview:self.scrollStretchView];
     [self.view addSubview:self.tabBarView];
}
- (UIScrollView *)__swipeTableView{
    
    UIScrollView *swipeTableView = nil;
    UIViewController *viewController = [self.pageController controllerForIndex:self.pageController.currentPageIndex];
    if ([viewController conformsToProtocol:@protocol(FDPageSubControllerDataSource)]) {
        UIViewController<FDPageSubControllerDataSource> *tempVC = (UIViewController<FDPageSubControllerDataSource> *)viewController;
        swipeTableView = (UIScrollView *)[tempVC swipeTableView];
    }
    return swipeTableView;
}
- (CGRect)tabBarViewFrame{
    return CGRectMake([self tabX], [self tabY], [self tabW], [self tabH]);
}
- (CGFloat)tabX{
    return 0;
}
- (CGFloat)tabW{
    return KSCREEN_WIDTH;
}
- (CGFloat)tabH{
    return 40;
}
- (void)updateTabBarHighlighteStatusWithIndex:(NSInteger)index{
    if ([self.tabBarView isKindOfClass:[FDTabBarScrollView class]]) {
        FDTabBarScrollView *tabBar = (FDTabBarScrollView *)self.tabBarView;
        [tabBar reloadHighlightForIndex:index];
    }
}
- (void)updateScrollStretchViewHeightWithOffset:(CGFloat)offset{
    
    CGRect frame = self.scrollStretchView.frame;
    if (offset >= 0) {
        self.scrollStretchView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, [self tabY] + [self tabH] + offset);
    }else{
        self.scrollStretchView.frame = CGRectMake(frame.origin.x, offset, frame.size.width, [self tabY] + [self tabH]);
    }
}
#pragma mark FDTabDataSource
- (NSString *)titleForIndex:(NSInteger)index{
    return nil;
}
- (NSInteger)preferDisplayPageIndex{
    return 0;
}
- (CGFloat)tabY{
    return KNAVIGATIONANDSTATUSBARHEIGHT;
}
- (NSInteger)numberOfTab{
    return [self numberOfControllers];
}
#pragma mark FDTabDelegate
- (void)didPressTabForIndex:(NSInteger)index{
    if ([self.tabBarView isKindOfClass:[FDTabBarScrollView class]]) {
        FDTabBarScrollView *tabBar = (FDTabBarScrollView *)self.tabBarView;
        [tabBar caterScrollToIndex:index];
        [tabBar tabBarScrollToIndex:index];
        [self.pageController showPageViewAtIndex:index animated:YES];
    }
}
- (void)indexWillChange{
    self.cannotScrollSwipeTableViewWhenLandscapeScrolling = YES;
}
- (NSInteger)defaultTabIndex{
    return [self preferDisplayPageIndex];
}
#pragma mark FDPageControllerDataSource
- (NSInteger)numberOfControllers{
    return 0;
}
- (UIViewController *)controllerAtIndex:(NSInteger)index{
    return nil;
}
- (CGFloat)pageSwipeTableViewTopInsetAtIndex:(NSInteger)index{
    return [self tabH] + [self tabY];
}
- (BOOL)isPreLoad{
    return NO;
}
- (CGRect)pageFrame{
    return CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT);
}
- (NSString *)stretchBackgroundImageViewURL{
    return nil;
}
#pragma mark FDPageControllerDelegate
- (void)landscapeScrollContentOffsetWithRatio:(CGFloat)ratio{
    if ([self.tabBarView isKindOfClass:[FDTabBarScrollView class]]) {
        FDTabBarScrollView *tabBar = (FDTabBarScrollView *)self.tabBarView;
        [tabBar caterScrollToContentRatio:ratio];
    }
}
- (void)verticalScrollWithPageOffset:(CGFloat)offset index:(NSInteger)index{
    [self tabDragWithOffset:(offset + [self pageSwipeTableViewTopInsetAtIndex:index])];
}
- (void)pageViewController:(FDPageController *)pageController willTransitionFromViewControlelr:(UIViewController *)fromViewControlelr toViewController:(UIViewController *)toViewControlelr{
    [self changeToSubViewController:toViewControlelr];
}
- (void)pageViewController:(FDPageController *)pageController didTransitionFromViewControlelr:(UIViewController *)fromViewControlelr toViewController:(UIViewController *)toViewControlelr{
    [self pageViewControllerDidTransitionToViewController:toViewControlelr fromViewController:fromViewControlelr];
    if ([self.tabBarView isKindOfClass:[FDTabBarScrollView class]]) {
        FDTabBarScrollView *tabBar = (FDTabBarScrollView *)self.tabBarView;
        [tabBar tabBarScrollToIndex:self.pageController.currentPageIndex];
    }
}
- (void)pageViewController:(FDPageController *)pageController willLeaveFromViewControlelr:(UIViewController *)fromViewControlelr toViewController:(UIViewController *)toViewControlelr{
    [self changeToSubViewController:toViewControlelr];
}
- (void)pageViewController:(FDPageController *)pageController didLeaveFromViewControlelr:(UIViewController *)fromViewControlelr toViewController:(UIViewController *)toViewControlelr{
    [self pageViewControllerDidTransitionToViewController:toViewControlelr fromViewController:fromViewControlelr];
}
@end
