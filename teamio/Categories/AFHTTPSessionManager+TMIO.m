//
//  AFHTTPSessionManager+TMIO.m
//  teamio
//

#import "AFHTTPSessionManager+TMIO.h"
#import "TMIOUser.h"

@implementation AFHTTPSessionManager (TMIO)

- (void)loadUsersInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext completionHandler:(void (^)(NSArray *))completionHandler errorHandler:(void (^)(NSError *))errorHandler {
    // We store our API key in untracked secrets.plist to keep code open source.
    NSDictionary *secretsDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"secrets" ofType:@"plist"]];
    NSString *apiURLString = [NSString stringWithFormat:@"https://slack.com/api/users.list?token=%@", secretsDict[@"slackApiKey"]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [self GET:apiURLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSMutableArray *mutableUsers = [[NSMutableArray alloc] init];
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        for (NSDictionary *memberDict in (NSArray *)responseDict[@"members"]) {
            NSString *userId = memberDict[@"id"];
            // Check if we already have a user stored for this ID.
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"TMIOUser" inManagedObjectContext:managedObjectContext]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", userId];
            [fetchRequest setPredicate:predicate];
            NSError *error = nil;
            NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
            TMIOUser *user;
            if (results.count > 0) {
                user = [results objectAtIndex:0];
                NSLog(@"Updating userId %@", userId);
            }
            else {
                user = [TMIOUser createUserInManagedObjectContext:managedObjectContext];
                NSLog(@"Adding userIdl %@", userId);
            }
            user.userId = memberDict[@"id"];
            user.colorHex = memberDict[@"color"];
            user.userName = memberDict[@"name"];
            user.realName = memberDict[@"real_name"];
            user.avatarUri = [memberDict valueForKeyPath:@"profile.image_192"];
            user.title = [memberDict valueForKeyPath:@"profile.title"];
            [mutableUsers addObject:user];
        }
        NSError *error;
        [managedObjectContext save:&error];
        if (completionHandler) {
            completionHandler(mutableUsers.copy);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (errorHandler) {
            errorHandler(error);
        }
    }];
}

@end
