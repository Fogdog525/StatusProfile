

#import "UIView+LYExtension.h"
#import <objc/runtime.h>
static char * const kPageDataSource = "LYPageDataSource";
@interface LYWeakObjectContainer:NSObject
@property (nonatomic, readonly, weak) id weakObject;
- (instancetype)initWithWeakObject:(id)object;
@end

@implementation LYWeakObjectContainer
- (instancetype)initWithWeakObject:(id)object{
    self = [super init];
    if (self) {
        _weakObject = object;
    }
    return self;
}
@end

@interface UIView()
@property(nonatomic,copy)void(^reloadAction)(void);
@end

@implementation UIView (LYExtension)
- (void)setLy_x:(CGFloat)ly_x{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = ly_x;
    self.frame = tempFrame;
}
- (void)setLy_y:(CGFloat)ly_y{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = ly_y;
    self.frame = tempFrame;
}
- (void)setLy_width:(CGFloat)ly_width{
    CGRect tempFrame = self.frame;
    tempFrame.size.width = ly_width;
    self.frame = tempFrame;
}
- (void)setLy_height:(CGFloat)ly_height{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = ly_height;
    self.frame = tempFrame;
}
- (CGFloat)ly_x{
    return self.frame.origin.x;
}
- (CGFloat)ly_y{
    return self.frame.origin.y;
}
- (CGFloat)ly_width{
    return self.frame.size.width;
}
- (CGFloat)ly_height{
    return self.frame.size.height;
}
- (void)setLy_dataSource:(id<LYPageDataSource>)ly_dataSource{
    objc_setAssociatedObject(self, kPageDataSource, [[LYWeakObjectContainer alloc]initWithWeakObject:ly_dataSource], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id<LYPageDataSource>)ly_dataSource{
    LYWeakObjectContainer *container = objc_getAssociatedObject(self, kPageDataSource);
    return container.weakObject;
}
- (void)setReloadAction:(void (^)(void))reloadAction{
    objc_setAssociatedObject(self, @selector(reloadAction), reloadAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(void))reloadAction{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLy_loadingPageView:(LYLoadingPageView *)ly_loadingPageView{
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_loadingPageView))];
    objc_setAssociatedObject(self, @selector(ly_loadingPageView), ly_loadingPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_loadingPageView))];
}
- (LYLoadingPageView *)ly_loadingPageView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLy_errorPageView:(LYErrorPageView *)ly_errorPageView{
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_errorPageView))];
    objc_setAssociatedObject(self, @selector(ly_errorPageView), ly_errorPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_errorPageView))];
}
- (LYErrorPageView *)ly_errorPageView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLy_emptyPageView:(LYEmptyPageView *)ly_emptyPageView{
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_emptyPageView))];
    objc_setAssociatedObject(self, @selector(ly_emptyPageView), ly_emptyPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_emptyPageView))];
}
- (LYEmptyPageView *)ly_emptyPageView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLy_customPageView:(LYCustomPageView *)ly_customPageView{
    [self willChangeValueForKey:NSStringFromSelector(@selector(ly_customPageView))];
    objc_setAssociatedObject(self, @selector(ly_customPageView), ly_customPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(ly_customPageView))];
}
- (LYCustomPageView *)ly_customPageView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)ly_beginLoading{
    [self ly_beginLoadingWithOffsetY:0];
}
- (void)ly_beginLoadingWithOffsetY:(CGFloat)offsetY{
    if (self.ly_errorPageView.superview) { [self.ly_errorPageView removeFromSuperview];}
    if (self.ly_emptyPageView.superview) { [self.ly_emptyPageView removeFromSuperview]; }
    if (self.ly_customPageView.superview) { [self.ly_customPageView removeFromSuperview];}
    if (!self.ly_loadingPageView) {
        self.ly_loadingPageView = [[LYLoadingPageView alloc]initWithFrame:self.bounds offset:offsetY];
    }
    [self addSubview:self.ly_loadingPageView];
    [self bringSubviewToFront:self.ly_loadingPageView];
    [self.ly_loadingPageView startAnimation];
}
- (void)ly_endLoading{
    if (self.ly_loadingPageView) {
        [self.ly_loadingPageView stopAnimation];
        [self.ly_loadingPageView removeFromSuperview];
        self.ly_loadingPageView = nil;
    }
}

- (void)ly_configReloadCallBack:(void (^)(void))block{
    self.reloadAction = block;
    if (self.ly_errorPageView && self.reloadAction) {
        self.ly_errorPageView.ClickReloadBlock = self.reloadAction;
    }
}
- (void)ly_showErrorPageView{
    [self ly_showErrorPageViewWithOffsetY:0];
}
- (void)ly_showErrorPageViewWithOffsetY:(CGFloat)offsetY{
    if (self.ly_emptyPageView.superview) { [self.ly_emptyPageView removeFromSuperview]; }
    if (self.ly_customPageView.superview) { [self.ly_customPageView removeFromSuperview];}
    if (self.ly_loadingPageView.superview) {[self.ly_loadingPageView removeFromSuperview];}
    if (!self.ly_errorPageView) {
        self.ly_errorPageView = [[LYErrorPageView alloc]initWithFrame:self.bounds offset:offsetY];
        if (self.reloadAction) {
            self.ly_errorPageView.ClickReloadBlock = self.reloadAction;
        }
    }
    [self addSubview:self.ly_errorPageView];
    [self bringSubviewToFront:self.ly_errorPageView];
}
- (void)ly_hideErrorPageView{
    if (self.ly_errorPageView) {
        [self.ly_errorPageView removeFromSuperview];
        self.ly_errorPageView = nil;
    }
}
- (void)ly_showEmptyPageView{
    [self ly_showEmptyPageViewWithOffsetY:0];
}
- (void)ly_showEmptyPageViewWithOffsetY:(CGFloat)offsetY{
    if (self.ly_errorPageView.superview) { [self.ly_errorPageView removeFromSuperview]; }
    if (self.ly_customPageView.superview) { [self.ly_customPageView removeFromSuperview];}
    if (self.ly_loadingPageView.superview) {[self.ly_loadingPageView removeFromSuperview];}
    if (!self.ly_emptyPageView) {
        self.ly_emptyPageView = [[LYEmptyPageView alloc]initWithFrame:self.bounds offset:offsetY];
        [self addSubview:self.ly_emptyPageView];
        [self bringSubviewToFront:self.ly_emptyPageView];
    }
}
- (void)ly_hideEmptyPageView{
    if (self.ly_emptyPageView) {
        [self.ly_emptyPageView removeFromSuperview];
        self.ly_emptyPageView = nil;
    }
}
- (void)ly_showCustomPageViewWithImage:(UIImage *)image tipString:(NSMutableAttributedString *)tipString{
    
    if (self.ly_errorPageView.superview) { [self.ly_errorPageView removeFromSuperview]; }
    if (self.ly_emptyPageView.superview) { [self.ly_emptyPageView removeFromSuperview];}
    if (self.ly_loadingPageView.superview) {[self.ly_loadingPageView removeFromSuperview];}
    if (!self.ly_customPageView) {
        self.ly_customPageView = [[LYCustomPageView alloc]initWithImage:image tip:tipString];
        self.ly_customPageView.frame = self.bounds;
    }
    [self addSubview:self.ly_customPageView];
    [self bringSubviewToFront:self.ly_customPageView];
}
- (void)ly_hideCustomPageView{
    
    if (self.ly_customPageView) {
        [self.ly_customPageView removeFromSuperview];
        self.ly_customPageView = nil;
    }
}
@end
@interface LYLoadingPageView()
@property (nonatomic,weak)UIActivityIndicatorView *activityView;
@property (nonatomic,weak)UILabel *loadingTipLabel;
@property (nonatomic,assign,readwrite)BOOL isLoading;
@end
@implementation LYLoadingPageView
- (instancetype)initWithFrame:(CGRect)frame offset:(CGFloat)offset{
    if (self = [super initWithFrame:frame]) {
        _isLoading = NO;
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //activityView.color = [UIColor redColor];
        _activityView = activityView;
        _activityView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_activityView];
        
        UILabel* loadingTipLabel = [[UILabel alloc]init];
        loadingTipLabel.numberOfLines = 1;
        loadingTipLabel.font = [UIFont systemFontOfSize:15];
        loadingTipLabel.textAlignment = NSTextAlignmentCenter;
        loadingTipLabel.text = @"正在加载...";
        _loadingTipLabel = loadingTipLabel;
        _loadingTipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_loadingTipLabel];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:_activityView
                                                                             attribute:NSLayoutAttributeCenterX
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1
                                                                              constant:0.0];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_activityView
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1
                                                                              constant:offset];
        [self addConstraint:centerXConstraint];
        [self addConstraint:centerYConstraint];
        
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_loadingTipLabel
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0
                                                                           constant:0.0];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_loadingTipLabel
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0
                                                                            constant:0.0];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_loadingTipLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_activityView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:10];
        [self addConstraint:leftConstraint];
        [self addConstraint:rightConstraint];
        [self addConstraint:topConstraint];
    }
    return self;
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    if (![self.superview isKindOfClass:[UIView class]]) {
        return;
    }
    UIView *superLoadingView = self.superview;
    
    if (superLoadingView.ly_dataSource && [superLoadingView.ly_dataSource respondsToSelector:@selector(ly_loadingTipStr)]) {
        _loadingTipLabel.attributedText = [superLoadingView.ly_dataSource ly_loadingTipStr];
    }else{
        _loadingTipLabel.textColor = [UIColor grayColor];
    }
    if (superLoadingView.ly_dataSource && [superLoadingView.ly_dataSource respondsToSelector:@selector(ly_hideLoadingTip)]) {
        _loadingTipLabel.hidden = [superLoadingView.ly_dataSource ly_hideLoadingTip];
    }
}

- (void)startAnimation{
    self.hidden = NO;
    [_activityView startAnimating];
    _isLoading = YES;
}
- (void)stopAnimation{
    self.hidden = YES;
    [_activityView stopAnimating];
    _isLoading = NO;
}

@end
@interface LYErrorPageView()
@property (nonatomic,weak) UIImageView *errorImageView;
@property (nonatomic,weak) UILabel *errorTipLabel;
@property (nonatomic,weak) UIButton *reloadButton;
@end

@implementation LYErrorPageView
- (instancetype)initWithFrame:(CGRect)frame offset:(CGFloat)offset{
    if (self = [super initWithFrame:frame]) {
        UIImageView* errorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"物理"]];
        _errorImageView = errorImageView;
        errorImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_errorImageView];
        
        UILabel* errorTipLabel = [[UILabel alloc]init];
        errorTipLabel.numberOfLines = 2;
        errorTipLabel.font = [UIFont systemFontOfSize:15];
        errorTipLabel.textAlignment = NSTextAlignmentCenter;
        errorTipLabel.textColor = [UIColor grayColor];
         //default errorStr
        errorTipLabel.text = @"很抱歉,网络似乎出了点状况~~~~";
        errorTipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _errorTipLabel = errorTipLabel;
        [self addSubview:_errorTipLabel];
        
        UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        reloadButton.translatesAutoresizingMaskIntoConstraints = NO;
        [reloadButton setTitle:@"点击重新加载" forState:UIControlStateNormal];
        reloadButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [reloadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [reloadButton addTarget:self action:@selector(_clickReloadButton:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton = reloadButton;
        [self addSubview:_reloadButton];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_errorImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_errorImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0];
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:_errorImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_errorImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:offset];
        [_errorImageView addConstraint:widthConstraint];
        [_errorImageView addConstraint:heightConstraint];
        [self addConstraint:centerXConstraint];
        [self addConstraint:centerYConstraint];
        
        NSLayoutConstraint *errTipLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:_errorTipLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *errTipLabelRightConstraint = [NSLayoutConstraint constraintWithItem:_errorTipLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *errTipLabelTopConstraint = [NSLayoutConstraint constraintWithItem:_errorTipLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_errorImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0];
        [self addConstraint:errTipLabelLeftConstraint];
        [self addConstraint:errTipLabelRightConstraint];
        [self addConstraint:errTipLabelTopConstraint];
        
        NSLayoutConstraint *reloadButtonCenterXConstraint = [NSLayoutConstraint constraintWithItem:_reloadButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        NSLayoutConstraint *reloadButtonTopConstraint = [NSLayoutConstraint constraintWithItem:_reloadButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_errorTipLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0];
        [self addConstraint:reloadButtonTopConstraint];
        [self addConstraint:reloadButtonCenterXConstraint];
        
    }
    return self;
}
- (void)_clickReloadButton:(UIButton *)btn{
    
    if (_ClickReloadBlock) {
        _ClickReloadBlock();
    }
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    if (![self.superview isKindOfClass:[UIView class]]) {
        return;
    }
    UIView *superErrorView = self.superview;
    if (superErrorView.ly_dataSource && [superErrorView.ly_dataSource respondsToSelector:@selector(ly_errorTipStr)]) {
        _errorTipLabel.attributedText = [superErrorView.ly_dataSource ly_errorTipStr];
    }
    if (superErrorView.ly_dataSource && [superErrorView.ly_dataSource respondsToSelector:@selector(ly_errorReloadButtonTitleStr)]) {
        [_reloadButton setAttributedTitle:[superErrorView.ly_dataSource ly_errorReloadButtonTitleStr] forState:UIControlStateNormal];
    }
    if (superErrorView.ly_dataSource && [superErrorView.ly_dataSource respondsToSelector:@selector(ly_errorPlaceImage)]) {
        _errorImageView.image = [superErrorView.ly_dataSource ly_errorPlaceImage];
    }
}
@end

@interface LYEmptyPageView()
@property (nonatomic,weak) UIImageView *nodataImageView;
@property (nonatomic,weak) UILabel *nodataTipLabel;

@end

@implementation LYEmptyPageView
- (instancetype)initWithFrame:(CGRect)frame offset:(CGFloat)offset{
    if (self = [super initWithFrame:frame]) {
        UIImageView *nodataImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"物理"]];
        _nodataImageView = nodataImageView;
        _nodataImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_nodataImageView];

        UILabel *nodataTipLabel = [[UILabel alloc]init];
        nodataTipLabel.numberOfLines = 1;
        nodataTipLabel.font = [UIFont systemFontOfSize:15];
        nodataTipLabel.textAlignment = NSTextAlignmentCenter;
        nodataTipLabel.textColor = [UIColor grayColor];
        //default tipStr
        nodataTipLabel.text = @"这里没有数据呢,赶紧弄出点动静吧~";
        _nodataTipLabel = nodataTipLabel;
        _nodataTipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_nodataTipLabel];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_nodataImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_nodataImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0];
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:_nodataImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_nodataImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:offset];
        [_nodataImageView addConstraint:widthConstraint];
        [_nodataImageView addConstraint:heightConstraint];
        [self addConstraint:centerXConstraint];
        [self addConstraint:centerYConstraint];
        
        NSLayoutConstraint *nodataTipLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:_nodataTipLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *nodataTipLabelRightConstraint = [NSLayoutConstraint constraintWithItem:_nodataTipLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *nodataTipLabelTopConstraint = [NSLayoutConstraint constraintWithItem:_nodataTipLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_nodataImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0];
        [self addConstraint:nodataTipLabelLeftConstraint];
        [self addConstraint:nodataTipLabelRightConstraint];
        [self addConstraint:nodataTipLabelTopConstraint];
    }
    return self;
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    if (![self.superview isKindOfClass:[UIView class]]) {
        return;
    }
    UIView *superEmptyView = self.superview;
    if (superEmptyView.ly_dataSource && [superEmptyView.ly_dataSource respondsToSelector:@selector(ly_emptyTipStr)]) {
        _nodataTipLabel.attributedText = [superEmptyView.ly_dataSource ly_emptyTipStr];
    }
    if (superEmptyView.ly_dataSource && [superEmptyView.ly_dataSource respondsToSelector:@selector(ly_emptyPlaceImage)]) {
        _nodataImageView.image = [superEmptyView.ly_dataSource ly_emptyPlaceImage];
    }
}
@end
@interface LYCustomPageView()
@property (nonatomic,strong)UIImageView *customImageView;
@property (nonatomic,strong)UILabel *tipLabel;
@end
@implementation LYCustomPageView
- (instancetype)initWithImage:(UIImage *)image tip:(NSMutableAttributedString *)tip{
    if (self = [super init]) {
        UIImageView* customImageView = [UIImageView new];
        customImageView.image = image;
        _customImageView = customImageView;
        _customImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_customImageView];
        
        UILabel* tipLabel = [[UILabel alloc]init];
        tipLabel.numberOfLines = 1;
        tipLabel.font = [UIFont systemFontOfSize:15];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = [UIColor grayColor];
        tipLabel.attributedText = tip;
        _tipLabel = tipLabel;
        _tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_tipLabel];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:_customImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_customImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-10.0];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_customImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_customImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60];
        [self addConstraint:centerXConstraint];
        [self addConstraint:centerYConstraint];
        [_customImageView addConstraint:widthConstraint];
        [_customImageView addConstraint:heightConstraint];
        
        NSLayoutConstraint *tipLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:_tipLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *tipLabelRightConstraint = [NSLayoutConstraint constraintWithItem:_tipLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *tipLabelTopConstraint = [NSLayoutConstraint constraintWithItem:_tipLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_customImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0];
        [self addConstraint:tipLabelLeftConstraint];
        [self addConstraint:tipLabelRightConstraint];
        [self addConstraint:tipLabelTopConstraint];
    }
    return self;
}
@end

