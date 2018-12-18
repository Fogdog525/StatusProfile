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
@interface FDWeiBoCell()
@property(nonatomic,strong)UIImageView *avatarImageView;
@property(nonatomic,strong)UIImageView *attachImageView;
@property(strong,nonatomic)YYLabel *nameLabel;
@property(strong,nonatomic)YYLabel *timeLabel;
@property(strong,nonatomic)YYLabel *contentLabel;
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
