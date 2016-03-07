//
//  MainModel.h
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/4.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject
@property(nonatomic, copy) NSString *article_type;
@property(nonatomic, copy) NSString *author_avatar;
@property(nonatomic, copy) NSString *author_name;
@property(nonatomic, copy) NSString *author_id;
@property(nonatomic, copy) NSString *author_summary;
@property(nonatomic, copy) NSString *display_date;
@property(nonatomic, copy) NSString *ga_prefix;
@property(nonatomic, copy) NSString *guide;
@property(nonatomic, copy) NSString *guide_image;
@property(nonatomic, copy) NSString *hit_count;
@property(nonatomic, copy) NSString *hit_count_string;
@property(nonatomic, copy) NSString *activityId;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *key_words;
@property(nonatomic, copy) NSString *section_color;
@property(nonatomic, copy) NSString *section_id;
@property(nonatomic, copy) NSString *section_image;
@property(nonatomic, copy) NSString *section_name;
@property(nonatomic, copy) NSString *share_image;
@property(nonatomic, copy) NSString *share_url;
@property(nonatomic, copy) NSString *link;
@property(nonatomic, copy) NSString *tag;
@property(nonatomic, copy) NSString *tag_text;
@property(nonatomic, copy) NSString *thumbnail;
@property(nonatomic, copy) NSString *timestamp;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *video_file_url;
@property(nonatomic, copy) NSString *video_image_url;
@property(nonatomic, copy) NSString *visiable;
@property(nonatomic, copy) NSString *vote_count;
@property(nonatomic, copy) NSArray *recommenders;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *source_name;
@property(nonatomic, copy) NSString *play_count_string;
@property(nonatomic, copy) NSString *first_url;
@property(nonatomic, copy) NSString *play_time;
@property(nonatomic, copy) NSString *comment_count;


+ (MainModel *)getDictionary:(NSDictionary *)dic;

@end
