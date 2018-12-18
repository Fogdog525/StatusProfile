//
//  SinaFile.h
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/16.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#ifndef SinaFile_h
#define SinaFile_h

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import <YYModel.h>
#import <ReactiveObjC.h>
#import <Masonry.h>
#import "UIImageView+ZJCornerRadiusHelperKit.h"
#import "FDFetchData.h"
#import <YYText.h>
#import "UIView+LYExtension.h"
#import "OCTStatusConst.h"
#import "OCTAdaption.h"
#import <RegexKitLite.h>
#import "OCTEmojiManager.h"
#import "UIImage+OCTSupport.h"
#import "FDReactive.h"
#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#endif /* SinaFile_h */
