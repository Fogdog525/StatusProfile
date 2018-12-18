//
//  NSString+OCTSupport.h
//  SinaMVVM
//
//  Created by SD on 2018/11/5.
//  Copyright © 2018年 Mr.Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (OCTSupport)
//类似微博发布时间,刚刚、多少分钟以前等
+ (NSString *)oct_stringWithTimeLineDate:(NSDate *)date;
@end
