//
//  OCTStatusConst.m
//  SinaMVVM
//
//  Created by SD on 2018/11/5.
//  Copyright © 2018年 Mr.Huang. All rights reserved.
//

#import "OCTStatusConst.h"

@implementation OCTStatusConst

CGFloat const kStatusNameFontSize = 15.f;
CGFloat const kStatusTextFontSize = 17.f;
CGFloat const kStatusCellTopMargin = 8.f;
CGFloat const kStatusCellLeftMargin = 12.f;
CGFloat const kStatusSourceFontSize = 12.f;
NSUInteger const kStatusPhotoCount = 9;
CGFloat const kStatusPhotoSpace = 5.f;
CGFloat const kStatusBottomBarHeight = 40.f;

NSString *const kRegexOfAt = @"@[-_a-zA-Z0-9\u4E00-\u9FA5]+";
NSString *const kRegexOfTopic = @"#[^@#]+?#";
NSString *const kRegexOfURL = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
NSString *const kRegexOfEmoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
NSString *const kRegexOfPhone = @"^[1-9][0-9]{4,11}$";
NSString *const kRegexOfEmail = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
@end
