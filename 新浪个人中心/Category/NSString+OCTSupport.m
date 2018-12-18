//
//  NSString+OCTSupport.m
//  SinaMVVM
//
//  Created by SD on 2018/11/5.
//  Copyright © 2018年 Mr.Huang. All rights reserved.
//

#import "NSString+OCTSupport.h"

@implementation NSString (OCTSupport)
+ (NSString *)oct_stringWithTimeLineDate:(NSDate *)date{
    
    if (!date) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDate *now = [NSDate date];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < 0) {
        formatter.dateFormat = @"yyyy-MM-dd";
        return [formatter stringFromDate:date];
    }else{
        if(delta < 60*10 & delta > 0){//小于10分钟 显示刚刚
            return @"刚刚";
        }else if(delta < 60 * 60){//小于1个小时
            return [NSString stringWithFormat:@"%d分钟前",(int)(delta/60.0)];
        }else if(delta <= 60*60*24){ //一天内
            return [NSString stringWithFormat:@"%d小时前",(int)(delta/60.0/60.0)];
        }else if(delta >= 60*60*24 && delta <= 60*60*48){ //昨天
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:date];
        }else if(delta >= 60*60*48 && delta <= 60*60*356){//1年内
            formatter.dateFormat = @"MM-dd";
            return [formatter stringFromDate:date];
        }else{
            formatter.dateFormat = @"yyyy-MM-dd";
            return [formatter stringFromDate:date];
        }
    }
}
@end
