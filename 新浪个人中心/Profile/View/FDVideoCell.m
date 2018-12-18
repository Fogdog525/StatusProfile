//
//  FDVideoCell.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDVideoCell.h"
#import "FDVideoItemViewModel.h"
#import "SinaFile.h"
#import "FDVideoModel.h"
@interface FDVideoCell()
@property(strong,nonatomic)UIImageView *avatarImageView,*coverImageView;
@property(strong,nonatomic)YYLabel *nameLabel,*timeLabel,*titleLabel;
@end
@implementation FDVideoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
- (void)updateVideoDataWithViewModel:(FDVideoItemViewModel *)viewModel{
    
    self.avatarImageView.frame = viewModel.avatarRect;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.video.user.profile_image_url]];
    
    self.nameLabel.textLayout = viewModel.nameLayout;
    self.nameLabel.frame = AAdaptionRect(CGRectGetMaxX(self.avatarImageView.frame) + 10, CGRectGetMinY(self.avatarImageView.frame), viewModel.nameLayout.textBoundingSize.width, viewModel.nameLayout.textBoundingSize.height);
    
    self.timeLabel.textLayout = viewModel.timeLayout;
    self.timeLabel.frame = AAdaptionRect(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 4, viewModel.timeLayout.textBoundingSize.width, viewModel.timeLayout.textBoundingSize.height);
    
    self.coverImageView.frame = viewModel.coverRect;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.video.page_info.page_pic]];

    self.titleLabel.textLayout = viewModel.titleLayout;
    self.titleLabel.frame = AAdaptionRect(kStatusCellTopMargin, CGRectGetMaxY(self.avatarImageView.frame) + 10, viewModel.titleLayout.textBoundingSize.width, viewModel.titleLayout.textBoundingSize.height);
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
- (YYLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc]init];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UIImageView *)coverImageView{
    if (!_coverImageView){
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}
- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        [_avatarImageView zj_attachBorderWidth:0.5 color:[UIColor lightGrayColor]];
        [_avatarImageView zj_cornerRadiusRoundingRect];
    }
    return _avatarImageView;
}
@end
