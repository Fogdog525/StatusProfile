//
//  OCTStatusConst.h
//  SinaMVVM
//
//  Created by SD on 2018/11/5.
//  Copyright © 2018年 Mr.Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaFile.h"
@interface OCTStatusConst : NSObject

/*******一些常量*******/
//昵称的字体大小
UIKIT_EXTERN CGFloat const kStatusNameFontSize;
//正文内容字体大小
UIKIT_EXTERN CGFloat const kStatusTextFontSize;
//微博上边距
UIKIT_EXTERN CGFloat const kStatusCellTopMargin;
//微博左边的边距
UIKIT_EXTERN CGFloat const kStatusCellLeftMargin;
//时间和来源的字体大小
UIKIT_EXTERN CGFloat const kStatusSourceFontSize;
//图片的数目
UIKIT_EXTERN NSUInteger const kStatusPhotoCount;
//图片之间的间隙
UIKIT_EXTERN CGFloat const kStatusPhotoSpace;

UIKIT_EXTERN CGFloat const kStatusBottomBarHeight;
//正则表达式

UIKIT_EXTERN NSString *const kRegexOfAt;
UIKIT_EXTERN NSString *const kRegexOfTopic;
UIKIT_EXTERN NSString *const kRegexOfURL;
UIKIT_EXTERN NSString *const kRegexOfEmoji;
UIKIT_EXTERN NSString *const kRegexOfPhone;
UIKIT_EXTERN NSString *const kRegexOfEmail;
//color
//VIP字体颜色
#define kStatusVipNameColor  HexRGB(0xF26220)
//普通用户字体颜色
#define kStatusNormalColor   HexRGB(0x333333)
//时间和来源的字体颜色
#define kStatusSourceTimeColor HexRGB(0x828282)
//链接颜色
#define kStatusSourceLinkColor  HexRGB(0x527ead)
//链接点击的背景颜色
#define kStatusHighlightLinkColor  HexRGB(0x5d5d5d)
//转发微博背景颜色
#define kStatusRetweetBackgroundColor HexRGB(0xF5F5F5)

#define kStatusColor_FFFFFF           HexRGB(0xffffff)         

//这里不需要适配   因为在布局的时候会适配
#define kStatusNameWidth     WIDTH - 82
#define kStatusTextWidth     WIDTH - 2 * kStatusCellLeftMargin
@end
