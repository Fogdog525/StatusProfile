//
//  FDCoverController.h
//  FDHybridTableView
//
//  Created by 黄智浩 on 2018/12/15.
//  Copyright © 2018 ShouNew.com. All rights reserved.
//

#import "FDTabController.h"
#import "FDCoverProtocol.h"
typedef NS_ENUM(NSInteger,FDCoverStyle){
    FDCoverStyleStretch = 0,
    FDCoverStyleKeep    = 1,
};
@interface FDCoverController : FDTabController<FDCoverDataSource>
- (FDCoverStyle)coverStyle;

@end
