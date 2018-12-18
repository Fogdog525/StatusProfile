//
//  FDPageProtocol.h
//  FDHybridTableView
//
//  Created by 首牛科技 on 2018/12/14.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FDPageController;
@protocol FDPageControllerDataSource <NSObject>
@required
- (NSInteger)numberOfControllers;
- (UIViewController *)controllerAtIndex:(NSInteger)index;
- (CGRect)pageFrame;
- (NSString *)stretchBackgroundImageViewURL;
@optional
- (CGFloat)pageSwipeTableViewTopInsetAtIndex:(NSInteger)index;
- (BOOL)isPreLoad;
@end

@protocol FDPageControllerDelegate <NSObject>
@optional
- (void)pageViewController:(FDPageController *)pageController willTransitionFromViewControlelr:(UIViewController *)fromViewControlelr toViewController:(UIViewController *)toViewControlelr;
- (void)pageViewController:(FDPageController *)pageController didTransitionFromViewControlelr:(UIViewController *)fromViewControlelr toViewController:(UIViewController *)toViewControlelr;
- (void)pageViewController:(FDPageController *)pageController willLeaveFromViewControlelr:(UIViewController *)fromViewControlelr toViewController:(UIViewController *)toViewControlelr;
- (void)pageViewController:(FDPageController *)pageController didLeaveFromViewControlelr:(UIViewController *)fromViewControlelr toViewController:(UIViewController *)toViewControlelr;
- (void)landscapeScrollContentOffsetWithRatio:(CGFloat)ratio;
- (void)verticalScrollWithPageOffset:(CGFloat)offset index:(NSInteger)index;
- (void)indexWillChange;
- (BOOL)cannotScrollSwipeTableViewWhenLandscapeScrolling;
@end

@protocol FDPageSubControllerDataSource <NSObject>
- (UIScrollView *)swipeTableView;
@end
