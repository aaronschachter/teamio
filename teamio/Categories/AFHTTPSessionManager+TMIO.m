//
//  AFHTTPSessionManager+TMIO.m
//  teamio
//

#import "AFHTTPSessionManager+TMIO.h"
#import "TMIOUser.h"

@implementation AFHTTPSessionManager (TMIO)

- (void)loadUsersInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext completionHandler:(void (^)(NSArray *))completionHandler errorHandler:(void (^)(NSError *))errorHandler {
    NSDictionary *secretsDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"secrets" ofType:@"plist"]];
    NSString *apiURLString = [NSString stringWithFormat:@"https://slack.com/api/users.list?token=%@", secretsDict[@"slackApiKey"]];
    [self GET:apiURLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSMutableArray *mutableUsers = [[NSMutableArray alloc] init];
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        for (NSDictionary *memberDict in (NSArray *)responseDict[@"members"]) {
            TMIOUser *user = [TMIOUser createUserInManagedObjectContext:managedObjectContext];
            user.userId = memberDict[@"id"];
            user.colorHex = memberDict[@"color"];
            user.userName = memberDict[@"name"];
            user.realName = memberDict[@"real_name"];
            // @todo: Safety checks that profile key exists.
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
        NSLog(@"Error: %@", error);
    }];
}

@end
