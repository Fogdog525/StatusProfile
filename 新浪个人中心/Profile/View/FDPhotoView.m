//
//  FDPhotoView.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDPhotoView.h"
#import "FDWeiboModel.h"
#import "SinaFile.h"
@interface FDPhotoView()
@property(strong,nonatomic,readwrite)FDPhotoViewModel *viewModel;
@end
@implementation FDPhotoView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        for (NSInteger i = 0; i < kStatusPhotoCount; i ++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.userInteractionEnabled = YES;
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.tag = i;
            [self addSubview:imageView];
        }
    }
    return self;
}
- (void)blindViewModel:(FDPhotoViewModel *)viewModel{
    
    _viewModel = viewModel;
    NSArray *pics = viewModel.pics;
    if (!pics.count) {return;}
    
    NSUInteger count = viewModel.status.pic_ids.count;
    NSUInteger row = 0;
    CGFloat space = kStatusPhotoSpace;
    CGFloat width = (kStatusTextWidth - 2 * space) / 3;
    CGFloat height = width;
    for (NSInteger i = 0; i < kStatusPhotoCount; i ++) {
        UIView *view = [self.subviews objectAtIndex:i];
        if ([view isKindOfClass:[UIImageView class]]) {
            if (i < count) {
                FDThumbnail *thumbnail = [pics objectAtIndex:i];
                row = count == 4?2:3;
                if (count == 1) {
                    width = [[self caluatePicHeigtWithStatus:viewModel.status].width floatValue];
                    height = [[self caluatePicHeigtWithStatus:viewModel.status].height floatValue];
                }
                view.frame = AAdaptionRect((width + space) * (i % row),
                                           (height + space) * (i / row),
                                           width,
                                           height);
                [(UIImageView *)view sd_setImageWithURL:[NSURL URLWithString:thumbnail.url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
                view.hidden = NO;
            }else{
                view.hidden = YES;
            }
        }
    }
}
//计算单独一张图片时图片的尺寸
- (FDThumbnail *)caluatePicHeigtWithStatus:(FDWeiboContentModel *)status{
    
    NSDictionary *picInfoDict = [status.pic_infos objectForKey:[status.pic_ids firstObject]];
    FDThumbnail *thumbnail = [FDThumbnail yy_modelWithDictionary:picInfoDict[@"thumbnail"]];
    thumbnail.width = @([self adjustImageSizeWithThumbnail:thumbnail].width);
    thumbnail.height = @([self adjustImageSizeWithThumbnail:thumbnail].height);
    return thumbnail;
}

- (CGSize)adjustImageSizeWithThumbnail:(FDThumbnail *)thumbnail{
    
    CGFloat maxW = kStatusTextWidth;
    CGFloat maxH = HEIGHT * 0.3;
    CGFloat imageW = thumbnail.width.floatValue;
    CGFloat imageH = thumbnail.height.floatValue;
    imageW = MIN(imageW, maxW);
    imageH = MIN(imageH, maxH);
    return CGSizeMake(imageW, imageH);
}

@end
