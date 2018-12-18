//
//  FDWeiBoCell.h
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDWeiBoItemViewModel.h"
@interface FDWeiBoCell : UITableViewCell
- (void)updateWeiBoDataWithViewModel:(FDWeiBoItemViewModel *)viewModel;
@end
