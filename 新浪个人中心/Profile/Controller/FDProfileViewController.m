//
//  FDProfileViewController.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/16.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "FDProfileViewController.h"
#import "FDHeadCoverView.h"
#import "FDHeadCoverViewModel.h"
#import "FDHeadCoverModel.h"
#import "FDHomepageViewController.h"
#import "FDWeiBoViewController.h"
#import "FDVideoViewController.h"
#import "FDAlbumViewController.h"

#define CoverHeight 250
@interface FDProfileViewController ()
@property(strong,nonatomic)FDHeadCoverViewModel *viewModel;
@end

@implementation FDProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.minPullUp = 64;
    self.view.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [self.viewModel.fetchHeadCoverDataCommand execute:nil];
    [[[self.viewModel.fetchHeadCoverDataCommand.executing skip:1]deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        if (![executing boolValue]) {
             [self.view ly_endLoading];
             [self reloadData];
        }else{
            [self.view ly_beginLoading];
        }
    }];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_search_light"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"userinfo_navigationbar_more"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[shareItem,searchItem];
}
- (NSString *)swipeNavigationBarTitle{
    return  self.viewModel.user.screen_name;
}
- (NSString *)titleForIndex:(NSInteger)index{
    FDHeadCoverTab *tab = self.viewModel.tabs[index];
    return tab.title;
}
- (NSInteger)numberOfControllers{
    return self.viewModel.tabs.count;
}
- (STHeaderView *)swipeCoverView{
    
    FDHeadCoverView *view = [[FDHeadCoverView alloc] initWithFrame:[self swipeCoverViewFrame]];
    view.user = self.viewModel.user;
    return view;
}
- (CGFloat)tabY{
    return CoverHeight;
}
- (NSInteger)defaultTabIndex{
    return self.viewModel.selectedTab;
}
- (CGRect)swipeCoverViewFrame{
    return CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CoverHeight);
}
- (UIViewController *)controllerAtIndex:(NSInteger)index{
    
    UIViewController *vc = nil;
    FDHeadCoverTab *tab = self.viewModel.tabs[index];
    if ([tab.tab_type isEqualToString:@"profile"]) {
        vc = [[FDHomepageViewController alloc]init];
    }else if ([tab.tab_type isEqualToString:@"weibo"]){
        vc = [[FDWeiBoViewController alloc]init];
    }else if ([tab.tab_type isEqualToString:@"video"]){
        vc = [[FDVideoViewController alloc]init];
    }else if([tab.tab_type isEqualToString:@"album"]){
        vc = [[FDAlbumViewController alloc]init];
    }
    vc.view.frame = [self pageFrame];
    return vc;
}
- (UIColor *)titleColor{
    return [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
}
- (UIColor *)titleHighlightColor{
    return [UIColor blackColor];
}
- (NSString *)stretchBackgroundImageViewURL{
    return self.viewModel.user.cover_image_phone;
}
- (FDHeadCoverViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[FDHeadCoverViewModel alloc]init];
    }
    return _viewModel;
}
- (BOOL)isPreLoad{
    return NO;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
