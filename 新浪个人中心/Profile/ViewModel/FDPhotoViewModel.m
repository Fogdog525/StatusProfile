//
//  FDPhotoViewModel.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDPhotoViewModel.h"
#import "FDWeiboModel.h"
#import "SinaFile.h"
@interface FDPhotoViewModel()
@property(strong,nonatomic,readwrite)NSArray *pics;
@property(strong,nonatomic,readwrite)FDWeiboContentModel *status;
@end
@implementation FDPhotoViewModel
- (instancetype)initWithStatus:(FDWeiboContentModel *)status{
    if (self = [super init]){
        _status = status;
         self.pics = [self thumbnailWithStatus:status];
    }
    return self;
}
- (CGFloat)photoHeight{
    
    NSUInteger count = self.status.pic_ids.count;
    NSUInteger page = (count + 3 -1) / 3;
    CGFloat height = 0.f;
    if (self.status.pic_ids.count == 1) {
        height = [self caluatePicHeigt];
    }else{
        height = (kStatusTextWidth - 2 * kStatusPhotoSpace) / 3;
    }
    return (height + kStatusPhotoSpace) * page;
}
- (CGFloat)adjustImageSizeWithThumbnail:(FDThumbnail *)thumbnail{
    
    CGFloat maxH = HEIGHT * 0.3;
    CGFloat imageH = thumbnail.height.floatValue;
    if (imageH > maxH) {
        imageH = maxH;
    }
    return imageH;
}
//计算单独一张图片时图片的高度
- (CGFloat)caluatePicHeigt{
    
    NSDictionary *picInfoDict = [self.status.pic_infos objectForKey:[self.status.pic_ids firstObject]];
    FDThumbnail *thumbnail = [FDThumbnail yy_modelWithDictionary:picInfoDict[@"thumbnail"]];
    thumbnail.height = @([self adjustImageSizeWithThumbnail:thumbnail]);
    return [thumbnail.height floatValue];
}

//在这里进行字典转模型
- (NSArray *)thumbnailWithStatus:(FDWeiboContentModel *)status{
    
    NSString *keyPath = @"large";
    NSMutableArray *pics = @[].mutableCopy;
    NSArray *pic_ids = status.pic_ids;
    if (pic_ids.count) {
        for (NSString *pic_id in pic_ids) {
            NSDictionary *perPicInfoDict = [status.pic_infos objectForKey:pic_id];
            FDThumbnail *thumbnail = [FDThumbnail yy_modelWithDictionary:perPicInfoDict[keyPath]];
            [pics addObject:thumbnail];
        }
    }
    return pics.copy;
}
@end
