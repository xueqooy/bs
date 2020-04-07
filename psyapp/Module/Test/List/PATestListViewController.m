//
//  PATestListViewController.m
//  psyapp
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "PATestListViewController.h"
#import "TCTestDetailViewController.h"

#import "PAPeriodStageSelectionView.h"
#import "TCTestListTableViewCell.h"
#import "FESlidingHintView.h"


#import "PATestCategoryManager.h"
#import "PATestListDataManager.h"
#import "TCProductModel.h"
@interface PATestListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PAPeriodStageSelectionView *selectionView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <PATestListDataManager *>*dataManagers;

@property (nonatomic, weak) PATestListDataManager *currentDataManager;
@end

@implementation PATestListViewController {
    NSArray <NSString *>*_stageNames;
    
    BOOL _swipeAnimating;
    BOOL _selectionViewCollapsed;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = UIColor.fe_backgroundColor;
    _selectionView = PAPeriodStageSelectionView.new;
    [self.view addSubview:_selectionView];
    [_selectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.mas_equalTo(STWidth(90));
    }];
    
    _tableView = UITableView.new;
    _tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.alwaysBounceVertical = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = STWidth(100);
    @weakObj(self);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfweak loadDataForFirst:YES];
    }];
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_tableView.mj_header;
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"数据加载中···" forState:MJRefreshStateRefreshing];
    header.backgroundColor = UIColor.clearColor;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.left.equalTo(_selectionView.mas_right).offset(STWidth(10));
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _stageNames = PATestCategoryManager.sharedInstance.stageNames;
    _selectionView.stageNames = _stageNames;
    @weakObj(self);
    _selectionView.onSelect = ^(NSInteger index) {
        if (index >= 0 && index < selfweak.dataManagers.count) {
            selfweak.currentDataManager = selfweak.dataManagers[index];
        } else {
            selfweak.currentDataManager = nil;
        }
        if (selfweak.currentDataManager) {
            if (selfweak.currentDataManager.loaded) {
                [selfweak.tableView reloadData];
                [selfweak showEmptyViewIfEmpty];
            } else {
                [selfweak loadDataForFirst:YES];
            }
        } else {
            [selfweak.tableView reloadData];
        }
        
        selfweak.tableView.alreadyLoadAllData = selfweak.currentDataManager.list.alreadyLoadAll;
    };
    [_tableView addFooterRefreshTarget:self action:@selector(appendData)];
    [self initDataManager];
    [self loadDataForFirst:YES];
    
    [self addSwipeGestureRecognizer];
    
    [self showSwipeHintIfNeeded];
}

- (void)showSwipeHintIfNeeded {
    if (AppSettingsManager.sharedInstance.hasShowSlideHintForCollapseOnList == NO) {
        [FESlidingHintView showPreviousWithHint:@"左滑收起菜单"];
        AppSettingsManager.sharedInstance.hasShowSlideHintForCollapseOnList = YES;
    }
}

- (void)addSwipeGestureRecognizer {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)recognizer {
    if (_swipeAnimating ) return;
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_selectionViewCollapsed) return;
        self.fd_interactivePopDisabled = YES;
        _swipeAnimating = YES;
        self->_selectionViewCollapsed = YES;
        NSArray *cells = _tableView.visibleCells;
        for (TCTestListTableViewCell *cell  in cells) {
            cell.prefersWiderCellStyle = YES;
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self->_selectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self->_swipeAnimating = NO;
        }];
    } else {
        if (!_selectionViewCollapsed) return;
        _swipeAnimating = YES;
        self->_selectionViewCollapsed = NO;
        NSArray *cells = _tableView.visibleCells;
        for (TCTestListTableViewCell *cell  in cells) {
            cell.prefersWiderCellStyle = NO;
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self->_selectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(STWidth(90));
            }];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self->_swipeAnimating = NO;
            self.fd_interactivePopDisabled = NO;
        }];
    }
}

- (void)initDataManager {
    NSMutableArray *temp = @[].mutableCopy;
    NSArray *stageCodes = PATestCategoryManager.sharedInstance.stageCodes;
    for (NSString *stageCode in stageCodes) {
        PATestListDataManager *listManager = PATestListDataManager.new;
        listManager.categoryName = self.categoryName;
        listManager.stageCode = stageCode;
        [temp addObject:listManager];
    }
    _dataManagers = temp.copy;
    if (_dataManagers && _dataManagers.count > 0) {
        _currentDataManager = _dataManagers.firstObject;
    }
}



- (void)setCategoryName:(NSString *)categoryName {
    _categoryName = categoryName;
    self.title = _categoryName;
}

- (void)appendData {
    [self loadDataForFirst:NO];
}

- (void)loadDataForFirst:(BOOL)forFirst {
    if (_currentDataManager == nil) return;
    if (forFirst) {
        [_currentDataManager.list resetData];
    }
    
    if (_currentDataManager) {
        @weakObj(self);
        [_currentDataManager getProductListOnSuccess:^{
            selfweak.tableView.alreadyLoadAllData = selfweak.currentDataManager.list.alreadyLoadAll;
            [selfweak.tableView reloadData];
            [selfweak.tableView.mj_header endRefreshing];
            [self showEmptyViewIfEmpty];
        } failure:^{
            [selfweak.tableView reloadData];
            [selfweak.tableView.mj_header endRefreshing];
            [selfweak showEmptyViewIfEmpty];
        }];
    }
}

- (void)showEmptyViewIfEmpty {
    if (_currentDataManager.list.isEmpty) {
        [self showEmptyViewInView:self.tableView type:FEErrorType_NoData];
    } else {
        [self hideEmptyView];
    }
}

- (void)showNetErrorViewIfNeeded {
    if (_currentDataManager.list.isEmpty) {
        @weakObj(self);
        [self showEmptyViewForNoNetInView:selfweak.tableView refreshHandler:^{
            [selfweak loadDataForFirst:YES];
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentDataManager.list.currentCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCTestListTableViewCell"];
    if (!cell) {
        cell = [[TCTestListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TCTestListTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentDataManager == nil) return;
    NSArray <TCTestProductItemModel *>*list = _currentDataManager.list.data;
      
    if (indexPath.row < list.count) {
        
        TCTestProductItemModel *item = list[indexPath.row];

        TCTestListTableViewCell *_cell = (TCTestListTableViewCell *)cell;
        _cell.prefersWiderCellStyle = _selectionViewCollapsed;
        
        [_cell setTitleText:item.name participantsCount:item.userCount.intValue iconImageURL:[NSURL URLWithString:item.image] alreadyPurchase:item.isOwn.boolValue presentPrice:item.priceYuan originPrice:item.originPriceYuan];
        if (item.isOwn.boolValue) {
            [_cell setCompleted:item.status.boolValue];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentDataManager == nil) return;
    TCPagedDataManager *list = _currentDataManager.list;
    if (indexPath.row < 0 || indexPath.row >= list.currentCount) return;
    TCTestProductItemModel *item  = list.data[indexPath.row];
    TCTestDetailViewController *detailViewController = [[TCTestDetailViewController alloc] initWithDimensionId:item.dimensionId];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
@end
