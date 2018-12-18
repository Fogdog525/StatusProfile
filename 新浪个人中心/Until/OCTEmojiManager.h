//
//  OCTEmojiManager.h
//  SinaMVVM
//
//  Created by SD on 2018/11/9.
//  Copyright © 2018年 Mr.Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OCTEmoji;
@interface OCTEmojiManager : NSObject
+ (instancetype)sharedInstance;
- (OCTEmoji *)emojiWithEmojiName:(NSString *)emojiName;
@end
