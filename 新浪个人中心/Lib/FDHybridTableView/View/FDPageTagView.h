//
//  FDPageTagView.h
//  FDHybridTableView
//
//  Created by 首牛科技 on 2018/12/13.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import <UIKit/UIKit.h>
// 继承于:UIControl 方便事件的监听
//  1.字体颜色的渐变  暂时没有解决多颜色的渐变，只解决了普通和高亮两种颜色
//  2.字体大小的渐变
@interface FDPageTagView : UIControl
@property (nonatomic,strong)UIColor *normalTitleColor;
@property (nonatomic,strong)UIColor *highlightedTitleColor;
@property (nonatomic,readonly,assign)BOOL isHighlighted;
- (void)highlightedTagView;
- (void)unhighlightedTagView;
@end

@interface FDPageTagTitleView:FDPageTagView
@property (nonatomic,strong)UILabel *titleLabel;
@end
