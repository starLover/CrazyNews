//
//  UIViewController+Common.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/6.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)
//导航栏添加返回按钮
- (void)showBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backBtn setImage:[UIImage imageNamed:@"abc_ic_ab_back_mtrl_am_alpha"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
}
//导航按钮
- (void)backButtonAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addAlertController:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
