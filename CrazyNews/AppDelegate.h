//
//  AppDelegate.h
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/3.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import <UIKit/UIKit.h>
//想使用CoreData必须引入CoreData框架头文件
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//数据管理器（工具）类,它是用来管理数据的：增、删、改、查
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//数据模型（工具）类，他只是提供数据模型，他并不是数据库
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//数据连接器（工具）类（数据持久化存储助理），他把数据管理器和数据模型联系到一起。
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//通过对 数据管理器工具类的保存，将 数据管理器工具类 内管理的对象 保存到 实体数据库中。（把对象保存到数据库中）
- (void)saveContext;

//返回应用程序的Document路径
- (NSURL *)applicationDocumentsDirectory;

@end

