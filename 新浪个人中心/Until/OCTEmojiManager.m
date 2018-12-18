//
//  OCTEmojiManager.m
//  SinaMVVM
//
//  Created by SD on 2018/11/9.
//  Copyright © 2018年 Mr.Huang. All rights reserved.
//

//微博的表情管理

#import "OCTEmojiManager.h"
#import "OCTEmoji.h"
#import "SinaFile.h"
@interface OCTEmojiManager()
@property(strong,nonatomic)NSMutableArray *emojis;
@end
@implementation OCTEmojiManager
static OCTEmojiManager *manager = nil;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}
- (NSMutableArray *)emojis{
    if (!_emojis) {
        _emojis = @[].mutableCopy;
        NSString *path = [[NSBundle mainBundle]pathForResource:@"emoticonImage" ofType:@"plist"];
        NSDictionary *emojiDict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *emoticons = [[((NSArray *)emojiDict[@"emoticons"]).rac_sequence take:120]map:^id _Nullable(NSDictionary *value) {
           return [OCTEmoji yy_modelWithDictionary:value];
        }].array;
        [_emojis addObjectsFromArray:emoticons];
    }
    return _emojis;
}
- (OCTEmoji *)emojiWithEmojiName:(NSString *)emojiName{
  
    __block OCTEmoji *targetEmoji = nil;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *resultEmojis = [self.emojis.rac_sequence takeUntilBlock:^BOOL(OCTEmoji *emoji) {
            return ([emoji.chs isEqualToString:emojiName] || [emoji.cht isEqualToString:emojiName]);
        }].array;
        targetEmoji = [self.emojis.rac_sequence skip:resultEmojis.count].array.firstObject;
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return targetEmoji;
}
@end
