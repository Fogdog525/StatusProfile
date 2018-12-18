//
//  FDVideoItemViewModel.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDVideoItemViewModel.h"
#import "FDVideoModel.h"
#import "OCTEmoji.h"
@interface FDVideoItemViewModel()
@property(nonatomic,readwrite)CGRect avatarRect;
@property(nonatomic,readwrite)CGRect coverRect;
@property(strong,nonatomic,readwrite)YYTextLayout *nameLayout;
@property(strong,nonatomic,readwrite)YYTextLayout *timeLayout;
@property(strong,nonatomic,readwrite)YYTextLayout *repostLayout;
@property(strong,nonatomic,readwrite)YYTextLayout *commentLayout;
@property(strong,nonatomic,readwrite)YYTextLayout *attitudesLayout;
@property(assign,nonatomic,readwrite)CGFloat cellHieght;
@end
@implementation FDVideoItemViewModel
- (instancetype)initWithVideo:(FDVideoModel *)video{
    if (self = [super init]){
        _video = video;
        
        _avatarRect = AAdaptionRect(kStatusCellTopMargin, kStatusCellTopMargin, 40, 40);
        
        NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc]initWithString:video.user.screen_name];
        nameString.yy_font = AAFont(kStatusNameFontSize);
        nameString.yy_color = kStatusNormalColor;
        YYTextContainer *nameContainer = [YYTextContainer containerWithSize:CGSizeMake(AAdaption(kStatusNameWidth), CGFLOAT_MAX)];
        _nameLayout = [YYTextLayout layoutWithContainer:nameContainer text:nameString];
        
        if (video.created_at.length) {
            NSMutableAttributedString *timeAttribuatedString = [[NSMutableAttributedString alloc]initWithString:video.created_at];
            timeAttribuatedString.yy_font = AAFont(kStatusSourceFontSize);
            timeAttribuatedString.yy_color = kStatusSourceTimeColor;
            YYTextContainer *sourceTimeContainer = [YYTextContainer containerWithSize:CGSizeMake(kStatusNameWidth, CGFLOAT_MAX)];
            _timeLayout = [YYTextLayout layoutWithContainer:sourceTimeContainer text:timeAttribuatedString];
        }else{
            _timeLayout = nil;
        }
 
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc]initWithString:video.text];
        titleString.yy_font = AAFont(kStatusNameFontSize);
        titleString.yy_color = kStatusNormalColor;
        titleString.yy_lineSpacing = 2;
        [self mathRegexWithStatusText:titleString];
        [self mathEmojiRegexWithStatusText:titleString];
        YYTextContainer *titleContainer = [YYTextContainer containerWithSize:CGSizeMake(kStatusTextWidth, CGFLOAT_MAX)];
        _titleLayout = [YYTextLayout layoutWithContainer:titleContainer text:titleString];
        
        _coverRect = AAdaptionRect(kStatusCellTopMargin, 40 + 3 * kStatusCellTopMargin + _titleLayout.textBoundingSize.height, WIDTH - 2 * kStatusCellTopMargin, 180);
        
        [self configureBottomBarToolWithStatus:video];
    }
    return self;
}
- (void)mathRegexWithStatusText:(NSMutableAttributedString *)statusText{
    
    NSString *patternAt = kRegexOfAt;
    NSString *patternTopic = kRegexOfTopic;
    NSString *patternURL = kRegexOfURL;
    NSString *patternPhone = kRegexOfPhone;
    NSString *patternEmail = kRegexOfEmail;
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@|%@",patternAt,patternTopic,patternURL,patternPhone,patternEmail];
    [statusText.string enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        NSString *capturedString = *capturedStrings;
        NSRange range = *capturedRanges;
        if (capturedString.length <= 1 && range.location == NSNotFound) {return;}
        if ([statusText yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
            [statusText yy_setTextHighlightRange:range color:kStatusSourceLinkColor backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
            }];
        }
    }];
}
- (void)mathEmojiRegexWithStatusText:(NSMutableAttributedString *)statusText{
    
    NSMutableAttributedString *statusTextTemp = statusText.mutableCopy;
    NSString *patternEmoji = kRegexOfEmoji;
    __block NSUInteger cycleCount = 0;
    __block NSUInteger locationSum = 0;
    [statusText.string enumerateStringsMatchedByRegex:patternEmoji usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        NSString *capturedString = *capturedStrings;
        NSRange range = *capturedRanges;
        if (capturedString.length <= 1 && range.location == NSNotFound) {return;}
        if ([statusText yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil){
            NSString *emojiString = [statusTextTemp.string substringWithRange:range];
            NSString *emojiImageName = @"emojiDefault";
            OCTEmoji *emoji = [[OCTEmojiManager sharedInstance]emojiWithEmojiName:emojiString];
            if (emoji) { emojiImageName = emoji.png;}
            UIImage *replaceImage = [UIImage imageWithName:emojiImageName size:CGSizeMake(20, 20)];
            NSMutableAttributedString *emojiAttribuatedString = [NSMutableAttributedString yy_attachmentStringWithEmojiImage:replaceImage fontSize:AAdaption(kStatusTextFontSize)];
            NSRange tempRange = NSMakeRange(range.location - (locationSum - cycleCount), range.length);
            [statusText replaceCharactersInRange:tempRange withAttributedString:emojiAttribuatedString];
            locationSum += range.length;
            cycleCount ++;
        }
    }];
}
- (void)configureBottomBarToolWithStatus:(FDVideoModel *)status{
    
    _repostLayout = [self configureBottomBatToolPartWithCount:status.reposts_count attachImageName:@"artical_detail_icon_repost"];
    _commentLayout = [self configureBottomBatToolPartWithCount:status.comments_count attachImageName:@"commentlist_icon_comment"];
    _attitudesLayout = [self configureBottomBatToolPartWithCount:status.attitudes_count attachImageName:@"commentlist_icon_unlike"];
}
- (YYTextLayout *)configureBottomBatToolPartWithCount:(NSNumber *)count attachImageName:(NSString *)imageName{
    
    NSMutableAttributedString *countSring = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",count]];
    countSring.yy_font = AAFont(13);
    countSring.yy_color = kStatusSourceTimeColor;
    UIImage *attachImage = [UIImage imageNamed:imageName];
    NSMutableAttributedString *attachAttribuatedString = [NSMutableAttributedString yy_attachmentStringWithContent:attachImage contentMode:UIViewContentModeCenter attachmentSize:attachImage.size alignToFont:AAFont(13) alignment:YYTextVerticalAlignmentCenter];
    [attachAttribuatedString insertAttributedString:countSring atIndex:attachAttribuatedString.string.length];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(AAdaption(0.33 * WIDTH), CGFLOAT_MAX)];
    return [YYTextLayout layoutWithContainer:container text:attachAttribuatedString];
}
- (CGFloat)cellHieght{
    return 40 + kStatusCellTopMargin * 5 + _titleLayout.textBoundingSize.height + 180 + kStatusBottomBarHeight;
}
@end
