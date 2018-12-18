//
//  FDHeadCoverView.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/16.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDHeadCoverView.h"
#import "SinaFile.h"
@interface FDHeadCoverView()
@property(strong,nonatomic)UIImageView  *avatarImageView;
@property(strong,nonatomic)UILabel  *nicknameLabel;
@property(strong,nonatomic)UILabel  *friendsCountLabel;
@property(strong,nonatomic)UILabel  *fansCountLabel;
@property(strong,nonatomic)UILabel  *certificationLabel;
@end
@implementation FDHeadCoverView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.avatarImageView];
        [self addSubview:self.nicknameLabel];
        [self addSubview:self.friendsCountLabel];
        [self addSubview:self.fansCountLabel];
        [self addSubview:self.certificationLabel];
        [self __configLayout];
    }
    return self;
}
- (void)__configLayout{
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0).offset(-10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(5);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor whiteColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(self.nicknameLabel.mas_bottom).offset(10);
    }];
    [self.friendsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(line.mas_left).offset(-10);
        make.height.top.mas_equalTo(line);
    }];
    [self.fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_right).offset(10);
        make.height.top.mas_equalTo(line);
    }];
    [self.certificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
    }];
}
- (void)setUser:(FDUserInfo *)user{
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url]];
    self.nicknameLabel.text = user.screen_name;
    self.friendsCountLabel.text = [NSString stringWithFormat:@"关注  %@",user.friends_count];
    self.fansCountLabel.text = [NSString stringWithFormat:@"粉丝  %@",user.followers_count];
    self.certificationLabel.text = [NSString stringWithFormat:@"微博认证:%@",user.verified_reason];
}
- (UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc]init];
        _nicknameLabel.textAlignment = NSTextAlignmentCenter;
        _nicknameLabel.font = [UIFont systemFontOfSize:21];
        _nicknameLabel.textColor = [UIColor whiteColor];
    }
    return _nicknameLabel;
}
- (UILabel *)friendsCountLabel{
    if (!_friendsCountLabel) {
        _friendsCountLabel = [[UILabel alloc]init];
        _friendsCountLabel.textAlignment = NSTextAlignmentCenter;
        _friendsCountLabel.font = [UIFont systemFontOfSize:13];
        _friendsCountLabel.textColor = [UIColor whiteColor];
    }
    return _friendsCountLabel;
}
- (UILabel *)fansCountLabel{
    if (!_fansCountLabel) {
        _fansCountLabel = [[UILabel alloc]init];
        _fansCountLabel.textAlignment = NSTextAlignmentCenter;
        _fansCountLabel.font = [UIFont systemFontOfSize:13];
        _fansCountLabel.textColor = [UIColor whiteColor];
    }
    return _fansCountLabel;
}
- (UILabel *)certificationLabel{
    if (!_certificationLabel) {
        _certificationLabel = [[UILabel alloc]init];
        _certificationLabel.textAlignment = NSTextAlignmentCenter;
        _certificationLabel.font = [UIFont systemFontOfSize:12];
        _certificationLabel.textColor = [UIColor whiteColor];
    }
    return _certificationLabel;
}
- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_avatarImageView zj_attachBorderWidth:1 color:[UIColor whiteColor]];
        [_avatarImageView zj_cornerRadiusRoundingRect];
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoTap)];
        [_avatarImageView addGestureRecognizer:tap];
    }
    return _avatarImageView;
}
- (void)gotoTap{
    NSLog(@"======");
}

@end
