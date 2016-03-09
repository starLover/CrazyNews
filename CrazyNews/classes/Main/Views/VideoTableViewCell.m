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

@interface VideoTableViewCell ()
@property(nonatomic, strong) MPMoviePlayerController *moviePlayer;

@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLength;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *playCount;
@property (strong, nonatomic) IBOutlet UIButton *goodBtn;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
- (IBAction)playAction:(id)sender;

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
@end
