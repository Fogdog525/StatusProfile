//
//  FDPageContentView.m
//  FDHybridTableView
//
//  Created by 首牛科技 on 2018/12/14.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import "FDPageContentView.h"

@implementation FDPageContentView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self __configProperty];
    }
    return self;
}
- (void)__configProperty{
    
    self.autoresizingMask = (0x1<<6) - 1;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.scrollsToTop = NO;
    self.backgroundColor = [UIColor clearColor];
}
- (void)addSubview:(UIView *)view{
    if (![self.subviews containsObject:view]) {
        [super addSubview:view];
    }
}
- (CGRect)calculateVisibleViewControllerFrameWithIndex:(NSInteger)index{
    return CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
}
- (CGPoint)calculateOffsetWithIndex:(NSInteger)index{
    
    CGFloat width = self.frame.size.width;
    CGFloat contentSizeWidth = self.contentSize.width;
    CGFloat offset = index * width;
    return CGPointMake(MAX(0, MIN(offset, (contentSizeWidth - width))), 0);
}
- (NSInteger)calculateIndex{
    
    CGFloat width = self.frame.size.width;
    CGFloat offset = self.contentOffset.x;
    NSInteger index = (NSInteger)offset / width;
    return MAX(0, index);
}
- (void)setItem:(id<FDPageControllerDataSource>)item{
    
    self.contentInset = UIEdgeInsetsZero;
    NSInteger endIndex = [item numberOfControllers];
    self.contentSize = CGSizeMake(endIndex * self.frame.size.width, self.frame.size.height);
}
@end
