//
//  FDPhotoView.h
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDReactive.h"
#import "FDPhotoViewModel.h"
@interface FDPhotoView : UIView<FDReactive>
@property(strong,nonatomic,readonly)FDPhotoViewModel *viewModel;
@end
