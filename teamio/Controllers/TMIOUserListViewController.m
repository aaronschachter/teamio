//
//  TMIOUserListViewController.m
//  teamio
//

#import "TMIOUserListViewController.h"
#import "TMIOUserProfileViewController.h"
#import "TMIOAppDelegate.h"
#import "TMIOUser.h"
#import "AFHTTPSessionManager+TMIO.h"

@interface TMIOUserListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *users;
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
    
    __block TMIOAppDelegate *appDelegate = (TMIOAppDelegate *)[UIApplication sharedApplication].delegate;
    self.users = [TMIOUser fetchUsersInManagedObjectContext:appDelegate.managedObjectContext];

    // For now, assuming we don't need to fetch latest data from server if we already have users stored locally.
    if (self.users.count > 0) {
        [self.tableView reloadData];
        return;
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager loadUsersInManagedObjectContext:appDelegate.managedObjectContext completionHandler:^(NSArray *users) {
        self.users = users;
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
        // @todo Display epic fail message.
    }];
}

#pragma mark - TMIOUserListViewController

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
