//
//  TMIOUserListViewController.m
//  teamio
//

#import "TMIOUserListViewController.h"
#import "TMIOUserProfileViewController.h"
#import "TMIOAppDelegate.h"
#import "TMIOUser.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface TMIOUserListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TMIOUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"#team";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userCell"];
    [self.view addSubview:self.tableView];

    self.users = (NSMutableArray *)[TMIOUser fetchUsersInManagedObjectContext:self.managedObjectContext];
    if (self.users.count > 0) {
        [self.tableView reloadData];
        return;
    }
    
    self.users = [[NSMutableArray alloc] init];
    NSDictionary *secretsDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"secrets" ofType:@"plist"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *apiURLString = [NSString stringWithFormat:@"https://slack.com/api/users.list?token=%@", secretsDict[@"slackApiKey"]];
    [manager GET:apiURLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        for (NSDictionary *memberDict in (NSArray *)responseDict[@"members"]) {
            TMIOUser *user = [self upsertUserWithDict:memberDict];
            [self.users addObject:user];
        }
        NSError *error;
        [self.managedObjectContext save:&error];
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - TMIOUserListViewController

- (NSManagedObjectContext *)managedObjectContext {
    __block TMIOAppDelegate *appDelegate = (TMIOAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.managedObjectContext;
}

- (TMIOUser *)upsertUserWithDict:(NSDictionary *)dict {
    // @todo Check if ID exists. Right now we're blindly inserting.
    TMIOUser *user = [TMIOUser createUserInManagedObjectContext:self. managedObjectContext];
    user.userId = dict[@"id"];
    user.colorHex = dict[@"color"];
    user.userName = dict[@"name"];
    user.realName = dict[@"real_name"];
    // Note: we may want to use image_192 property if original image loadtimes are weaksauce.
    user.avatarUri = [dict valueForKeyPath:@"profile.image_original"];
    user.title = [dict valueForKeyPath:@"profile.title"];
    return user;
}

- (TMIOUser *)userForIndexPath:(NSIndexPath *)indexPath {
    return (TMIOUser *)self.users[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    TMIOUser *user = [self userForIndexPath:indexPath];
    cell.textLabel.text = user.realName;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TMIOUser *user = [self userForIndexPath:indexPath];
    TMIOUserProfileViewController *viewController = [[TMIOUserProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
