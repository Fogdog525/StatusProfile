//
//  FDWeiBoViewModel.m
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDWeiBoViewModel.h"
#import "FDWeiboModel.h"
@interface FDWeiBoViewModel()
@property(strong,nonatomic,readwrite)RACCommand *fetchRemoteDataCommand;
@property(nonatomic,strong,readwrite)NSArray *dataSource;
@end
@implementation FDWeiBoViewModel
- (instancetype)init{
    if (self = [super init]) {
        
        @weakify(self);
        _fetchRemoteDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                //模拟延时
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @strongify(self);
                    NSDictionary *homePageDic = [FDFetchData fetchDataWithJsonname:@"weibo"];
                    self.dataSource = [[[(NSArray *)homePageDic[@"cards"] rac_sequence]map:^id _Nullable(NSDictionary *weiboDic) {
                        return [FDWeiboModel yy_modelWithDictionary:weiboDic];
                    }]filter:^BOOL(FDWeiboModel *weibo) {
                        return ([weibo.card_type integerValue] == 9);
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
