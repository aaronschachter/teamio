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

@property (assign, nonatomic) BOOL networkRequestCompleted;
@property (strong, nonatomic) NSError *networkError;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TMIOUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"#team";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.networkRequestCompleted = NO;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TMIOActionButtonCell" bundle:nil] forCellReuseIdentifier:@"actionButtonCell"];
    self.tableView.alwaysBounceVertical = NO;

    [self.view addSubview:self.tableView];
    
    [self loadUsers];
}

#pragma mark - TMIOUserListViewController

- (void)loadUsers {
    __block TMIOAppDelegate *appDelegate = (TMIOAppDelegate *)[UIApplication sharedApplication].delegate;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager loadUsersInManagedObjectContext:appDelegate.managedObjectContext completionHandler:^(NSArray *users) {

        self.networkRequestCompleted = YES;

        self.networkError = nil;
        self.users = users;
        [self.tableView reloadData];

    } errorHandler:^(NSError *error) {

        self.networkRequestCompleted = YES;

        // We got an error back, so let's check for users we have stored locally.
        self.users = [TMIOUser fetchUsersInManagedObjectContext:appDelegate.managedObjectContext];
        if (self.users.count > 0) {
            // Return without setting self.networkError... for now we'll just pretend it was never there and load from local storage.
            // Could potentially display network error with context about loading data locally.
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

// Display ActionButtonCell when we have a network error or no users returned.
- (BOOL)displayActionButtonCell {
    return (self.networkError || (self.users.count == 0 && self.networkRequestCompleted));
}

#pragma mark - TMIOActionButtonCellDelegate

- (void)didTouchActionButtonForCell:(TMIOActionButtonCell *)cell {
    self.networkRequestCompleted = NO;
    [self loadUsers];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.displayActionButtonCell) {
        return 1;
    }
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.displayActionButtonCell) {
        TMIOActionButtonCell *actionButtonCell = [tableView dequeueReusableCellWithIdentifier:@"actionButtonCell" forIndexPath:indexPath];
        actionButtonCell.delegate = self;
        actionButtonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        actionButtonCell.contentView.userInteractionEnabled = YES;
        if (self.networkError) {
            actionButtonCell.titleLabelText = @"Network error";
            actionButtonCell.subtitleLabelText = @"Can't find the internet :(";
        }
        else {
            actionButtonCell.titleLabelText = @"No team members found";
            actionButtonCell.subtitleLabelText = @"Don't worry, someone will probably join soon... :|";
        }
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
    if (self.displayActionButtonCell) {
        return;
    }

    TMIOUser *user = [self userForIndexPath:indexPath];
    TMIOUserProfileViewController *viewController = [[TMIOUserProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.displayActionButtonCell) {
        return self.tableView.bounds.size.height;
    }
    return UITableViewAutomaticDimension;
}

@end
