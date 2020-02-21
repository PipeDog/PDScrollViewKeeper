//
//  PDPageViewController.m
//  PDScrollViewRepairer
//
//  Created by liang on 2020/2/7.
//  Copyright © 2020 liang. All rights reserved.
//

#import "PDPageViewController.h"
#import "PDScrollViewKeeper.h"

@interface PDPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, PDScrollViewKeeperDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, strong) NSMutableArray<UITableView *> *tableViews;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation PDPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commitInit];
}

- (void)commitInit {
    [self.view addSubview:self.collectionView];
    
    self.collectionView.frame =  CGRectMake(0, 40.f, [UIScreen mainScreen].bounds.size.width, [self.delegate containerViewHeight] - 40.f);
    
    self.numberOfPages = 3;
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        // Create button
        CGRect buttonRect = CGRectMake(i * 80.f, 0.f, 80.f, 40.f);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor systemGroupedBackgroundColor];
        button.frame = buttonRect;
        button.tag = i;
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%zd", i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        // Create tableView
        CGRect tableRect = CGRectMake(0,
                                      0,
                                      [UIScreen mainScreen].bounds.size.width,
                                      [self.delegate containerViewHeight] - 40.f);
        UITableView *tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        tableView.contentInset = UIEdgeInsetsMake(30.f, 0.f, 0.f, 0.f);
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // Add to array
        [self.buttons addObject:button];
        [self.tableViews addObject:tableView];
        
        [self.keeper attachChildScrollView:tableView atIndex:i];
    }
    
    [self.collectionView reloadData];
    [self.tableViews makeObjectsPerformSelector:@selector(reloadData)];
}

- (void)didClickButton:(UIButton *)sender {
    self.currentPage = sender.tag;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

    [self.keeper setSelectedIndex:self.currentPage];
}

#pragma mark - PDScrollViewRepairerDelegate
- (CGFloat)thresholdContentOffsetYForSuperScrollView:(UIScrollView *)scrollView {
    return 44.f * 10;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfPages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UITableView *tableView = self.tableViews[indexPath.row];
    [cell.contentView addSubview:tableView];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"section: %zd, row: %zd", indexPath.section, indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) { return; }
    
    [self.keeper childScrollViewDidScroll:scrollView];
}

#pragma mark - Getter Methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [self.delegate containerViewHeight] - 40.f);
        layout.minimumInteritemSpacing = 0.f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40.f, [UIScreen mainScreen].bounds.size.width, [self.delegate containerViewHeight] - 40.f) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor systemGroupedBackgroundColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.pagingEnabled = YES;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    }
    return _collectionView;
}

- (NSMutableArray<UITableView *> *)tableViews {
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray<UIButton *> *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (PDScrollViewKeeper *)keeper {
    return [PDScrollViewKeeper keeperWithIdentifier:@"testIdentifier"];
}

@end
