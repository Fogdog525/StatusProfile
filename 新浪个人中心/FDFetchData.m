//
//  FDFetchData.m
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDFetchData.h"

@implementation FDFetchData
+ (NSDictionary *)fetchDataWithJsonname:(NSString *)jsonname{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:jsonname ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
@end
