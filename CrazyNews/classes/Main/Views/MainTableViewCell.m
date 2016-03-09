//
//  MainTableViewCell.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/3.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "MainTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIColor+forRGB.h"

@interface MainTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *bigImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setMainModel:(MainModel *)mainModel{
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:mainModel.thumbnail] placeholderImage:[UIImage imageNamed:@""]];

    //section_name和name
    if (!mainModel.section_name) {
        self.name.text = [NSString stringWithFormat:@"%@ 推荐", mainModel.name];
    } else{
        self.name.text = mainModel.section_name;
    }
    //有无头像
    if (mainModel.avatar) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.avatar]];
        self.headImageView.clipsToBounds = YES;
        self.headImageView.layer.cornerRadius = 10;
    } else {
        [self.headImageView removeFromSuperview];
        //没有头像的话需要让文字向左移动,而且改变文字颜色
        CGRect frame1 = self.name.frame;
        frame1 = CGRectMake(115, 15, kScreenWidth - 112 - 15, 20);
        self.name.frame = frame1;
        UIColor *color = [[UIColor alloc] init];
        self.name.textColor = [color getRGB:mainModel.section_color];

    }
    //
    self.name.font = [UIFont systemFontOfSize:12.0];
    //简介
    self.detailLabel.text = mainModel.title;
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.font = [UIFont systemFontOfSize:17.0];
    //author_name和source_name
    if (!mainModel.author_name) {
        self.countLabel.text = [NSString stringWithFormat:@"%@ | %@ 阅读", mainModel.source_name, mainModel.hit_count_string];
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"%@ | %@ 阅读", mainModel.author_name, mainModel.hit_count_string];
    }
    self.countLabel.font = [UIFont systemFontOfSize:12.0];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
