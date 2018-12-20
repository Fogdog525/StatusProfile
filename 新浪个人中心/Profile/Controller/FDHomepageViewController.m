//
//  FDHomepageViewController.m
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDHomepageViewController.h"
#import "FDHomepageViewModel.h"
#import "SinaFile.h"
#import "UITableView+FDEmptySupport.h"
@interface FDHomepageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;
@property (nonatomic,strong)FDHomepageViewModel *viewModel;
@property(strong,nonatomic)NSArray *dataSource;
@end

@implementation FDHomepageViewController
- (UIScrollView *)swipeTableView{
    return self.tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[].copy;
    [self.view addSubview:self.tableView];
    [self.viewModel.fetchRemoteDataCommand execute:nil];
    @weakify(self);
    [[self.viewModel.fetchRemoteDataCommand.executing skip:1] subscribeNext:^(NSNumber * x) {
        @strongify(self);
        if (![x boolValue]){
            [self.view ly_endLoading];
            [self.tableView reloadData];
            [self.tableView fd_emptySupposed:@"empty_icon_ticket" tripStr:@"空空如也~~"];
        }else{
             [self.view ly_beginLoading];
        }
    }];
    RAC(self,dataSource) = RACObserve(self.viewModel, dataArray);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    return cell;
}
static NSString *const kCellIdentifier = @"kCellIdentifier";
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return _tableView;
}
- (FDHomepageViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[FDHomepageViewModel alloc]init];
    }
    return _viewModel;
}

@end
