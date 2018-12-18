//
//  FDWeiBoItemViewModel.h
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SinaFile.h"
#import "FDWeiboModel.h"
#import "FDPhotoViewModel.h"
#import "FDRetweetPhotoViewModel.h"
@interface FDWeiBoItemViewModel : NSObject
@property (nonatomic,strong,readonly)FDWeiboModel *weibo;
- (instancetype)initWithWeiBo:(FDWeiboModel *)weibo;
//layout
@property(nonatomic)CGFloat avatarPartHeight;
@property(nonatomic,readonly)CGFloat cellHeight;
@property(strong,nonatomic)YYTextLayout *nameLayout;
@property(strong,nonatomic)YYTextLayout *sourceTimeLayout;
@property(strong,nonatomic)YYTextLayout *textLayout;
@property(assign,nonatomic)CGFloat textPartHeight;
@property(strong,nonatomic)YYTextLayout *retweetTextLayout;
@property(assign,nonatomic)CGFloat retweetTextPartHeight;
@property(strong,nonatomic)YYTextLayout *repostLayout;
@property(strong,nonatomic)YYTextLayout *commentLayout;
@property(strong,nonatomic)YYTextLayout *attitudesLayout;
@property(strong,nonatomic,readonly)FDPhotoViewModel *photoViewModel;
@property(strong,nonatomic,readonly)FDRetweetPhotoViewModel *retweetPhotoViewModel;
@end
