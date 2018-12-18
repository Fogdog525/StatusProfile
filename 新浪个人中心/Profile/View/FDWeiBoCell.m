//
//  FDWeiBoCell.m
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDWeiBoCell.h"
#import "SinaFile.h"
#import "FDWeiBoItemViewModel.h"
#import "FDPhotoView.h"
#import "FDRetweetPhotoView.h"
#import "FDStatusBottomView.h"
@interface FDWeiBoCell()
@property(nonatomic,strong)UIImageView *avatarImageView;
@property(nonatomic,strong)UIImageView *attachImageView;
@property(strong,nonatomic)YYLabel *nameLabel,*retweetStatusTextLabel,*timeLabel,*contentLabel;
@property(strong,nonatomic)FDPhotoView *photoView;
@property(strong,nonatomic)FDRetweetPhotoView *retweetPhotoView;
@property(strong,nonatomic)UIView *retweetStatusBackGroundView;
@property(strong,nonatomic)FDStatusBottomView *bottomView;
@property(strong,nonatomic)UIView *bottom_segLine;
@end
@implementation FDWeiBoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.attachImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.photoView];
        [self.contentView addSubview:self.retweetStatusBackGroundView];
        [self.retweetStatusBackGroundView addSubview:self.retweetStatusTextLabel];
        [self.retweetStatusBackGroundView addSubview:self.retweetPhotoView];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.bottom_segLine];
    }
    return self;
}

- (void)updateWeiBoDataWithViewModel:(FDWeiBoItemViewModel *)viewModel{
    
    self.avatarImageView.frame = AAdaptionRect(kStatusCellTopMargin, kStatusCellTopMargin, 40, 40);
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.weibo.mblog.user.profile_image_url]];
    self.attachImageView.frame = AAdaptionRect(WIDTH - 135, 0, 120, 35);
    [self.attachImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.weibo.mblog.pic_bg_new]];
    
    self.nameLabel.textLayout = viewModel.nameLayout;
    self.nameLabel.frame = AAdaptionRect(CGRectGetMaxX(self.avatarImageView.frame) + 10, CGRectGetMinY(self.avatarImageView.frame), viewModel.nameLayout.textBoundingSize.width, viewModel.nameLayout.textBoundingSize.height);
    
    self.timeLabel.textLayout = viewModel.sourceTimeLayout;
    self.timeLabel.frame = AAdaptionRect(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 3, kStatusNameWidth, 24.0);
    
    self.contentLabel.textLayout = viewModel.textLayout;
    self.contentLabel.frame = AAdaptionRect(kStatusCellLeftMargin, CGRectGetMaxY(self.avatarImageView.frame) + kStatusCellTopMargin, kStatusTextWidth, viewModel.textPartHeight);
    
    CGFloat bottom_startY = CGRectGetMaxY(self.contentLabel.frame) + kStatusCellTopMargin;
    BOOL statusPicExit = (viewModel.weibo.mblog.pic_ids.count > 0);
    if (statusPicExit) {
        self.photoView.hidden = NO;
        [self.photoView blindViewModel:viewModel.photoViewModel];
        CGFloat photoViewStartY = 0.f;
        if (viewModel.textLayout) {
            photoViewStartY = viewModel.textPartHeight + viewModel.avatarPartHeight + kStatusCellTopMargin;
        }else{
            photoViewStartY = viewModel.avatarPartHeight + kStatusCellTopMargin;
        }
        self.photoView.frame = AAdaptionRect(kStatusCellLeftMargin, photoViewStartY, kStatusTextWidth, viewModel.photoViewModel.photoHeight);
        bottom_startY = CGRectGetMaxY(self.photoView.frame) + kStatusCellTopMargin;
    }else{
        self.photoView.hidden = YES;
    }
    BOOL retweetStatusPicExit = (viewModel.retweetPhotoViewModel != nil);
    if (viewModel.weibo.mblog.retweeted_status) {
        
        self.retweetStatusBackGroundView.hidden = NO;
        self.retweetStatusTextLabel.textLayout = viewModel.retweetTextLayout;
        self.retweetStatusTextLabel.frame = AAdaptionRect(CGRectGetMinX(self.contentLabel.frame), 0.f, kStatusTextWidth, viewModel.retweetTextPartHeight);
        if (retweetStatusPicExit) {
            self.retweetPhotoView.hidden = NO;
            [self.retweetPhotoView blindViewModel:viewModel.retweetPhotoViewModel];
            CGFloat photoViewStartY = viewModel.retweetTextPartHeight + kStatusCellTopMargin;
            self.retweetPhotoView.frame = AAdaptionRect(kStatusCellLeftMargin, photoViewStartY, kStatusTextWidth, viewModel.retweetPhotoViewModel.photoHeight);
        }else{
            self.retweetPhotoView.hidden = YES;
        }
        CGFloat retweetStatusX = 0;
        CGFloat retweetStatusY = statusPicExit?CGRectGetMaxY(self.photoView.frame):CGRectGetMaxY(self.contentLabel.frame);
        CGFloat retweetStatusW = WIDTH;
        CGFloat retweetStatusH = viewModel.retweetTextPartHeight + (retweetStatusPicExit?viewModel.retweetPhotoViewModel.photoHeight + kStatusCellTopMargin:0.f);
        self.retweetStatusBackGroundView.frame = AAdaptionRect(retweetStatusX, retweetStatusY, retweetStatusW, retweetStatusH);
        bottom_startY = CGRectGetMaxY(self.retweetStatusBackGroundView.frame) + kStatusCellTopMargin;
    }else{
        self.retweetStatusBackGroundView.hidden = YES;
    }
    
    self.bottom_segLine.frame = AAdaptionRect(kStatusCellLeftMargin, bottom_startY, kStatusTextWidth, 0.5);
    self.bottomView.frame = AAdaptionRect(0, CGRectGetMaxY(self.bottom_segLine.frame) + 0.5, WIDTH, kStatusBottomBarHeight - 0.5);
    [self.bottomView blindViewModel:viewModel];
}
- (FDRetweetPhotoView *)retweetPhotoView{
    if (!_retweetPhotoView) {
        _retweetPhotoView = [[FDRetweetPhotoView alloc]init];
        _retweetPhotoView.backgroundColor = [UIColor clearColor];
    }
    return _retweetPhotoView;
}
- (UIView *)retweetStatusBackGroundView{
    if (!_retweetStatusBackGroundView){
        _retweetStatusBackGroundView = [UIView new];
        _retweetStatusBackGroundView.backgroundColor = kStatusRetweetBackgroundColor;
    }
    return _retweetStatusBackGroundView;
}
- (FDStatusBottomView *)bottomView{
    if (!_bottomView) _bottomView = [[FDStatusBottomView alloc]init];
    return _bottomView;
}
- (UIView *)bottom_segLine{
    if (!_bottom_segLine) {
        _bottom_segLine = [[UIView alloc]init];
        _bottom_segLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _bottom_segLine;
}
- (FDPhotoView *)photoView{
    if (!_photoView) {
        _photoView = [[FDPhotoView alloc]init];
        _photoView.backgroundColor = kStatusColor_FFFFFF;
    }
    return _photoView;
}
- (YYLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc]init];
    }
    return _nameLabel;
}
- (YYLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[YYLabel alloc]init];
    }
    return _timeLabel;
}
- (YYLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc]init];
    }
    return _contentLabel;
}
- (YYLabel *)retweetStatusTextLabel{
    if (!_retweetStatusTextLabel) _retweetStatusTextLabel = [[YYLabel alloc]init];
    return _retweetStatusTextLabel;
}
- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        [_avatarImageView zj_attachBorderWidth:0.5 color:[UIColor lightGrayColor]];
        [_avatarImageView zj_cornerRadiusRoundingRect];
    }
    return _avatarImageView;
}
- (UIImageView *)attachImageView{
    if (!_attachImageView) {
         _attachImageView = [[UIImageView alloc]init];
         _attachImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _attachImageView;
}
@end
