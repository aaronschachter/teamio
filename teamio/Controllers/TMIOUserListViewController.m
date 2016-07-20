//
//  TMIOUserListViewController.m
//  teamio
//

#import "TMIOUserListViewController.h"
#import "TMIOUserProfileViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface TMIOUserListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TMIOUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"#team";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userCell"];
    [self.view addSubview:self.tableView];

    self.users = [[NSMutableArray alloc] init];

    NSDictionary *secretsDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"secrets" ofType:@"plist"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *apiURLString = [NSString stringWithFormat:@"https://slack.com/api/users.list?token=%@", secretsDict[@"slackApiKey"]];
    [manager GET:apiURLString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        for (NSDictionary *memberDict in (NSArray *)responseDict[@"members"]) {
            [self.users addObject:memberDict];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
    NSDictionary *memberDict = (NSDictionary *)self.users[indexPath.row];
    cell.textLabel.text = memberDict[@"real_name"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *memberDict = (NSDictionary *)self.users[indexPath.row];
    TMIOUserProfileViewController *viewController =  [[TMIOUserProfileViewController alloc] initWithUserDict:memberDict];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
