//
//  UrlString+CoreDataProperties.h
//  
//
//  Created by wanghongxiao on 16/3/11.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UrlString.h"

NS_ASSUME_NONNULL_BEGIN

@interface UrlString (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *url;

@end

NS_ASSUME_NONNULL_END
