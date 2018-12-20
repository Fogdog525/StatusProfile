//
//  FDWeiBoViewController.m
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDWeiBoViewController.h"
#import "FDWeiBoViewModel.h"
#import "FDWeiboModel.h"
#import "FDWeiBoItemViewModel.h"
#import "FDWeiBoCell.h"
#import "SinaFile.h"
@interface FDWeiBoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;
@property (nonatomic,strong)FDWeiBoViewModel *viewModel;
@property (nonatomic,strong)NSArray *dataSource;
@end

@implementation FDWeiBoViewController
- (UIScrollView *)swipeTableView{
    return self.tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.viewModel.fetchRemoteDataCommand execute:nil];
    @weakify(self);
    [[self.viewModel.fetchRemoteDataCommand.executing skip:1] subscribeNext:^(NSNumber * executing) {
        @strongify(self);
        if (![executing boolValue]) {
            [self.view ly_endLoading];
            [self.tableView reloadData];
        }else{
            [self.view ly_beginLoading];
        }
    }];
    RAC(self,dataSource) = [[RACObserve(self.viewModel, dataSource)filter:^BOOL(NSArray *dataSource) {
        return dataSource.count > 0;
    }]map:^id _Nullable(NSArray *dataSource) {
        return [dataSource.rac_sequence map:^id _Nullable(FDWeiboModel *weibo) {
            return @[[[FDWeiBoItemViewModel alloc]initWithWeiBo:weibo]];
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
    
    FDWeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeiBoCellIdentifier forIndexPath:indexPath];
    [cell updateWeiBoDataWithViewModel:self.dataSource[indexPath.section][indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FDWeiBoItemViewModel *viewModel = self.dataSource[indexPath.section][indexPath.row];
    return AAdaption(viewModel.cellHeight);
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
static NSString *const kWeiBoCellIdentifier = @"kWeiBoCellIdentifier";
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[FDWeiBoCell class] forCellReuseIdentifier:kWeiBoCellIdentifier];
    }
    return _tableView;
}
- (FDWeiBoViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[FDWeiBoViewModel alloc]init];
    }
    return _viewModel;
}

@end
