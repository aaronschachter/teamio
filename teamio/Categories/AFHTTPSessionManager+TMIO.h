//
//  AFHTTPSessionManager+TMIO.h
//  teamio
//

// Eventually would subclass AFHTTPSessionManager if we needed to query API more.
// Adding as AFHTTPSessionManager category for now for less code, since we only make/
// a single API request to load users.

#import <AFNetworking/AFHTTPSessionManager.h>

@interface AFHTTPSessionManager (TMIO)

// Loads Users from API and returns as array of TMIOUser objects stored in given managedObjectContext
- (void)loadUsersInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext completionHandler:(void (^)(NSArray *))completionHandler errorHandler:(void (^)(NSError *))errorHandler;

@end
