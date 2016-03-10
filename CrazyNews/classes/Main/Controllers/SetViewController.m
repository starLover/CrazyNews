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
#import "ProgressHUD.h"
#import <ShareSDK/ShareSDK.h>


@interface SetViewController ()<pushViewControllerDelegate, MFMailComposeViewControllerDelegate>
- (IBAction)checkAction:(id)sender;
- (IBAction)shareAction:(id)sender;
- (IBAction)bigTitleAction:(id)sender;
- (IBAction)cleanAction:(id)sender;
- (IBAction)helpAction:(id)sender;

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *blackView;
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

- (IBAction)checkAction:(id)sender {
    [ProgressHUD show:@"正在检测..."];
    [self performSelector:@selector(endCheck) withObject:nil afterDelay:2.0];
}

- (void)endCheck{
    [ProgressHUD showSuccess:@"恭喜！已是最新版本"];
}

- (IBAction)shareAction:(id)sender {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, -667, 0, 0)];
    self.view1.layer.cornerRadius = 5;
    self.view1.backgroundColor = [UIColor whiteColor];
    
    self.blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0;
    [window addSubview:self.blackView];
    [window addSubview:self.view1];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.5;
        self.view1.frame = CGRectMake(30, 300, kScreenWidth - 60, 200);
        
    }];
    
    NSArray *array = @[@"微信好友", @"朋友圈", @"QQ", @"QQ空间"];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * (kScreenWidth - 60) / 4, 0, (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4);
        btn.tag = i + 1;
        NSLog(@"!!!%lu", btn.tag);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"umeng_%d", i + 1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareToFriend:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = (kScreenWidth - 60) / 4 / 2;
        btn.clipsToBounds = YES;
        [self.view1 addSubview:btn];
        
        //
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4 - 30, (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4)];
        label.text = [NSString stringWithFormat:@"%@", array[i]];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view1 addSubview:label];
    }
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(0, 20 + (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4);
    [btn5 setImage:[UIImage imageNamed:@"umeng_5"] forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(shareToFriend:) forControlEvents:UIControlEventTouchUpInside];
    btn5.layer.cornerRadius = (kScreenWidth - 60) / 4 / 2;
    btn5.tag = 5;
    btn5.clipsToBounds = YES;
    [self.view1 addSubview:btn5];
    
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenWidth - 60) / 2 - 20, (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4)];
    label.text = @"新浪微博";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view1 addSubview:label];
    
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearView)];
    [self.blackView addGestureRecognizer:tap];
}
//分享给朋友
- (void)shareToFriend:(UIButton *)btn{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"btn_nav_favourite_pre"]];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupShareParamsByText:@"CrazyNews,独怜幽草涧边生，上有黄鹂深树鸣。春潮带雨晚来急，野渡无人舟自横"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        
        SSDKPlatformType typeId = 0;
        switch (btn.tag) {
            case 1:
                //微信好友
                typeId = SSDKPlatformSubTypeWechatSession;
                break;
            case 2:
                //微信朋友圈;
                typeId = SSDKPlatformSubTypeWechatTimeline;
                break;
            case 3:
                //QQ好友
                typeId = SSDKPlatformSubTypeQQFriend;
                break;
            case 4:
                //QQ空间
                typeId = SSDKPlatformSubTypeQZone;
                break;
            case 5:
                //新浪微博
                typeId = SSDKPlatformTypeSinaWeibo;
                break;
            default:
                break;
        }
        
        [ShareSDK share:typeId
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                         message:[NSString stringWithFormat:@"%@", error]
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 default:
                     break;
             }
         }];
        
        
        
    }
    [self disappearView];
}

- (void)disappearView{
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0;
        self.view1.frame = CGRectMake(0, -667, 0, 0);
    }];
    [self.view1 removeFromSuperview];
}

- (IBAction)bigTitleAction:(id)sender {
}

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
