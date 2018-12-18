//
//  FDTabProtocol.h
//  FDHybridTableView
//
//  Created by 首牛科技 on 2018/12/13.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import <Foundation/Foundation.h>
///
/// 标签菜单栏的相关协议都是在这个类里面
///
@protocol FDTabDataSource <NSObject>
@required
- (NSString *)titleForIndex:(NSInteger)index;
@optional
- (NSInteger)numberOfTab;
- (CGFloat)preferMinSpace;
- (CGFloat)tabWidthForIndex:(NSInteger)index;
- (UIFont *)titleFont;
- (UIFont *)titleHighlightFont;
- (UIColor *)tabBackgroundColor;
- (UIColor *)titleColor;
- (UIColor *)titleHighlightColor;
- (UIColor *)caterGradientHeadColor;
- (UIColor *)caterGradientfootColor;
- (CGFloat)caterHight;
- (CGFloat)caterWidth;
- (CGFloat)tabY;
- (NSInteger)defaultTabIndex;
@end

@protocol FDTabDelegate <NSObject>
@optional
- (void)didPressTabForIndex:(NSInteger)index;
@end
