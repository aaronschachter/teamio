//
//  TMIOUser.h
//  teamio
//
//  Created by Aaron Schachter on 7/20/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMIOUser : NSManagedObject

- (UIColor *)color;

+ (TMIOUser *)createUserInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSArray *)fetchUsersInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

NS_ASSUME_NONNULL_END

#import "TMIOUser+CoreDataProperties.h"
