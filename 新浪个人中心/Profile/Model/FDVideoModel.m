//
//  FDVideoModel.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDVideoModel.h"
#import "NSString+OCTSupport.h"
static NSDate *fmtWithDateString(NSString *timeString){
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    //设置时间语言 这种格式的时间通常都是欧美的
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return [fmt dateFromString:timeString];
}

@implementation FDVideoModel
- (NSString *)created_at{
    return [NSString oct_stringWithTimeLineDate:fmtWithDateString(_created_at)];
}
@end


@implementation FDUser

@end


@implementation FDPic_info

@end

