//
//  FDRetweetPhotoView.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDRetweetPhotoView.h"
#import "FDRetweetPhotoViewModel.h"
@interface FDRetweetPhotoView()
@property(strong,nonatomic)FDRetweetPhotoViewModel *retweetViewModel;
@end
@implementation FDRetweetPhotoView
- (FDPhotoViewModel *)viewModel{
    return self.retweetViewModel;
}
@end
