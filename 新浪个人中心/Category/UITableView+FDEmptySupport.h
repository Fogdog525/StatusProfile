//
//  UITableView+FDEmptySupport.h
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (FDEmptySupport)
@property(strong,nonatomic)UIImageView *emptyImageView;
@property(strong,nonatomic)UILabel     *emptyLabel;
- (void)fd_emptySupposed:(NSString *)imgName tripStr:(NSString *)str;
@end
