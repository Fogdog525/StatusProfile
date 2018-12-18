//
//  FDStatusBottomView.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDStatusBottomView.h"
#import "FDWeiBoItemViewModel.h"
@interface FDStatusBottomView()
@property(strong,nonatomic)YYLabel *repostsCountLabel,*commentsCountLabel,*attitudesCountLabel;
@end
@implementation FDStatusBottomView
- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.repostsCountLabel];
        [self addSubview:self.commentsCountLabel];
        [self addSubview:self.attitudesCountLabel];
    }
    return self;
}
- (void)blindViewModel:(FDWeiBoItemViewModel *)viewModel{
    
    //底部工具条
    CGFloat partWidth = WIDTH / 3;
    CGFloat selfHeight = CGRectGetHeight(self.frame);
    self.repostsCountLabel.textLayout = viewModel.repostLayout;
    self.commentsCountLabel.textLayout = viewModel.commentLayout;
    self.attitudesCountLabel.textLayout = viewModel.attitudesLayout;
    self.repostsCountLabel.frame = AAdaptionRect(0, 0.5, partWidth, selfHeight);
    self.commentsCountLabel.frame = AAdaptionRect(partWidth, 0.5, partWidth, selfHeight);
    self.attitudesCountLabel.frame = AAdaptionRect(partWidth * 2, 0.5, partWidth, selfHeight);
    self.repostsCountLabel.textAlignment = self.commentsCountLabel.textAlignment = self.attitudesCountLabel.textAlignment = NSTextAlignmentCenter;
}
- (YYLabel *)repostsCountLabel{
    if (!_repostsCountLabel) {
        _repostsCountLabel = [YYLabel new];
    }
    return _repostsCountLabel;
}
- (YYLabel *)commentsCountLabel{
    if (!_commentsCountLabel) _commentsCountLabel = [YYLabel new];
    return _commentsCountLabel;
}
- (YYLabel *)attitudesCountLabel{
    if (!_attitudesCountLabel) _attitudesCountLabel = [YYLabel new];
    return _attitudesCountLabel;
}

@end
