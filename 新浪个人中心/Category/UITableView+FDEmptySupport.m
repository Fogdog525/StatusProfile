//
//  UITableView+FDEmptySupport.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "UITableView+FDEmptySupport.h"
#import <objc/runtime.h>
static const char *emptyImageViewKey = "emptyImageViewKey";
static const char *emptylabelKey = "emptylabelKey";
@implementation UITableView (FDEmptySupport)
- (void)setEmptyImageView:(UIImageView *)emptyImageView{
    objc_setAssociatedObject(self, emptyImageViewKey, emptyImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImageView *)emptyImageView{
    return objc_getAssociatedObject(self, emptyImageViewKey);
}
- (void)setEmptyLabel:(UILabel *)emptyLabel{
     objc_setAssociatedObject(self, emptylabelKey, emptyLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel *)emptyLabel{
    return objc_getAssociatedObject(self, emptylabelKey);
}

- (void)fd_emptySupposed:(NSString *)imgName
                 tripStr:(NSString *)str{
    
    UIImage *img = [UIImage imageNamed:imgName];
    self.emptyImageView = [[UIImageView alloc]initWithImage:img];
    self.emptyImageView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 170);
    [self addSubview:self.emptyImageView];
    
    self.emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(self.emptyImageView.frame) + 10, CGRectGetWidth(self.frame) - 100, 25)];
    self.emptyLabel.text = str;
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyLabel.font = [UIFont systemFontOfSize:15];
    self.emptyLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.emptyLabel];
}
@end
