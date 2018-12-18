
#import <UIKit/UIKit.h>
//数据源
@protocol LYPageDataSource <NSObject>
@optional
//loading的文字设置
- (NSMutableAttributedString *)ly_loadingTipStr;
//是否隐藏loading的文字
- (BOOL)ly_hideLoadingTip;

//空数据的文字设置
- (NSMutableAttributedString *)ly_emptyTipStr;
/**自定义图片，如果图片大小不合适，可以自己修改即可(当然一般图片尺寸应该都是相同的)*/
- (UIImage *)ly_emptyPlaceImage;

//出错文字设置
- (NSMutableAttributedString *)ly_errorTipStr;
//重新加载按钮文字设置
- (NSMutableAttributedString *)ly_errorReloadButtonTitleStr;
//自定义出错的图片
- (UIImage *)ly_errorPlaceImage;
@end

@class LYLoadingPageView,LYEmptyPageView,LYErrorPageView,LYCustomPageView;
@interface UIView (LYExtension)
@property (nonatomic,assign)CGFloat ly_x;
@property (nonatomic,assign)CGFloat ly_y;
@property (nonatomic,assign)CGFloat ly_width;
@property (nonatomic,assign)CGFloat ly_height;

//数据源
@property (nonatomic,weak)id<LYPageDataSource>ly_dataSource;

//loading
@property (nonatomic,strong)LYLoadingPageView *ly_loadingPageView;
//开始加载loading动画
- (void)ly_beginLoading;
//结束loading动画
- (void)ly_endLoading;
//额外的方法，提供相对于屏幕中心点Y坐标的偏移
- (void)ly_beginLoadingWithOffsetY:(CGFloat)offsetY;

//empty
@property (nonatomic,strong)LYEmptyPageView *ly_emptyPageView;
//出现空的占位图
- (void)ly_showEmptyPageView;
//隐藏空的占位图
- (void)ly_hideEmptyPageView;
//额外的方法，提供相对于屏幕中心点Y坐标的偏移
- (void)ly_showEmptyPageViewWithOffsetY:(CGFloat)offsetY;

//error
@property (nonatomic,strong)LYErrorPageView *ly_errorPageView;
//点击按钮进行重新加载数据
- (void)ly_configReloadCallBack:(void(^)(void))block;
//出现请求错误的占位图
- (void)ly_showErrorPageView;
//隐藏请求错误的占位图
- (void)ly_hideErrorPageView;
//额外的方法，提供相对于屏幕中心点Y坐标的偏移
- (void)ly_showErrorPageViewWithOffsetY:(CGFloat)offsetY;

//custom
@property (nonatomic,strong)LYCustomPageView *ly_customPageView;
//出现自定义的占位图
- (void)ly_showCustomPageViewWithImage:(UIImage *)image tipString:(NSMutableAttributedString *)tipString;
//隐藏自定义的占位图
- (void)ly_hideCustomPageView;
@end

@interface LYLoadingPageView:UIView
//私有的api
- (void)startAnimation;
- (void)stopAnimation;
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame offset:(CGFloat)offset;
@end

@interface LYEmptyPageView:UIView
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame offset:(CGFloat)offset;
@end

@interface LYErrorPageView:UIView
//私有的api
@property (nonatomic,copy)void(^ClickReloadBlock)(void);
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame offset:(CGFloat)offset;
@end

@interface LYCustomPageView:UIView
//私有的api
- (instancetype)initWithImage:(UIImage* )image
                          tip:(NSMutableAttributedString* )tip;
@end
