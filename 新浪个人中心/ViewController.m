//
//  ViewController.m
//  新浪个人中心
//
//  Created by 黄智浩 on 2018/12/16.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import "ViewController.h"
#import "FDProfileViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)gotoProfileAction:(UIButton *)sender {
    
    [self.navigationController pushViewController:[FDProfileViewController new] animated:YES];
}

@end
