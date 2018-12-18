//
//  FDPageController.h
//  FDHybridTableView
//
//  Created by 首牛科技 on 2018/12/14.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//


#define KSCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define KSTATUSBARHEIGHT ([FDPageController iPhoneX]?44.0:20.0)
#define KNAVIGATIONANDSTATUSBARHEIGHT (KSTATUSBARHEIGHT+44.0)

#import <UIKit/UIKit.h>
#import "FDPageProtocol.h"
@interface FDPageController : UIViewController
@property (nonatomic,weak)id<FDPageControllerDataSource> dataSource;
@property (nonatomic,weak)id<FDPageControllerDelegate> delegate;
@property (nonatomic,assign,readonly)NSInteger currentPageIndex;
- (void)reloadPage;
- (void)updateCurrentIndex:(NSInteger)index;
- (NSInteger)indexOfController:(UIViewController *)controller;
- (void)showPageViewAtIndex:(NSInteger)index animated:(BOOL)animated;
- (UIViewController *)controllerForIndex:(NSInteger)index;
+ (BOOL)iPhoneX;
@end
