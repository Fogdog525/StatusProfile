//
//  FDAlbumHeader.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDAlbumHeader.h"

@implementation FDAlbumHeader
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}
@end
