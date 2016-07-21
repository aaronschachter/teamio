//
//  TMIOUserProfileViewController.m
//  teamio
//

#import "TMIOUserProfileViewController.h"
#import "TMIOUserProfileHeaderCell.h"

@interface TMIOUserProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) TMIOUser *user;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TMIOUserProfileViewController

#pragma mark - NSObject

- (instancetype)initWithUser:(TMIOUser *)user {
    self = [super init];
    
    if (self) {
        _user = user;
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.user.realName;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"profileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TMIOUserProfileHeaderCell" bundle:nil] forCellReuseIdentifier:@"profileHeaderCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44;

    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TMIOUserProfileHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"profileHeaderCell" forIndexPath:indexPath];
        headerCell.profileImageViewURLString = self.user.avatarUri;
        headerCell.userNameLabelText = [NSString stringWithFormat:@"@%@", self.user.userName];
        headerCell.backgroundColor = [self.user color];
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return headerCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    cell.textLabel.text = self.user.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 220;
    }
    return UITableViewAutomaticDimension;
}

@end
