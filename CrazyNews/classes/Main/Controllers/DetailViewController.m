//
//  DetailViewController.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/4.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "DetailViewController.h"
#import <AFHTTPSessionManager.h>


@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButton];
    //导航栏按钮
    NSMutableArray *barArray = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        NSString *imageStr = [NSString stringWithFormat:@"%d", i + 1];
        NSString *titleStr = [NSString stringWithFormat:@"255"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 50, 50);
        btn.tag = i + 100;
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(barAction:) forControlEvents:UIControlEventTouchUpInside];
        if (titleStr) {
            [btn setTitle:titleStr forState:UIControlStateNormal];
        }
        NSLog(@"%@", btn.titleLabel.text);
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [barArray addObject:barBtn];
    }
    self.navigationItem.rightBarButtonItems = barArray;
    //UIWebView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.0];
    [self.view addSubview:webView];
    [webView loadRequest:request];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    //
    [self request];
}
#pragma mark     ------------- 网络请求
- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [manager GET:@"" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
- (void)barAction:(UIButton *)btn{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
