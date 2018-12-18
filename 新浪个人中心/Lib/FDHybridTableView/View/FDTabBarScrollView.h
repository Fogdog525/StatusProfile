//
//  FDTabBarScrollView.h
//  FDHybridTableView
//
//  Created by 首牛科技 on 2018/12/13.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDTabProtocol.h"
@interface FDTabBarScrollView : UIScrollView
@property (nonatomic,weak,readonly)id<FDTabDataSource>tabDataSource;
@property (nonatomic,weak,readonly)id<FDTabDelegate>tabDelegate;
- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(id<FDTabDataSource>)dataSource
                     delegate:(id<FDTabDelegate>)delegate;

- (void)caterScrollToContentRatio:(CGFloat)contentRatio;
- (void)caterScrollToIndex:(NSInteger)index;
- (void)tabBarScrollToIndex:(NSInteger)toIndex;
- (void)reloadHighlightForIndex:(NSInteger)index;
@end

