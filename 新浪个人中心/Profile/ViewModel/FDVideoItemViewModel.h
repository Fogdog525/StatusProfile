//
//  FDVideoItemViewModel.h
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaFile.h"
@class FDVideoModel;
@interface FDVideoItemViewModel : NSObject
@property(strong,nonatomic)FDVideoModel *video;
- (instancetype)initWithVideo:(FDVideoModel *)video;

//layout

@property(nonatomic,readonly)CGRect avatarRect;
@property(nonatomic,readonly)CGRect coverRect;
@property(strong,nonatomic,readonly)YYTextLayout *nameLayout;
@property(strong,nonatomic,readonly)YYTextLayout *timeLayout;
@property(strong,nonatomic,readonly)YYTextLayout *titleLayout;
@property(strong,nonatomic,readonly)YYTextLayout *repostLayout;
@property(strong,nonatomic,readonly)YYTextLayout *commentLayout;
@property(strong,nonatomic,readonly)YYTextLayout *attitudesLayout;
@property(assign,nonatomic,readonly)CGFloat cellHieght;
@end
