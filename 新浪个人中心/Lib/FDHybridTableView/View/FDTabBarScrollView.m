//
//  FDTabBarScrollView.m
//  FDHybridTableView
//
//  Created by 首牛科技 on 2018/12/13.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import "FDTabBarScrollView.h"
#import "FDPageTagView.h"

struct Color_Struct{
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
};
static float diffOfColorValue(float from,float to){
    return to - from;
}
static float valueOfColorByProgress(float x,float y,float p){
    return diffOfColorValue(x, y) * p;
}
@interface FDTabBarScrollView()
@property (nonatomic,weak,readwrite)id<FDTabDataSource>tabDataSource;
@property (nonatomic,weak,readwrite)id<FDTabDelegate>tabDelegate;
@property (nonatomic,strong)NSMutableArray<FDPageTagTitleView *> *tagViewsCache;
@property (nonatomic,strong)NSMutableArray<NSNumber *> *tagViewsWidthCache;
@property (nonatomic)NSInteger index;
@property (nonatomic)struct Color_Struct fromColor,toColor;
@property (nonatomic,strong)CAShapeLayer *cater;
@end
@implementation FDTabBarScrollView
- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(id<FDTabDataSource>)dataSource
                     delegate:(id<FDTabDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.tabDataSource = dataSource;
        self.tabDelegate   = delegate;
        [self __configProperty];
        [self __calculateTagViewsWidth];
        [self __configGradientCater];
        [self __configFirstIndex];
    }
    return self;
}

- (void)__configProperty{
    
    self.contentSize = CGSizeZero;
    self.directionalLockEnabled = YES;
    self.scrollsToTop = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    self.tagViewsCache = @[].mutableCopy;
    self.tagViewsWidthCache = @[].mutableCopy;
}
- (void)__layoutPageTagView{
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat minSpace = [self.tabDataSource respondsToSelector:@selector(preferMinSpace)]?[self.tabDataSource preferMinSpace]:45;
    CGFloat tabContentWidth = 0;
    CGFloat exceptScreenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger numberOfTab = [self.tabDataSource numberOfTab];
    for (int i = 0; i < numberOfTab; i ++) {
        CGFloat tagViewWidth = [[self.tagViewsWidthCache objectAtIndex:i]floatValue];
        tabContentWidth += tagViewWidth;
    }
    CGFloat selfCanScrollMaxDistance = tabContentWidth + minSpace * (numberOfTab + 1);
    self.contentSize = CGSizeMake(selfCanScrollMaxDistance, self.frame.size.height);
    CGFloat tempContentWidth = 0;
    CGFloat leftOffset = (exceptScreenWidth - (numberOfTab - 1) * minSpace - tabContentWidth) * 0.5;
    BOOL isContentLessThanExceptScreenWidth = selfCanScrollMaxDistance < exceptScreenWidth;
    for (int i = 0; i < numberOfTab; i ++) {
        CGFloat left = i == 0?(isContentLessThanExceptScreenWidth?leftOffset:minSpace):(isContentLessThanExceptScreenWidth?(leftOffset + minSpace * i + tempContentWidth):minSpace * (i + 1) + tempContentWidth);
        CGFloat top = 0;
        CGFloat width = [[self.tagViewsWidthCache objectAtIndex:i]floatValue] + 8;
        CGFloat height = self.frame.size.height;
        FDPageTagTitleView *titleView = [[FDPageTagTitleView alloc]initWithFrame:CGRectMake(left, top, width, height)];
        titleView.normalTitleColor = [self.tabDataSource respondsToSelector:@selector(titleColor)]?[self.tabDataSource titleColor]:[UIColor blackColor];
        titleView.highlightedTitleColor = [self.tabDataSource respondsToSelector:@selector(titleHighlightColor)]?[self.tabDataSource titleHighlightColor]:[UIColor orangeColor];
        titleView.titleLabel.text = [self.tabDataSource titleForIndex:i];
        titleView.titleLabel.font = [self.tabDataSource respondsToSelector:@selector(titleFont)]?[self.tabDataSource titleFont]:[UIFont systemFontOfSize:16];
        titleView.tag = i;
        [titleView addTarget:self action:@selector(pressTab:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleView];
        [self.tagViewsCache addObject:titleView];
        tempContentWidth += [[self.tagViewsWidthCache objectAtIndex:i]floatValue];
    }
    [self reloadHighlight];
    if ([self.tabDataSource respondsToSelector:@selector(tabBackgroundColor)]) {
        self.backgroundColor = [self.tabDataSource tabBackgroundColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}
- (void)__configFirstIndex{
    
    NSInteger index = [self.tabDataSource respondsToSelector:@selector(defaultTabIndex)]?[self.tabDataSource defaultTabIndex]:0;
    self.index = index;
    [self tabBarScrollToIndex:index];
    [self caterScrollToIndex:index];
}
- (void)__calculateTagViewsWidth{
    
    UIFont *font = [self.tabDataSource respondsToSelector:@selector(titleFont)]?[self.tabDataSource titleFont]:[UIFont systemFontOfSize:16];
    for (int i = 0; i < [self.tabDataSource numberOfTab]; i ++) {
        NSString *tagTitle = [self.tabDataSource titleForIndex:i];
        CGFloat  tagTitleWidth = [tagTitle boundingRectWithSize:CGSizeMake(20000, self.frame.size.height) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
        [self.tagViewsWidthCache addObject:@(tagTitleWidth)];
    }
    [self __layoutPageTagView];
}

- (void)__configGradientCater{
    
    CGFloat caterMoveDistance = MAX(self.frame.size.width, self.contentSize.width);
    UIView *caterBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 6, caterMoveDistance, 4)];
    caterBackgroundView.backgroundColor = [UIColor redColor];
    [self addSubview:caterBackgroundView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = caterBackgroundView.bounds;
    gradientLayer.locations = @[@0.4,@0.7];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    CGColorRef headColor = [self.tabDataSource respondsToSelector:@selector(caterGradientHeadColor)]?[self.tabDataSource caterGradientHeadColor].CGColor:[UIColor orangeColor].CGColor;
    CGColorRef footColor = [self.tabDataSource respondsToSelector:@selector(caterGradientfootColor)]?[self.tabDataSource caterGradientfootColor].CGColor:[UIColor redColor].CGColor;
    gradientLayer.colors = @[(__bridge id)headColor,(__bridge id)footColor];
    
    [caterBackgroundView.layer addSublayer:gradientLayer];
    
    _cater = [CAShapeLayer layer];
    _cater.backgroundColor = [UIColor whiteColor].CGColor;
    CGFloat height = [self.tabDataSource respondsToSelector:@selector(caterHight)]?[self.tabDataSource caterHight]:4;
    _cater.frame = CGRectMake(0, caterBackgroundView.frame.size.height - height, [self.tabDataSource respondsToSelector:@selector(caterWidth)]?[self.tabDataSource caterWidth]:25, height);
    _cater.cornerRadius = 0.5 * height;
    _cater.masksToBounds = YES;
    caterBackgroundView.layer.mask = _cater;
}
- (struct Color_Struct)fromColor{
    return [self __fetchColorValueForColor:[self.tabDataSource respondsToSelector:@selector(titleColor)]?[self.tabDataSource titleColor]:[UIColor blackColor]];
}
- (struct Color_Struct)toColor{
    return [self __fetchColorValueForColor:[self.tabDataSource respondsToSelector:@selector(titleHighlightColor)]?[self.tabDataSource titleHighlightColor]:[UIColor orangeColor]];
}
- (void)pressTab:(FDPageTagTitleView *)sender{
    
    NSInteger tag = sender.tag;
    [self.tabDelegate didPressTabForIndex:tag];
    self.index = tag;
    [self reloadHighlight];
}
- (void)reloadHighlight{
    
    for (int i = 0; i < self.tagViewsCache.count; i ++) {
        FDPageTagTitleView *view = (FDPageTagTitleView *)self.tagViewsCache[i];
        if (i == self.index) {
            [view highlightedTagView];
        }else{
            [view unhighlightedTagView];
        }
    }
}
- (struct Color_Struct)__fetchColorValueForColor:(UIColor *)color{
    
    struct Color_Struct containerColor;
    CGFloat redValue    = 0;
    CGFloat greenValue  = 0;
    CGFloat blueValue   = 0;
    CGFloat  alphaValue = 1.0;
    [color getRed:&redValue
            green:&greenValue
             blue:&blueValue
            alpha:&alphaValue];
    containerColor.r = redValue;
    containerColor.g = greenValue;
    containerColor.b = blueValue;
    containerColor.a = alphaValue;
    return containerColor;
}
- (void)caterScrollToContentRatio:(CGFloat)contentRatio{
    
    int fromIndex = ceil(contentRatio) - 1;
    if (fromIndex < 0 || self.tagViewsCache.count <= fromIndex + 1) { return; }
    CGFloat progress = (contentRatio - fromIndex);
    
    FDPageTagTitleView *curTagView = self.tagViewsCache[fromIndex];
    FDPageTagTitleView *nextTagView = self.tagViewsCache[fromIndex + 1];
    [self __caterFrameChangedWithProgress:progress curTagView:curTagView nextTagView:nextTagView];
    [self __changeTagTitleColorWithProgress:progress curTagView:curTagView nextTagView:nextTagView];
}
- (void)caterScrollToIndex:(NSInteger)index{
    
    if (index >= self.tagViewsCache.count || index < 0) { return;}
    FDPageTagTitleView *curTagView = self.tagViewsCache[index];
    self.cater.position = CGPointMake(curTagView.center.x, self.cater.position.y);
    [self reloadHighlight];
}
- (void)reloadHighlightForIndex:(NSInteger)index{
    self.index = index;
    [self reloadHighlight];
}
- (void)tabBarScrollToIndex:(NSInteger)toIndex{
    
    if (self.tagViewsCache.count <= toIndex || self.contentSize.width < self.frame.size.width) { return;}
    FDPageTagTitleView *nextTagView = [self.tagViewsCache objectAtIndex:toIndex];
    CGFloat exceptScrollWidth = self.frame.size.width;
    CGFloat tagExceptInScreen = nextTagView.center.x - exceptScrollWidth * 0.5;
    CGFloat tagExceptMaxInScreen = self.contentSize.width - exceptScrollWidth;
    CGFloat offsetX = MAX(0, MIN(tagExceptInScreen, tagExceptMaxInScreen));
    CGPoint offset = CGPointMake(offsetX, 0);
    [self setContentOffset:offset animated:YES];
}
- (void)__caterFrameChangedWithProgress:(CGFloat)progress
                             curTagView:(FDPageTagTitleView *)curTagView
                            nextTagView:(FDPageTagTitleView *)nextTagView{
    
    CGFloat diffDistance = nextTagView.center.x - curTagView.center.x;
    CGFloat width = [self.tabDataSource respondsToSelector:@selector(caterWidth)]?[self.tabDataSource caterWidth]:25;
    CGFloat originX = curTagView.center.x - 0.5 * width;
    CGRect newFrame = self.cater.frame;
    if (progress < 0.5) {
        newFrame.origin.x = originX;
        newFrame.size.width = width + diffDistance * progress * 2;
    }else{
        newFrame.origin.x = originX + diffDistance * (progress - 0.5) * 2;
        newFrame.size.width = width + diffDistance - diffDistance * (progress - 0.5) * 2;
    }
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.cater.frame = newFrame;
    [CATransaction commit];
}
- (void)__changeTagTitleColorWithProgress:(CGFloat)progress
                               curTagView:(FDPageTagTitleView *)curTagView
                              nextTagView:(FDPageTagTitleView *)nextTagView{
    
    CGFloat from_r = self.toColor.r - valueOfColorByProgress(self.fromColor.r, self.toColor.r, progress);
    CGFloat from_g = self.toColor.g - valueOfColorByProgress(self.fromColor.g, self.toColor.g, progress);
    CGFloat from_b = self.toColor.b - valueOfColorByProgress(self.fromColor.b, self.toColor.b, progress);
    CGFloat to_r = self.fromColor.r + valueOfColorByProgress(self.fromColor.r, self.toColor.r, progress);
    CGFloat to_g = self.fromColor.g + valueOfColorByProgress(self.fromColor.g, self.toColor.g, progress);
    CGFloat to_b = self.fromColor.b + valueOfColorByProgress(self.fromColor.b, self.toColor.b, progress);
    
    curTagView.titleLabel.textColor = [UIColor colorWithRed:from_r
                                                      green:from_g
                                                       blue:from_b
                                                      alpha:1.0];
    nextTagView.titleLabel.textColor = [UIColor colorWithRed:to_r
                                                       green:to_g
                                                        blue:to_b
                                                       alpha:1.0];
}
@end




