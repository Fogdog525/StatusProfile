//
//  FDWeiboModel.h
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class FDWeiboContentModel,FDWeiboUserModel,FDPicSizeModel,FDPic_Focus_PointsModel;
@interface FDWeiboModel : NSObject
@property (nonatomic,strong)NSNumber *card_type;
@property (nonatomic,strong)FDWeiboContentModel *mblog;
@end


@interface FDWeiboContentModel : NSObject
@property (nonatomic,copy)NSString *created_at;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,copy)NSString *pic_bg_new;
@property (nonatomic,strong)FDWeiboUserModel *user;
@property (strong,nonatomic)FDWeiboContentModel *retweeted_status;
@property (strong,nonatomic)NSDictionary *pic_infos;
@property (strong,nonatomic)NSArray <NSString *> *pic_ids;
@property (strong,nonatomic)NSArray <FDPic_Focus_PointsModel *> *pic_focus_point;
@property (strong,nonatomic)NSNumber *reposts_count;
@property (strong,nonatomic)NSNumber *comments_count;
@property (strong,nonatomic)NSNumber *attitudes_count;
@end

@interface FDWeiboUserModel:NSObject
@property (nonatomic,copy)NSString *screen_name;
@property (nonatomic,copy)NSString *profile_image_url;
@property (strong,nonatomic)NSNumber *mbrank;
@end


@interface FDPic_Focus_PointsModel : NSObject
@property (nonatomic,copy)NSString *pic_id;
@property (strong,nonatomic)FDPicSizeModel *focus_point;
@end

@interface FDPicSizeModel : NSObject
@property (strong,nonatomic)NSNumber *width;
@property (strong,nonatomic)NSNumber *height;
@end

@interface FDThumbnail : NSObject
@property (nonatomic,copy)NSString *url;
@property (strong,nonatomic)NSNumber *width;
@property (strong,nonatomic)NSNumber *height;
@property (strong,nonatomic)NSNumber *cut_type;
@end
