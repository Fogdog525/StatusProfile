//
//  FDHeadCoverViewModel.h
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/16.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaFile.h"
#import "FDHeadCoverModel.h"
@interface FDHeadCoverViewModel : NSObject
@property(strong,nonatomic,readonly)RACCommand *fetchHeadCoverDataCommand;
@property(copy,nonatomic)NSArray *tabs;
@property(nonatomic)NSInteger selectedTab;
@property(strong,nonatomic,readonly)FDUserInfo *user;
@end
