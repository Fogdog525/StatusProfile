//
//  FDPageContentView.h
//  FDHybridTableView
//
//  Created by 首牛科技 on 2018/12/14.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDPageProtocol.h"
@interface FDPageContentView : UIScrollView
- (CGRect)calculateVisibleViewControllerFrameWithIndex:(NSInteger)index;
- (CGPoint)calculateOffsetWithIndex:(NSInteger)index;
- (NSInteger)calculateIndex;
- (void)setItem:(id<FDPageControllerDataSource>)item;
@end
