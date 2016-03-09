//
//  ListTableViewCell.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/8.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "ListTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface ListTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;

@end
@implementation ListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMainModel:(MainModel *)mainModel{
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.thumbnail] placeholderImage:nil];
    self.nameLabel.text = mainModel.name;
    self.titleLabel.text = mainModel.description1;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
