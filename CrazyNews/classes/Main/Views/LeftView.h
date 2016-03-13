//
//  LeftView.h
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/5.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pushViewControllerDelegate <NSObject>

- (void)getWitchViewController:(UIViewController *)VC;

@end
@interface LeftView : UIView
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *image;

@property(nonatomic, assign) id<pushViewControllerDelegate>delegate;
@end
