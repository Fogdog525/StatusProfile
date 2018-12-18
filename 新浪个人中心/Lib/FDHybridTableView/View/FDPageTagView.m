//
//  FDPageTagView.m
//  FDHybridTableView
//
//  Created by 首牛科技 on 2018/12/13.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#define kTagViewScaleDuration  0.3

#import "FDPageTagView.h"
@interface FDPageTagView()
@property (nonatomic,readwrite,assign)BOOL isHighlighted;
@end
@implementation FDPageTagView
- (void)highlightedTagView{
    NSString *reason = [NSString stringWithFormat:@"%@ must be overrided in subClass!",NSStringFromSelector(_cmd)];
    NSException *exception = [NSException exceptionWithName:@"Method no override Exception" reason:reason userInfo:nil];
    @throw exception;
}
- (void)unhighlightedTagView{
    NSString *reason = [NSString stringWithFormat:@"%@ must be overrided in subClass!",NSStringFromSelector(_cmd)];
    NSException *exception = [NSException exceptionWithName:@"Method no override Exception" reason:reason userInfo:nil];
    @throw exception;
}
@end

@implementation FDPageTagTitleView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.frame           = frame;
        self.titleLabel      = [UILabel new];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.frame = self.bounds;
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}
- (void)highlightedTagView{
     self.titleLabel.textColor = self.highlightedTitleColor;
     self.isHighlighted = YES;
}
- (void)unhighlightedTagView{
     self.isHighlighted = NO;
     self.titleLabel.textColor = self.normalTitleColor;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
}
@end
