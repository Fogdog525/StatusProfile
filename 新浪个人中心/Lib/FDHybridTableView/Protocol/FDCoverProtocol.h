//
//  FDCoverProtocol.h
//  FDHybridTableView
//
//  Created by 黄智浩 on 2018/12/15.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STHeaderView.h"
@protocol FDCoverDataSource <NSObject>
@required
- (STHeaderView *)swipeCoverView;
- (CGRect)swipeCoverViewFrame;
@optional
- (NSString *)swipeNavigationBarTitle;
@end
