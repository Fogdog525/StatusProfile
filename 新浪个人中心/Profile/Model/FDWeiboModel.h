//
//  FDWeiboModel.h
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class FDWeiboContentModel,FDWeiboUserModel;
@interface FDWeiboModel : NSObject
@property (nonatomic,strong)NSNumber *card_type;
@property (nonatomic,strong)FDWeiboContentModel *mblog;
@end


@interface FDWeiboContentModel : NSObject
@property (nonatomic,copy)NSString *created_at;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,copy)NSString *pic_bg_new;
@property (nonatomic,strong)FDWeiboUserModel *user;
@end

@interface FDWeiboUserModel:NSObject
@property (nonatomic,copy)NSString *screen_name;
@property (nonatomic,copy)NSString *profile_image_url;
@property (strong,nonatomic)NSNumber *mbrank;
@end
