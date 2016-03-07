//
//  TimeStamp.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/5.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "TimeStamp.h"

@implementation TimeStamp
+ (NSTimeInterval)getNewStamp{
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    return time;
}
@end
