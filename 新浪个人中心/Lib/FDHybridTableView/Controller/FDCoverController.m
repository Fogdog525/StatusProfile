//
//  FDCoverController.m
//  FDHybridTableView
//
//  Created by 黄智浩 on 2018/12/15.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import "FDCoverController.h"
#import "STHeaderView.h"
#import "WRNavigationBar.h"
@interface FDCoverController ()<STHeaderViewDelegate>
@property(strong,nonatomic)STHeaderView  *__coverView;
@property (nonatomic,assign)BOOL flag;
@property(assign,nonatomic)NSInteger lastVisibleIndex;
@property(assign,nonatomic)CGFloat   lastAlpha;
@end

@implementation FDCoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastVisibleIndex = [self defaultTabIndex];
    [self __loadCoverView];
    [self __configInitNavigationBar];
}

- (void)__loadCoverView{
    
    self.__coverView = [self swipeCoverView];
    self.__coverView.frame = [self swipeCoverViewFrame];
    self.__coverView.delegate = self;
    [self.view addSubview:self.__coverView];
}
- (void)__configInitNavigationBar{
    
    [self wr_setNavBarBarTintColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    [self wr_setNavBarBackgroundAlpha:0];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarShadowImageHidden:YES];
}
- (void)verticalScrollWithPageOffset:(CGFloat)offset index:(NSInteger)index{
    [super verticalScrollWithPageOffset:offset index:index];
    
  
    CGFloat realOffset = offset + [self pageSwipeTableViewTopInsetAtIndex:index];
    CGFloat top = [self tabY] - realOffset;
    if (realOffset >= 0) {
        if (top <= self.minPullUp) {
            top = self.minPullUp;
        }
    }else{
        if (top >= self.maxPullDown) {
            top = self.maxPullDown;
        }
    }
    realOffset = [self tabY] - top;
    STHeaderView *coverView = (STHeaderView *)self.__coverView;
    CGRect coverFrame = coverView.frame;
    CGFloat coverY = -([self tabY] + 40 - (offset < 0?fabs(offset):-offset));
    coverView.frame = CGRectMake(coverFrame.origin.x, coverY, coverFrame.size.width, coverFrame.size.height);
    [self updateScrollStretchViewHeightWithOffset:coverY];
    [self adjustNavigationBarAlphaWithPageOffset:offset index:index];
}
- (void)adjustNavigationBarAlphaWithPageOffset:(CGFloat)offset index:(NSInteger)index{
    
    if (offset > 0) {
        return;
    }
    CGFloat top = ([WRNavigationBar isIphoneX]) ? 88 : 64;
    CGFloat alpha = 0;
    if (offset > -([self tabY] - 2 * top)) {
        alpha = ([self tabY] - 2 * top - fabs(offset)) / top;
        if (self.lastAlpha >= 1.0){
            alpha = 1.0;
        }
        [self wr_setNavBarBackgroundAlpha:alpha];
        [self wr_setNavBarTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self wr_setNavBarTitleColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
        self.title = [self swipeNavigationBarTitle];
    }else{
        alpha = 0;
        [self wr_setNavBarBackgroundAlpha:alpha];
        [self wr_setNavBarTintColor:[UIColor whiteColor]];
        [self wr_setNavBarTitleColor:[UIColor whiteColor]];
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
        self.title = @"";
    }
    self.lastVisibleIndex = index;
    self.lastAlpha = alpha;
}
- (NSString *)stretchBackgroundImageViewURL{
  return [super stretchBackgroundImageViewURL];
}

#pragma mark STHeaderViewDelegate
- (CGPoint)minHeaderViewFrameOrgin{

    CGFloat minOriginY = -(([self __swipeTableView].contentSize.height + [self tabY] + 40) - [self __swipeTableView].bounds.size.height);
    return CGPointMake(0, fmin(minOriginY, 0));
}
- (CGPoint)maxHeaderViewFrameOrgin{
    return CGPointZero;
}
- (void)headerViewDidFrameChanged:(STHeaderView *)headerView{

        CGRect frame = self.tabBarView.frame;
        CGFloat tabViewY = [self tabY] + headerView.frame.origin.y;
        self.tabBarView.frame = CGRectMake(frame.origin.x, tabViewY, frame.size.width, frame.size.height);
        CGFloat offsetY = -[self tabY] - 40 - headerView.frame.origin.y;
        CGPoint contentOffset = [self __swipeTableView].contentOffset;
        contentOffset.y = offsetY;
        [self __swipeTableView].contentOffset = contentOffset;
        [self updateScrollStretchViewHeightWithOffset:headerView.frame.origin.y];
}
- (CGFloat)pageSwipeTableViewTopInsetAtIndex:(NSInteger)index{
    CGFloat pageTop = [super pageSwipeTableViewTopInsetAtIndex:index];
    return pageTop > ([self swipeCoverViewFrame].origin.y + [self swipeCoverViewFrame].size.height)?pageTop:[self swipeCoverViewFrame].origin.y + [self swipeCoverViewFrame].size.height;
}
- (void)reloadData{
    [super reloadData];
    
    [self.__coverView removeFromSuperview];
    self.__coverView  = nil;
    [self __loadCoverView];
}
#pragma mark FDCoverDataSource
- (STHeaderView *)swipeCoverView{
    return nil;
}
- (CGRect)swipeCoverViewFrame{
    return CGRectZero;
}
- (NSString *)swipeNavigationBarTitle{
    return nil;
}
- (FDCoverStyle)coverStyle{
    return FDCoverStyleStretch;
}
@end
