//
//  FDHeadCoverViewModel.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/16.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDHeadCoverViewModel.h"
#import "FDHeadCoverModel.h"
@interface FDHeadCoverViewModel()
@property(strong,nonatomic,readwrite)RACCommand *fetchHeadCoverDataCommand;
@property(strong,nonatomic,readwrite)FDUserInfo *user;
@end
@implementation FDHeadCoverViewModel
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
- (RACCommand *)fetchHeadCoverDataCommand{
    if (!_fetchHeadCoverDataCommand) {
        @weakify(self);
        _fetchHeadCoverDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                //模拟延时1s
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //从本地获取数据
                    NSString *path = [[NSBundle mainBundle]pathForResource:@"ProfileTopData" ofType:@"json"];
                    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
                    NSDictionary *coverDataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    NSArray *tabsInfo = coverDataDic[@"tabsInfo"][@"tabs"];
                    self.selectedTab = [coverDataDic[@"tabsInfo"][@"selectedTab"]integerValue];
                    if (tabsInfo.count > 0) {
                        self.tabs = [tabsInfo.rac_sequence map:^id _Nullable(NSDictionary *dic) {
                            return [FDHeadCoverTab yy_modelWithDictionary:dic];
                        }].array;
                    }
                    self.user = [FDUserInfo yy_modelWithDictionary:coverDataDic[@"userInfo"]];
                    [subscriber sendCompleted];
                });
                return [RACDisposable disposableWithBlock:^{}];
            }];
        }];
    }
    return _fetchHeadCoverDataCommand;
}
@end
