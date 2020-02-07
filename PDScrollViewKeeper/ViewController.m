//
//  ViewController.m
//  PDScrollViewRepairer
//
//  Created by liang on 2020/2/7.
//  Copyright © 2020 liang. All rights reserved.
//

#import "ViewController.h"
#import "PDPageViewController.h"
#import "PDScrollViewKeeper.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, PDPageViewControllerDelegate, PDScrollViewKeeperDelegate>

@property (nonatomic, strong) PDKeepTableView *tableView;
@property (nonatomic, strong) PDPageViewController *pageViewController;
@property (nonatomic, strong) PDScrollViewKeeper *keeper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commitInit];
    [self createViewHierarchy];
    [self layoutContentViews];
}

- (void)commitInit {
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
}

- (void)createViewHierarchy {
    [self.view addSubview:self.tableView];
}

- (void)layoutContentViews {
    self.tableView.frame = CGRectMake(0, 40.f, [UIScreen mainScreen].bounds.size.width, [self containerViewHeight]);
}

#pragma mark - UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 10 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44.f;
    }
    return [self containerViewHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    
    if (indexPath.section == 1) {
        [self.pageViewController.view removeFromSuperview];
        [cell.contentView addSubview:self.pageViewController.view];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"section: %zd, row: %zd", indexPath.section, indexPath.row];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.keeper superScrollViewDidScroll:scrollView];
}

#pragma mark - PDScrollViewKeeperDelegate
- (CGFloat)thresholdContentOffsetYForSuperScrollView:(UIScrollView *)scrollView {
    return [self.tableView rectForSection:1].origin.y;
}

#pragma mark - PDPageViewControllerDelegate
- (UIScrollView *)superScrollView {
    return self.tableView;
}

- (CGFloat)containerViewHeight {
    return [UIScreen mainScreen].bounds.size.height - 80.f;
}

#pragma mrak - Getter Methods
- (PDKeepTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PDKeepTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (PDPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[PDPageViewController alloc] init];
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}

- (PDScrollViewKeeper *)keeper {
    PDScrollViewKeeper *keeper = [PDScrollViewKeeper keeperWithIdentifier:@"testIdentifier"];
    if (!keeper.delegate) {
        [keeper attachSuperView:self.tableView];
        keeper.delegate = self;
    }
    return [PDScrollViewKeeper keeperWithIdentifier:@"testIdentifier"];
}

@end
