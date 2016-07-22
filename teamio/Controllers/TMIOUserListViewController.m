//
//  TMIOUserListViewController.m
//  teamio
//

#import "TMIOUserListViewController.h"
#import "TMIOUserProfileViewController.h"
#import "TMIOActionButtonCell.h"
#import "TMIOAppDelegate.h"
#import "TMIOUser.h"
#import "AFHTTPSessionManager+TMIO.h"

@interface TMIOUserListViewController () <UITableViewDataSource, UITableViewDelegate, TMIOActionButtonCellDelegate>

@property (strong, nonatomic) NSError *networkError;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"TMIOActionButtonCell" bundle:nil] forCellReuseIdentifier:@"actionButtonCell"];

    [self.view addSubview:self.tableView];
    
    [self loadUsers];
}

#pragma mark - TMIOUserListViewController

- (void)loadUsers {
    __block TMIOAppDelegate *appDelegate = (TMIOAppDelegate *)[UIApplication sharedApplication].delegate;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager loadUsersInManagedObjectContext:appDelegate.managedObjectContext completionHandler:^(NSArray *users) {
        self.networkError = nil;
        self.users = users;
        [self.tableView reloadData];
    } errorHandler:^(NSError *error) {
        // Ignore error if we have data stored, load saved data.
        self.users = [TMIOUser fetchUsersInManagedObjectContext:appDelegate.managedObjectContext];
        if (self.users.count > 0) {
            [self.tableView reloadData];
            return;
        }
        self.networkError = error;
        [self.tableView reloadData];
    }];
}

- (TMIOUser *)userForIndexPath:(NSIndexPath *)indexPath {
    return (TMIOUser *)self.users[indexPath.row];
}

#pragma mark - TMIOActionButtonCellDelegate

- (void)didTouchActionButtonForCell:(TMIOActionButtonCell *)cell {
    [self loadUsers];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.networkError || self.users.count == 0) {
        return 1;
    }
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.networkError) {
        TMIOActionButtonCell *actionButtonCell = [tableView dequeueReusableCellWithIdentifier:@"actionButtonCell" forIndexPath:indexPath];
        actionButtonCell.delegate = self;
        actionButtonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        actionButtonCell.contentView.userInteractionEnabled = YES;
        actionButtonCell.titleLabelText = @"Network error";
        actionButtonCell.subtitleLabelText = @"Can't find the internet :(";
        actionButtonCell.actionButtonText = @"Try again";
        return actionButtonCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    TMIOUser *user = [self userForIndexPath:indexPath];
    cell.textLabel.text = user.realName;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.networkError) {
        return;
    }

    TMIOUser *user = [self userForIndexPath:indexPath];
    TMIOUserProfileViewController *viewController = [[TMIOUserProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.networkError) {
        return self.tableView.bounds.size.height;
    }
    return UITableViewAutomaticDimension;
}

@end
