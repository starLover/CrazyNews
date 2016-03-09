//
//  VideoTableViewCell.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/6.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "VideoTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <MediaPlayer/MediaPlayer.h>
#import <ShareSDK/ShareSDK.h>

@interface VideoTableViewCell ()
@property(nonatomic, strong) MPMoviePlayerController *moviePlayer;

@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLength;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *playCount;
@property (strong, nonatomic) IBOutlet UIButton *goodBtn;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *blackView;
- (IBAction)playAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@property(nonatomic, strong) NSString *urlStr;


@end
@implementation VideoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setMainModel:(MainModel *)mainModel{
    self.urlStr = mainModel.first_url;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.image] placeholderImage:nil];
    self.timeLength.text = mainModel.play_time;
    self.titleLabel.text = mainModel.title;
    NSString *playCountStr = [NSString stringWithFormat:@"%@ 播放", mainModel.play_count_string];
    self.playCount.text = playCountStr;
    [self.goodBtn setTitle:mainModel.vote_count forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@", mainModel.comment_count] forState:UIControlStateNormal];
    
}
-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        //        NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"乐享极智" ofType:@".mp4"];
        //        NSURL *url=[NSURL fileURLWithPath:urlStr];
        
        
        self.urlStr = [self.urlStr stringByAddingPercentEscapesUsingEncoding:
                NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:self.urlStr];
        //初始化播放器并设置播放模式
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        //.view 播放器视图，如果要显示视频，必须将此播放器添加到控制器视图中
        _moviePlayer.view.frame = CGRectMake(8, 8, 359, 190);
        _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.moviePlayer.view];
    }
    return _moviePlayer;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playAction:(id)sender {
    [self.moviePlayer play];
}

- (IBAction)shareAction:(id)sender {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, -667, 0, 0)];
    self.view.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0;
    [window addSubview:self.blackView];
    [window addSubview:self.view];

    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.5;
        self.view.frame = CGRectMake(30, 300, kScreenWidth - 60, 200);

    }];
    
    NSArray *array = @[@"微信好友", @"朋友圈", @"QQ", @"QQ空间"];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * (kScreenWidth - 60) / 4, 0, (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4);
        btn.tag = i + 1;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"umeng_%d", i + 1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareToFriend:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = (kScreenWidth - 60) / 4 / 2;
        btn.clipsToBounds = YES;
        [self.view addSubview:btn];
        
        //
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4 - 30, (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4)];
        label.text = [NSString stringWithFormat:@"%@", array[i]];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(0, 20 + (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4);
    [btn5 setImage:[UIImage imageNamed:@"umeng_5"] forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(shareToFriend:) forControlEvents:UIControlEventTouchUpInside];
    btn5.layer.cornerRadius = (kScreenWidth - 60) / 4 / 2;
    btn5.clipsToBounds = YES;
    [self.view addSubview:btn5];
    
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenWidth - 60) / 2 - 20, (kScreenWidth - 60) / 4, (kScreenWidth - 60) / 4)];
    label.text = @"新浪微博";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];

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
        SSDKPlatformType typeId;
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
                typeId = SSDKPlatformSubTypeQZone;
                break;
            case 5:
                typeId = SSDKPlatformTypeSinaWeibo;
                break;
            default:
                break;
        }
        
        
        
        

        [ShareSDK share:typeId parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
        }];
    }
    [self disappearView];
}

- (void)disappearView{
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0;
        self.view.frame = CGRectMake(0, -667, 0, 0);
    }];
    [self.view removeFromSuperview];
}

@end
