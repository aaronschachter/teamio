//
//  TMIOUserProfileViewController.m
//  teamio
//

#import "TMIOUserProfileViewController.h"

@interface TMIOUserProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *user;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TMIOUserProfileViewController

#pragma mark - NSObject

- (instancetype)initWithUserDict:(NSDictionary *)userDict {
    self = [super init];
    
    if (self) {
        _user = userDict;
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.user[@"real_name"];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"@%@", self.user[@"name"]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

@end
