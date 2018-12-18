//
//  FDVideoViewController.m
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDVideoViewController.h"
#import "FDVideoViewModel.h"
#import "FDVideoItemViewModel.h"
#import "FDVideoCell.h"
@interface FDVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)FDVideoViewModel  *viewModel;
@property(strong,nonatomic)NSArray *dataSource;
@end

@implementation FDVideoViewController
- (UIScrollView *)swipeTableView{
    return self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.viewModel.fetchRemoteDataCommand execute:nil];
    [[self.viewModel.fetchRemoteDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if (![x boolValue]){
            [self.view ly_endLoading];
            [self.tableView reloadData];
        }else{
             [self.view ly_beginLoading];
        }
    }];
    
    RAC(self,dataSource) = [[RACObserve(self.viewModel, videos)filter:^BOOL(NSArray *videos) {
        return videos.count > 0;
    }]map:^id _Nullable(NSArray *videos) {
        return [videos.rac_sequence map:^id _Nullable(FDVideoModel *videoModel) {
            return @[[[FDVideoItemViewModel alloc]initWithVideo:videoModel]];
        }].array;
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FDVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:kVideoCellIdentifier forIndexPath:indexPath];
    [cell updateVideoDataWithViewModel:self.dataSource[indexPath.section][indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FDVideoItemViewModel *viewModel = self.dataSource[indexPath.section][indexPath.row];
    return AAdaption(viewModel.cellHieght);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
static NSString *const kVideoCellIdentifier = @"kVideoCellIdentifier";
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[FDVideoCell class] forCellReuseIdentifier:kVideoCellIdentifier];
    }
    return _tableView;
}
- (FDVideoViewModel *)viewModel{
    if (!_viewModel){
        _viewModel = [[FDVideoViewModel alloc]init];
    }
    return _viewModel;
}
@end
