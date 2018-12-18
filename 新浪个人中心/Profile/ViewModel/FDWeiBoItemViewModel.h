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
@interface FDWeiBoItemViewModel : NSObject
@property (nonatomic,strong,readonly)FDWeiboModel *weibo;
- (instancetype)initWithWeiBo:(FDWeiboModel *)weibo;


//layout
@property(nonatomic)CGFloat avatarPartHeight;
@property(assign,nonatomic)CGFloat textPartHeight;
@property(assign,nonatomic)CGFloat retweetTextPartHeight;
@property(nonatomic)CGFloat cellHeight;
@property(strong,nonatomic)YYTextLayout *nameLayout;
@property(strong,nonatomic)YYTextLayout *sourceTimeLayout;
@property(strong,nonatomic)YYTextLayout *textLayout;
@property(strong,nonatomic)YYTextLayout *retweetTextLayout;
@end
