//
//  CreateViewController.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/9.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "CreateViewController.h"
#import <BmobSDK/Bmob.h>

@interface CreateViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *surePassword;
- (IBAction)createAction:(id)sender;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (IBAction)createAction:(id)sender {
    
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUsername:self.userName.text];
    [bUser setPassword:self.surePassword.text];
    if ([self.userName.text containsString:@" "]) {
        [self addAlertController:@"无效的用户名"];
    }
    //密码
    if ([self.password.text isEqualToString:self.surePassword.text]) {
        [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
            NSString *messageStr;
            if (isSuccessful) {
                messageStr = @"注册成功";
            } else {
                messageStr = @"注册失败";
            }
            [self addAlertController:messageStr];
        }];
    } else {
        [self addAlertController:@"两次密码输入不一致"];
    }
    
//    BmobObject *user = [BmobObject objectWithClassName:@"CrazyUser"];
//    NSDictionary *dic = @{@"name":self.userName.text, @"password":self.password.text};
//    [user saveAllWithDictionary:dic];
//    if ([self.password.text isEqualToString:self.surePassword.text]) {
//        [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        }];
//    }
    
  }
@end
