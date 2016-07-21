//
//  TMIOUserProfileViewController.m
//  teamio
//

#import "TMIOUserProfileViewController.h"

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    NSString *labelText = @"";
    switch (indexPath.row) {
        case 0:
            labelText = [NSString stringWithFormat:@"@%@", self.user.userName];
            break;
        case 1:
            labelText = self.user.title;
            break;
    }
    cell.textLabel.text = labelText;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

@end
