//
//  FDPageController.m
//  FDHybridTableView
//
//  Created by 首牛科技 on 2018/12/14.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import "FDPageController.h"
#import "FDPageContentView.h"
typedef NS_ENUM(NSInteger,FDPageScrollDirection){
    PageLeft = 0,
    PageRight = 1,
};
@interface FDPageController ()<UIScrollViewDelegate>
@property (nonatomic,strong)NSMutableDictionary <NSNumber *,UIViewController *> *memCacheDic;
@property (nonatomic,strong)NSMutableDictionary <NSNumber *,NSNumber *> *lastContentOffset;
@property (nonatomic,strong)NSMutableDictionary <NSNumber *,NSNumber *> *lastContentSize;
@property (nonatomic,strong)FDPageContentView *scrollView;
@property (nonatomic)NSInteger lastSelectedIndex;
@property (nonatomic)NSInteger guessToIndex;
@property (nonatomic)CGFloat originOffset;
@property (nonatomic)BOOL firstWillAppear;
@property (nonatomic)BOOL firstDidAppear;
@property (nonatomic)BOOL firstWillLayoutSubViews;
@property (nonatomic,assign,readwrite)NSInteger currentPageIndex;
@end

@implementation FDPageController
- (instancetype)init{
    if (self = [super init]) {
        self.memCacheDic = [[NSMutableDictionary <NSNumber *,UIViewController *> alloc]init];
        self.lastContentOffset = [[NSMutableDictionary <NSNumber *,NSNumber *> alloc]init];
        self.lastContentSize = [[NSMutableDictionary <NSNumber *,NSNumber *> alloc]init];
    }
    return self;
}
- (void)clearMemory{
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self.lastContentOffset removeAllObjects];
    [self.lastContentSize removeAllObjects];
    if (self.memCacheDic.count) {
        [self clearObserver];
        NSArray *vcArray = self.memCacheDic.allValues;
        [self.memCacheDic removeAllObjects];
        for (UIViewController *vc in vcArray) {
            [self __removeFromParentViewController:vc];
        }
        vcArray = nil;
    }
}
- (void)clearObserver{
    for (NSNumber *key in self.memCacheDic) {
        UIViewController *vc = self.memCacheDic[key];
        if ([vc conformsToProtocol:@protocol(FDPageSubControllerDataSource) ]) {
            UIScrollView *swipeTableView = [(UIViewController<FDPageSubControllerDataSource> *)vc swipeTableView];
            [swipeTableView removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
}
- (void)__removeFromParentViewController:(UIViewController *)controller{
    
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [self clearMemory];
}
- (void)dealloc{
    [self clearMemory];
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.firstWillLayoutSubViews = YES;
    [self __configScrollView];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (self.firstWillLayoutSubViews) {
        [self updateScrollViewLayoutIfNeed];
        [self updateScrollViewDisplayIfNeed];
        self.firstWillLayoutSubViews = NO;
    }else{
        [self updateScrollViewLayoutIfNeed];
    }
}
- (void)__configScrollView{
    
    self.scrollView = [[FDPageContentView alloc]initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

- (NSInteger)pageCount{
    return [self.dataSource numberOfControllers];
}
- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}
- (void)reloadPage{
    
    [self clearMemory];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateScrollViewLayoutIfNeed];
        [self showPageViewAtIndex:self.currentPageIndex animated:YES];
    });
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!scrollView.dragging && !scrollView.decelerating) return;
    if ([self.delegate respondsToSelector:@selector(landscapeScrollContentOffsetWithRatio:)]) {
        [self.delegate landscapeScrollContentOffsetWithRatio:scrollView.contentOffset.x / scrollView.frame.size.width];
    }
    if (scrollView.isDragging && scrollView == self.scrollView) {
        CGFloat offset = scrollView.contentOffset.x;
        CGFloat width  = scrollView.frame.size.width;
        NSInteger lastGuestIndex = self.guessToIndex < 0 ?self.currentPageIndex:self.guessToIndex;
        if (self.originOffset < offset) {
            self.guessToIndex = ceil(offset/width);
        }else if (self.originOffset >= offset){
            self.guessToIndex = floor(offset/width);
        }
         NSInteger numbersOfCount = [self pageCount];
        if (((self.guessToIndex != self.currentPageIndex && !self.scrollView.decelerating) || self.scrollView.isDecelerating) && lastGuestIndex != self.guessToIndex && self.guessToIndex >= 0 && self.guessToIndex < numbersOfCount) {
            if ([self.delegate respondsToSelector:@selector(indexWillChange)]) {
                [self.delegate indexWillChange];
            }
            UIViewController *fromViewController = [self controllerAtIndex:self.currentPageIndex];
            UIViewController *toViewController  = [self controllerAtIndex:self.guessToIndex];
            [self.delegate pageViewController:self willTransitionFromViewControlelr:fromViewController toViewController:toViewController];
            if ([self isPreLoad]) {
                [toViewController beginAppearanceTransition:YES animated:YES];
                if (lastGuestIndex == self.currentPageIndex) {
                    [fromViewController beginAppearanceTransition:NO animated:YES];
                }
                if (lastGuestIndex != self.currentPageIndex && lastGuestIndex >= 0 && lastGuestIndex < numbersOfCount) {
                    UIViewController *lastGuestViewController = [self controllerAtIndex:lastGuestIndex];
                    [lastGuestViewController beginAppearanceTransition:NO animated:YES];
                    [lastGuestViewController endAppearanceTransition];
                }
            }
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!scrollView.isDecelerating) {
        self.originOffset = scrollView.contentOffset.x;
        self.guessToIndex = self.currentPageIndex;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger newIndex = [self.scrollView calculateIndex];
    NSInteger oldIndex = self.currentPageIndex;
    self.currentPageIndex = newIndex;
    if (newIndex == oldIndex) {
        if (self.guessToIndex >= 0 && self.guessToIndex < [self pageCount]) {
            [[self controllerAtIndex:oldIndex]beginAppearanceTransition:YES animated:YES];
            [[self controllerAtIndex:oldIndex]endAppearanceTransition];
            [[self controllerAtIndex:self.guessToIndex]beginAppearanceTransition:NO animated:YES];
            [[self controllerAtIndex:self.guessToIndex]endAppearanceTransition];
        }
    }else{
        if (![self isPreLoad]) {
            [[self controllerAtIndex:newIndex]beginAppearanceTransition:YES animated:YES];
            [[self controllerAtIndex:oldIndex]beginAppearanceTransition:NO animated:YES];
        }
        [[self controllerAtIndex:newIndex]endAppearanceTransition];
        [[self controllerAtIndex:oldIndex]endAppearanceTransition];
    }
    self.originOffset = scrollView.contentOffset.x;
    self.guessToIndex = self.currentPageIndex;
    if ([self.delegate respondsToSelector:@selector(pageViewController:didTransitionFromViewControlelr:toViewController:)]) {
        [self.delegate pageViewController:self didTransitionFromViewControlelr:[self controllerAtIndex:self.lastSelectedIndex] toViewController:[self controllerAtIndex:self.currentPageIndex]];
    }
}
- (void)updateCurrentIndex:(NSInteger)index{
    self.currentPageIndex = index;
}
- (BOOL)isPreLoad{
    return [self.dataSource respondsToSelector:@selector(isPreLoad)] && [self.dataSource isPreLoad];
}
- (void)addVisibleViewController:(UIViewController *)childController index:(NSInteger)index{
    
    CGRect childViewFrame = [self.scrollView calculateVisibleViewControllerFrameWithIndex:index];
    if (![self.childViewControllers containsObject:childController]) {
         [self addChildViewController:childController];
         [childController didMoveToParentViewController:self];
    }
    [super addChildViewController:childController];
    childController.view.frame = childViewFrame;
    [self.scrollView addSubview:childController.view];
}

- (void)updateScrollViewDisplayIfNeed{
    
    if (self.scrollView.frame.size.width > 0) {
        CGPoint newOffset = [self.scrollView calculateOffsetWithIndex:self.currentPageIndex];
        if (newOffset.x != self.scrollView.contentOffset.x || newOffset.y != self.scrollView.contentOffset.y) {
            self.scrollView.contentOffset = newOffset;
        }
        [self controllerAtIndex:self.currentPageIndex].view.frame = [self.scrollView calculateVisibleViewControllerFrameWithIndex:self.currentPageIndex];
    }
}
- (void)updateScrollViewLayoutIfNeed{
    if (self.scrollView.frame.size.width > 0) {
        [self.scrollView setItem:self.dataSource];
    }
}
- (void)showPageViewAtIndex:(NSInteger)index animated:(BOOL)animated{
    
    if (index < 0 || index >= [self pageCount]) { return;}
    if (self.scrollView.frame.size.width > 0 && self.scrollView.contentSize.width > 0) {
        NSInteger oldSelectIndex = self.lastSelectedIndex;
        self.lastSelectedIndex = self.currentPageIndex;
        self.currentPageIndex = index;
        if ([self.delegate respondsToSelector:@selector(indexWillChange)]) {
            [self.delegate indexWillChange];
        }
        if ([self.delegate respondsToSelector:@selector(pageViewController:willLeaveFromViewControlelr:toViewController:)]) {
            [self.delegate pageViewController:self willLeaveFromViewControlelr:[self controllerAtIndex:self.lastSelectedIndex] toViewController:[self controllerAtIndex:self.currentPageIndex]];
        }
        [self scrollBeginAnimated:animated];
        if (animated) {
            if (self.lastSelectedIndex != self.currentPageIndex) {
                __block CGSize pageSize = self.scrollView.frame.size;
                FDPageScrollDirection direciton = (self.lastSelectedIndex < self.currentPageIndex)?PageRight:PageLeft;
                UIView *lastView = [self controllerAtIndex:self.lastSelectedIndex].view;
                UIView *currentView = [self controllerAtIndex:self.currentPageIndex].view;
                UIView *oldSelectView = [self controllerAtIndex:oldSelectIndex].view;
                NSInteger backgroundIndex = [self.scrollView calculateIndex];
                UIView *backgroundView = nil;
                if (oldSelectView.layer.animationKeys.count > 0 && lastView.layer.animationKeys.count > 0) {
                    UIView *tempView = [self controllerAtIndex:backgroundIndex].view;
                    if (tempView != currentView && tempView != lastView) {
                        backgroundView = tempView;
                        backgroundView.hidden = YES;
                    }
                }
                [self.scrollView.layer removeAllAnimations];
                [oldSelectView.layer removeAllAnimations];
                [lastView.layer removeAllAnimations];
                [currentView.layer removeAllAnimations];
                [self moveBackoOriginPositionIfNeed:oldSelectView index:oldSelectIndex];
                [self.scrollView bringSubviewToFront:lastView];
                [self.scrollView bringSubviewToFront:currentView];
                lastView.hidden = NO;
                currentView.hidden = NO;
                
                CGPoint lastViewStartOrigin = lastView.frame.origin;
                CGPoint currentViewStartOrigin = lastViewStartOrigin;
                CGFloat offset = direciton == PageRight ? self.scrollView.frame.size.width:-self.scrollView.frame.size.width;
                currentViewStartOrigin.x += offset;
                CGPoint lastViewAnimationOrigin = lastViewStartOrigin;
                lastViewAnimationOrigin.x -= offset;
                CGPoint currentViewAnimationOrigin = lastViewStartOrigin;
                CGPoint lastViewEndOrigin = lastViewStartOrigin;
                CGPoint currentViewEndOrigin = currentView.frame.origin;
                lastView.frame = CGRectMake(lastViewStartOrigin.x, lastViewStartOrigin.y, pageSize.width, pageSize.height);
                currentView.frame = CGRectMake(currentViewStartOrigin.x, currentViewStartOrigin.y, pageSize.width, pageSize.height);
                CGFloat duration = 0.3;
                __weak FDPageController *wSelf = self;
                [UIView animateWithDuration:duration animations:^{
                    lastView.frame = CGRectMake(lastViewAnimationOrigin.x, lastViewAnimationOrigin.y, pageSize.width    , pageSize.height);
                    currentView.frame = CGRectMake(currentViewAnimationOrigin.x, currentViewAnimationOrigin.y, pageSize.width, pageSize.height);
                } completion:^(BOOL finished) {
                    FDPageController *bSelf = wSelf;
                    if (finished) {
                        pageSize = bSelf.scrollView.frame.size;
                        lastView.frame = CGRectMake(lastViewEndOrigin.x, lastViewEndOrigin.y,pageSize.width, pageSize.height);
                        currentView.frame = CGRectMake(currentViewEndOrigin.x, currentViewEndOrigin.y, pageSize.width, pageSize.height);
                        backgroundView.hidden = NO;
                        [bSelf moveBackoOriginPositionIfNeed:currentView index:bSelf.currentPageIndex];
                        [bSelf moveBackoOriginPositionIfNeed:lastView index:bSelf.lastSelectedIndex];
                        [bSelf scrollAnimated:animated];
                        [bSelf scrollEndAnimated:animated];
                    }
                }];
            }else{
                [self scrollAnimated:animated];
                [self scrollEndAnimated:animated];
            }
        }else{
            [self scrollAnimated:animated];
            [self scrollEndAnimated:animated];
        }
    }
}
- (void)moveBackoOriginPositionIfNeed:(UIView *)view index:(NSInteger)index{
    
    if (index < 0 || index >= [self pageCount] || !view) { return;}
    UIView *destView = view;
    CGPoint originPosition = [self.scrollView calculateOffsetWithIndex:index];
    if (destView.frame.origin.x != originPosition.x) {
        CGRect newFrame = destView.frame;
        newFrame.origin = originPosition;
        destView.frame = newFrame;
    }
}
- (NSInteger)indexOfController:(UIViewController *)controller{
    for (NSNumber *key in self.memCacheDic) {
        if (controller == self.memCacheDic[key]) {
            return [key integerValue];
        }
    }
    return -1;
}
- (UIViewController *)controllerForIndex:(NSInteger)index{
    if (!self.memCacheDic.count) {
        return nil;
    }
    return [self.memCacheDic objectForKey:@(index)];
}
- (UIViewController *)controllerAtIndex:(NSInteger)index{
    
    if (![self.memCacheDic objectForKey:@(index)]) {
        UIViewController *controller = [self.dataSource controllerAtIndex:index];
        if (controller) {
            if ([controller conformsToProtocol:@protocol(FDPageSubControllerDataSource)]) {
                [self bindController:(UIViewController <FDPageSubControllerDataSource>*)controller index:index];
            }
            [self.memCacheDic setObject:controller forKey:@(index)];
            [self addVisibleViewController:controller index:index];
        }
    }
    return [self.memCacheDic objectForKey:@(index)];
}
- (void)bindController:(UIViewController<FDPageSubControllerDataSource> *)controller index:(NSInteger)index{
    
    UIScrollView *swipeTableView = [controller swipeTableView];
    swipeTableView.scrollsToTop = NO;
    swipeTableView.tag = index;
    if ([self.dataSource respondsToSelector:@selector(pageSwipeTableViewTopInsetAtIndex:)]) {
        UIEdgeInsets contentInset = swipeTableView.contentInset;
        UIEdgeInsets adjustInsets = UIEdgeInsetsMake([self.dataSource pageSwipeTableViewTopInsetAtIndex:index], contentInset.left, contentInset.bottom, contentInset.right);
        swipeTableView.contentInset = adjustInsets;
        swipeTableView.scrollIndicatorInsets = adjustInsets;
    }
    [swipeTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    swipeTableView.contentOffset = CGPointMake(0, -swipeTableView.contentInset.top);
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    
    UIScrollView *swipeTableView = (UIScrollView *)object;
    NSInteger index = swipeTableView.tag;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (swipeTableView.tag != self.currentPageIndex) { return;}
        if (self.memCacheDic.count == 0) { return;}
        BOOL isNotNeedChangeContentOffset = swipeTableView.contentSize.height < (KSCREEN_HEIGHT - KNAVIGATIONANDSTATUSBARHEIGHT) && fabs(self.lastContentSize[@(index)].floatValue - swipeTableView.contentSize.height) > 1.0;
        if (self.delegate.cannotScrollSwipeTableViewWhenLandscapeScrolling || isNotNeedChangeContentOffset) {
            if (self.lastContentOffset[@(index)] && fabs(self.lastContentOffset[@(index)].floatValue - swipeTableView.contentOffset.y) > 0.1) {
                swipeTableView.contentOffset = CGPointMake(0, self.lastContentOffset[@(index)].floatValue);
            }
        }else{
            self.lastContentOffset[@(index)] = @(swipeTableView.contentOffset.y);
            [self.delegate verticalScrollWithPageOffset:swipeTableView.contentOffset.y index:index];
        }
        self.lastContentSize[@(index)] = @(swipeTableView.contentSize.height);
    }
}
#pragma mark ScrollViewAnimate
- (void)scrollAnimated:(BOOL)animated{
    [self.scrollView setContentOffset:[self.scrollView calculateOffsetWithIndex:self.currentPageIndex] animated:NO];
}
- (void)scrollBeginAnimated:(BOOL)animated{
    [[self controllerAtIndex:self.currentPageIndex]beginAppearanceTransition:YES animated:animated];
    if (self.currentPageIndex != self.lastSelectedIndex) {
        [[self controllerAtIndex:self.lastSelectedIndex]beginAppearanceTransition:NO animated:animated];
    }
}
- (void)scrollEndAnimated:(BOOL)animated{
    
    [[self controllerAtIndex:self.currentPageIndex]endAppearanceTransition];
    if (self.currentPageIndex != self.lastSelectedIndex) {
        [[self controllerAtIndex:self.lastSelectedIndex]endAppearanceTransition];
    }
    if ([self.description respondsToSelector:@selector(pageViewController:didLeaveFromViewControlelr:toViewController:)]) {
        [self.delegate pageViewController:self didLeaveFromViewControlelr:[self controllerAtIndex:self.lastSelectedIndex] toViewController:[self controllerAtIndex:self.currentPageIndex]];
    }
}
+ (BOOL)iPhoneX{
    static BOOL b;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        b = CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen]currentMode].size);
    });
    return b;
}
@end
