//
//  TMIOUserProfileViewController.m
//  teamio
//

#import "TMIOUserProfileViewController.h"
#import "TMIOUserProfileHeaderCell.h"
#import "TMIOUserProfileDataCell.h"

@interface TMIOUserProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) TMIOUser *user;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TMIOUserProfileViewController

#pragma mark - NSObject

- (instancetype)initWithUser:(TMIOUser *)user {
    self = [super init];
    
    if (self) {
        _user = user;
        _userPhone = [[user.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"TMIOUserProfileDataCell" bundle:nil] forCellReuseIdentifier:@"profileDataCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.alwaysBounceVertical = NO;

    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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

    TMIOUserProfileDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileDataCell" forIndexPath:indexPath];

    switch (indexPath.row) {
        case 1:
            cell.propertyNameLabelText = @"title";
            cell.propertyValueLabelText = self.user.title;
            break;
        case 2:
            cell.propertyNameLabelText = @"phone";
            cell.propertyValueLabelText = self.userPhone;
            break;
        case 3:
            cell.propertyNameLabelText = @"email";
            cell.propertyValueLabelText = self.user.email;
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 220;
    }
    return 70;
}

@end
