//
//  TMIOUser+CoreDataProperties.h
//  teamio
//
//  Created by Aaron Schachter on 7/20/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TMIOUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMIOUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *colorHex;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *avatarUri;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *realName;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *teamId;

@end

NS_ASSUME_NONNULL_END
