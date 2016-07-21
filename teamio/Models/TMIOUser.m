//
//  TMIOUser.m
//  teamio
//
//  Created by Aaron Schachter on 7/20/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "TMIOUser.h"

@implementation TMIOUser

+ (TMIOUser *)createUserInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [NSEntityDescription insertNewObjectForEntityForName:@"TMIOUser" inManagedObjectContext:managedObjectContext];
}

+ (NSArray *)fetchUsersInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"TMIOUser" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"realName" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error = nil;
    return [managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

@end
