//
//  FDVideoModel.h
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FDUser,FDPic_middle,FDPic_info;
@interface FDVideoModel : NSObject
@property(copy,nonatomic)NSString  *created_at;
@property(copy,nonatomic)NSString  *text;
@property(strong,nonatomic)FDUser  *user;
@property(strong,nonatomic)FDPic_info *page_info;
@end

@interface FDUser:NSObject
@property(copy,nonatomic)NSString  *screen_name;
@property(copy,nonatomic)NSString  *profile_image_url;

@end

@interface FDPic_info:NSObject
@property(copy,nonatomic)NSString *page_pic;
@end


