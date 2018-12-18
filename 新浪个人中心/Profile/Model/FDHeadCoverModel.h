//
//  FDHeadCoverModel.h
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/16.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDHeadCoverModel : NSObject
@property(strong,nonatomic)NSNumber *selectedTab;
@end

@interface FDHeadCoverTab:NSObject
@property(copy,nonatomic)NSString  *title;
@property(copy,nonatomic)NSString  *tab_type;
@end

@interface FDUserInfo:NSObject
@property(copy,nonatomic)NSString  *avatar_large;
@property(copy,nonatomic)NSString  *screen_name;
@property(strong,nonatomic)NSNumber  *friends_count;
@property(strong,nonatomic)NSNumber  *followers_count;
@property(copy,nonatomic)NSString  *cover_image_phone;
@property(copy,nonatomic)NSString  *verified_reason;
@end
