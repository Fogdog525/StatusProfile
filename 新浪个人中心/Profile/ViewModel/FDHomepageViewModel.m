//
//  FDHomepageViewModel.m
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDHomepageViewModel.h"
@interface FDHomepageViewModel()
@property(strong,nonatomic,readwrite)RACCommand *fetchRemoteDataCommand;
@property(copy,nonatomic,readwrite)NSArray   *dataArray;
@end
@implementation FDHomepageViewModel
- (instancetype)init{
    if (self = [super init]) {
        
        _fetchRemoteDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                //模拟延时和空数据
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.dataArray = @[];
                    [subscriber sendCompleted];
                });
                return [RACDisposable disposableWithBlock:^{}];
            }];
        }];
    }
    return self;
}
@end
