//
//  TMIOUser.m
//  teamio
//
//  Created by Aaron Schachter on 7/20/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "TMIOUser.h"

@implementation TMIOUser

- (UIColor *)color {
    // ala http://stackoverflow.com/a/12397366/1470725
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:self.colorHex];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

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
