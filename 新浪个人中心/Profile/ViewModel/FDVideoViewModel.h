//
//  FDVideoViewModel.h
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaFile.h"
@interface FDVideoViewModel : NSObject
@property(strong,nonatomic,readonly)RACCommand *fetchRemoteDataCommand;
@property(copy,nonatomic,readonly)NSArray  *videos;
@end
