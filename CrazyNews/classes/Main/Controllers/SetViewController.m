//
//  SetViewController.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/9.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "SetViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SetViewController ()<pushViewControllerDelegate, MFMailComposeViewControllerDelegate>
- (IBAction)cleanAction:(id)sender;
- (IBAction)helpAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cleanBtn;

@end

@implementation SetViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    [self.cleanBtn setTitle:[NSString stringWithFormat:@"清除缓存(%.2fM)", (float)cacheSize / 1024 / 1024] forState:UIControlStateNormal];
    self.cleanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -210, 0, 0);
    self.cleanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -70, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 100, 40);
    [backBtn setTitle:@"设置" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"abc_ic_ab_back_mtrl_am_alpha"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
}


//返回主界面
- (void)backToMain{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getWitchViewController:(UIViewController *)VC{
    [self.navigationController pushViewController:VC animated:YES];
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

- (IBAction)cleanAction:(id)sender {
    //清除图片缓存
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定清除缓存?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearDisk];
        [self.cleanBtn setTitle:@"清除缓存(0.0M)" forState:UIControlStateNormal];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)helpAction:(id)sender {
    //初始化
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    //设置代理
    picker.mailComposeDelegate = self;
    //设置主题
    [picker setSubject:@"用户反馈"];
    //设置收件人
    NSArray *reciever = [NSArray arrayWithObjects:@"1498146887@qq.com", nil];
    [picker setToRecipients:reciever];
    //设置发送内容
    [picker setMessageBody:@"请留下您宝贵的意见" isHTML:NO];
    //推出视图
    [self presentViewController:picker animated:YES completion:nil];
}
//邮件发送完成调用的方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
}

@end
