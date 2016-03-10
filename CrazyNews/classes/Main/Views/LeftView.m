//
//  LeftView.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/5.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "LeftView.h"
#import <QuartzCore/QuartzCore.h>
#import "TopViewController.h"
#import "MainViewController.h"
#import "ListViewController.h"
#import "LoginViewController.h"
#import "SetViewController.h"
#import "SerachViewController.h"


static BOOL night = NO;

@interface LeftView ()

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation LeftView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    UIWindow *wido = [[UIApplication sharedApplication].delegate window];

    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.5;
        self.whiteView.frame = CGRectMake(0, 0, kScreenWidth - 100, kScreenHeight);
    }];
    [self.whiteView addSubview:self.loginView];
    [wido addSubview:self.blackView];
    [wido addSubview:self.whiteView];
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTap:)];
    [self.blackView addGestureRecognizer:touch];
    [touch setNumberOfTapsRequired:1];//点击次数
    
    
    //登陆头像 按钮
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 50, 50)];
    headImage.image = [UIImage imageNamed:@"avatar_m"];
    headImage.clipsToBounds = YES;
    headImage.layer.cornerRadius = 25;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 115, 60, 20)];
    label.text = @"登录";
    label.textColor = [UIColor whiteColor];
    [self.loginView addSubview:headImage];
    [self.loginView addSubview:label];
    [self.loginView addSubview:self.btn];
}
-(void)handelTap:(UITapGestureRecognizer*)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.0;
        self.whiteView.frame = CGRectMake(-(kScreenWidth - 100), 0, kScreenWidth - 100, kScreenHeight);
    }];
}
#pragma mark      ------------ 懒加载
-(UIView *)blackView{
    if (_blackView == nil) {
        self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0.0;
    }
    return _blackView;
}

- (UIView *)whiteView{
    if (_whiteView == nil) {
        self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(-(kScreenWidth - 100), 0, kScreenWidth - 100, kScreenHeight)];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        NSArray *array = @[@"首页", @"排行榜", @"栏目", @"搜索", @"设置", @"夜间模式", @"离线"];
        for (int i = 0; i < 7; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i + 1;
            NSString *str = array[i];
            if (str.length > 2) {
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, -150,                                                                                  0, 0);
                if (str.length == 3) {
                    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -160,                                                                                  0, 0);
                }
            } else {
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, -180,                                                                                  0, 0);
            }
            
            btn.frame = CGRectMake(0, 150 + 44 * i, kScreenWidth - 100, 44);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"%@", array[i]] forState:UIControlStateNormal];
            NSString *imageStr = [NSString stringWithFormat:@"icon_%d", i + 1];
            [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(goToNext:) forControlEvents:UIControlEventTouchUpInside];
            [self.whiteView addSubview:btn];
    }
    }
    return _whiteView;
}
- (UIView *)loginView{
    if (_loginView == nil) {
        self.loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 150)];
        self.loginView.backgroundColor = [UIColor redColor];
    }
    return _loginView;
}
- (UIButton *)btn{
    if (_btn == nil) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(0, 0, kScreenWidth - 100, 150);
        [self.btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}
- (void)goToNext:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
        {
            [self dismissLeftView];
            MainViewController *mainVC = [[MainViewController alloc] init];
            [self.delegate getWitchViewController:mainVC];
        }
            break;
        case 2:
        {
            [self dismissLeftView];
            TopViewController *topVC = [[TopViewController alloc] init];
            [self.delegate getWitchViewController:topVC];
        }
            break;
        case 3:
        {
            [self dismissLeftView];
            ListViewController *listVC = [[ListViewController alloc] init];
            [self.delegate getWitchViewController:listVC];
        }
            break;
        case 4:
        {
            [self dismissLeftView];
            SerachViewController *serach = [[SerachViewController alloc] init];
            [self.delegate getWitchViewController:serach];
        }
            break;
        case 5:
        {
            [self dismissLeftView];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Set" bundle:nil];
            SetViewController *setVC = [story instantiateViewControllerWithIdentifier:@"Set"];
            [self.delegate getWitchViewController:setVC];
        }
            break;
        case 6:
        {
            NSLog(@"%d", night);
            if (night) {
                [btn setImage:[UIImage imageNamed:@"icon_sidebar_sun"] forState:UIControlStateNormal];
                [btn setTitle:@"白天模式" forState:UIControlStateNormal];
                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                window.alpha = 1.0;
                window.backgroundColor = [UIColor whiteColor];
                night = NO;
            } else {
                [btn setImage:[UIImage imageNamed:@"icon_6"] forState:UIControlStateNormal];
                [btn setTitle:@"夜间模式" forState:UIControlStateNormal];
                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                window.backgroundColor = [UIColor blackColor];
                window.alpha = 0.5;
                night = YES;
            }
            
        }
            break;
        case 7:
        {
        }
            break;
            
        default:
            break;
    }
}

- (void)dismissLeftView{
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.0;
        self.whiteView.frame = CGRectMake(-(kScreenWidth - 100), 0, kScreenWidth - 100, kScreenHeight);
    }];
}
//登陆
- (void)loginAction{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.delegate getWitchViewController:loginVC];
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.0;
        self.whiteView.frame = CGRectMake(-(kScreenWidth - 100), 0, kScreenWidth - 100, kScreenHeight);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
