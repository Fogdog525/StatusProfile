//
//  FDVideoCell.h
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDVideoItemViewModel;
@interface FDVideoCell : UITableViewCell
- (void)updateVideoDataWithViewModel:(FDVideoItemViewModel *)viewModel;
@end
