//
//  FDTabController.h
//  FDHybridTableView
//
//  Created by 黄智浩 on 2018/12/15.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDPageProtocol.h"
#import "FDTabProtocol.h"
@interface FDTabController : UIViewController<FDPageControllerDelegate,FDTabDataSource,FDPageControllerDataSource>
@property(nonatomic)CGFloat maxPullDown;
@property(nonatomic)CGFloat minPullUp;
@property(strong,nonatomic)UIView *tabBarView;
@property(nonatomic,strong,readonly)UIImageView *scrollStretchView;
- (NSInteger)preferDisplayPageIndex;
- (UIScrollView *)__swipeTableView;
- (void)reloadData;
- (void)updateScrollStretchViewHeightWithOffset:(CGFloat)offset;
- (UIViewController *)visibleViewController;
@end
