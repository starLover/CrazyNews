//
//  LoginViewController.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/8.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
#import "CreateViewController.h"
#import "MainViewController.h"
#import <WeiboSDK.h>

@interface LoginViewController ()<pushViewControllerDelegate>

@property(nonatomic, strong) UITextField *nametf;
@property(nonatomic, strong) UITextField *passtf;
@property(nonatomic, strong) UIAlertController *alertController;
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.nametf becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"55"]];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 100, 40);
    [backBtn setTitle:@"个人" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"abc_ic_ab_back_mtrl_am_alpha"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    [self configView];
    
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        self.nametf.text = [user objectForKey:@"username"];
        self.passtf.text = [user objectForKey:@"password"];
    }
}

- (void)configView{
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = CGRectMake((kScreenWidth - 100) / 2, 50, 100, 100);
    [headBtn setImage:[UIImage imageNamed:@"avatar_m"] forState:UIControlStateNormal];
    [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headBtn.layer.cornerRadius = 50;
    headBtn.clipsToBounds = YES;
    [headBtn addTarget:self action:@selector(loginAction1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBtn];
    
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
    self.nametf.borderStyle = UITextBorderStyleRoundedRect;
    self.nametf.placeholder = @"请输入用户名";
    self.nametf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:namelabel];
    [self.view addSubview:self.nametf];
    
    UILabel *passlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 270, 80, 44)];
    passlabel.text = @"密码";
    self.passtf = [[UITextField alloc] initWithFrame:CGRectMake(90, 270, kScreenWidth - 100, 44)];
    self.passtf.placeholder = @"请输入密码";
    self.passtf.borderStyle = UITextBorderStyleRoundedRect;
    self.passtf.secureTextEntry = YES;
    self.passtf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:passlabel];
    [self.view addSubview:self.passtf];
    //注册
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame = CGRectMake(kScreenWidth - 100, 430, 60, 44);
    [createBtn setTitle:@"注册" forState:UIControlStateNormal];
    createBtn.backgroundColor = [[UIColor purpleColor]colorWithAlphaComponent:0.2];
    createBtn.layer.borderWidth = 1;
    createBtn.layer.cornerRadius = 5;
    [createBtn addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    //登录
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(50, 370, kScreenWidth - 100, 44);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.4];
    [loginBtn addTarget:self action:@selector(loginAction1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}
//注册
- (void)createAction{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Create" bundle:nil];
    CreateViewController *createVC = [storyboard instantiateViewControllerWithIdentifier:@"CreateView"];
    [self.navigationController pushViewController:createVC animated:YES];
}

//登陆
- (void)loginAction1{
    [BmobUser loginInbackgroundWithAccount:self.nametf.text andPassword:self.passtf.text block:^(BmobUser *user, NSError *error) {
        if (user) {
             self.alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录成功 \n\n3秒后返回到主界面" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [self.delegate getUserImage:@""];
            [self.alertController addAction:action];
            [self presentViewController:self.alertController animated:YES completion:nil];
            if (self.timer == nil) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(removeAlertView) userInfo:nil repeats:NO];
            }
        } else {
            [self addAlertController:@"用户名或密码错误"];
        }
    }];
}




- (void)getWitchViewController:(UIViewController *)VC{
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark      ----------     返回方法
- (void)backToMain{
    [self.navigationController popViewControllerAnimated:YES];
}
//移除提示框
- (void)removeAlertView{
    [self.alertController dismissViewControllerAnimated:NO completion:nil];
    MainViewController *mainVC = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mainVC animated:YES];
}
//回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
