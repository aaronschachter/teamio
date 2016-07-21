//
//  TMIOAppDelegate.h
//  teamio
//

#import <UIKit/UIKit.h>

@interface TMIOAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIWindow *window;

@end

