//
//  LoginViewController.h
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/8.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol userImageDelegate <NSObject>

- (void)getUserImage:(NSString *)name;
@end

@interface LoginViewController : UIViewController
@property(nonatomic, assign) id<userImageDelegate>delegate;
@end
