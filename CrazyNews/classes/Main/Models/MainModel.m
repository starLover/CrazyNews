//
//  MainModel.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/4.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _article_type = dic[@"article_type"];
        _author_avatar = dic[@"author_avatar"];
        _author_id = dic[@"author_id"];
        _author_name = dic[@"author_name"];
        _author_summary = dic[@"author_summary"];
        _display_date = dic[@"display_date"];
        _ga_prefix = dic[@"ga_prefix"];
        _guide = dic[@"guide"];
        _guide_image = dic[@"guide_image"];
        _hit_count = dic[@"hit_count"];
        _hit_count_string = dic[@"hit_count_string"];
        _activityId= dic[@"id"];
        _image = dic[@"image"];
        _key_words = dic[@"key_words"];
        _section_color = dic[@"section_color"];
        _section_id = dic[@"section_id"];
        _section_image = dic[@"section_image"];
        _section_name = dic[@"section_name"];
        _share_image = dic[@"share_image"];
        _share_url = dic[@"share_url"];
        _link = dic[@"link"];
        _tag = dic[@"tag"];
        _tag_text = dic[@"tag_text"];
        _thumbnail = dic[@"thumbnail"];
        _timestamp = dic[@"timestamp"];
        _title = dic[@"title"];
        _url = dic[@"url"];
        _video_file_url = dic[@"video_file_url"];
        _video_image_url = dic[@"video_image_url"];
        _visiable = dic[@"visiable"];
        _vote_count = dic[@"vote_count"];
        _source_name = dic[@"source_name"];
        //数组
        _recommenders = dic[@"recommenders"];
        if (_recommenders.count > 0) {
            NSDictionary *recomDic = _recommenders[0];
            _avatar = recomDic[@"avatar"];
            _name = recomDic[@"name"];
        }
    }
    return self;
}
+ (MainModel *)getDictionary:(NSDictionary *)dic{
    MainModel *mainModel = [[MainModel alloc] initWithDictionary:dic];
    return mainModel;
}
@end
