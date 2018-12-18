//
//  FDHomepageViewModel.h
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaFile.h"
@interface FDHomepageViewModel : NSObject
@property(strong,nonatomic,readonly)RACCommand *fetchRemoteDataCommand;
@property(copy,nonatomic,readonly)NSArray   *dataArray;
@end
