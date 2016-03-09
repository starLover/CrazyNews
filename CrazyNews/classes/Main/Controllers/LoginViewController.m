//
//  LoginViewController.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/8.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<pushViewControllerDelegate>
@property(nonatomic, strong) UITextField *nametf;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.nametf becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 100, 40);
    [backBtn setTitle:@"个人" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"abc_ic_ab_back_mtrl_am_alpha"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    [self configView];
}

- (void)configView{
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = CGRectMake((kScreenWidth - 100) / 2, 50, 100, 100);
    [headBtn setImage:[UIImage imageNamed:@"avatar_m"] forState:UIControlStateNormal];
    [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headBtn.layer.cornerRadius = 50;
    headBtn.clipsToBounds = YES;
    [headBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBtn];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2, 150, 100, 30)];
    label.text = @"点击登录";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    NSArray *array = @[@"0收藏", @"0评论", @"0阅读"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50 + (kScreenWidth - 100) / 3 * i, 500, (kScreenWidth - 100) / 3, 50);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    //登录框
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 80, 44)];
    namelabel.text = @"用户名";
    self.nametf = [[UITextField alloc] initWithFrame:CGRectMake(90, 200, kScreenWidth - 100, 44)];
    self.nametf.placeholder = @"请输入用户名";
    self.nametf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:namelabel];
    [self.view addSubview:self.nametf];
    
    UILabel *passlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 270, 80, 44)];
    passlabel.text = @"密码";
    UITextField *passtf = [[UITextField alloc] initWithFrame:CGRectMake(90, 270, kScreenWidth - 100, 44)];
    passtf.placeholder = @"请输入密码";
    passtf.secureTextEntry = YES;
    passtf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:passlabel];
    [self.view addSubview:passtf];
    
}


//登陆
- (void)loginAction{
    
}
- (void)getWitchViewController:(UIViewController *)VC{
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark      ----------     返回方法
- (void)backToMain{
    [self.navigationController popViewControllerAnimated:YES];
}
//回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view resignFirstResponder];
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
