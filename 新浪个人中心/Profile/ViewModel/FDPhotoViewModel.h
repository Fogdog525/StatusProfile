//
//  FDPhotoViewModel.h
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class FDWeiboContentModel;
@interface FDPhotoViewModel : NSObject
@property(strong,nonatomic,readonly)NSArray *pics;
@property(strong,nonatomic,readonly)FDWeiboContentModel *status;
@property(assign,nonatomic,readonly)CGFloat photoHeight;
- (instancetype)initWithStatus:(FDWeiboContentModel *)status;
@end
