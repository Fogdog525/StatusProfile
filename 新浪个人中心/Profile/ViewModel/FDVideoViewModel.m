//
//  FDVideoViewModel.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/18.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDVideoViewModel.h"
#import "FDVideoModel.h"
@interface FDVideoViewModel()
@property(strong,nonatomic,readwrite)RACCommand *fetchRemoteDataCommand;
@property(copy,nonatomic,readwrite)NSArray  *videos;
@end
@implementation FDVideoViewModel
- (instancetype)init{
    if(self = [super init]){
        @weakify(self);
        _fetchRemoteDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSDictionary *videoDic = [FDFetchData fetchDataWithJsonname:@"video"];
                    self.videos = [[(NSArray *)videoDic[@"cards"]rac_sequence] map:^id _Nullable(NSDictionary *value) {
                        return [FDVideoModel yy_modelWithDictionary:value[@"mblog"]];
                    }].array;
                     [subscriber sendCompleted];
                });
                return [RACDisposable disposableWithBlock:^{}];
            }];
        }];
    }
    return self;
}
@end
