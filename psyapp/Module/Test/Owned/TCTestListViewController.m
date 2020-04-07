//
//  TCTestListViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/13.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestListViewController.h"
#import "TCTestDetailViewController.h"

#import "TCTestListTableViewCell.h"

#import "TCTestListDataManager.h"

@interface TCTestListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TCTestListDataManager *dataManager;
@end

@implementation TCTestListViewController
- (instancetype)init {
    self = [super init];
    _isOwnedList = NO;
    self.categoryId = nil;
    self.dataManager = [[TCTestListDataManager alloc] init];
    return self;
}

- (instancetype)initWithCategoryId:(NSString *)categoryId {
    self = [self init];
    self.categoryId = categoryId;
    self.dataManager.categoryId = _categoryId;
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = UIColor.fe_backgroundColor;
    _tableView = [UITableView new];
    _tableView.backgroundColor = UIColor.fe_backgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
//    _tableView.tableHeaderView = ({
//        UIView *view = UIView.new;
//        view.frame = CGRectMake(0, 0, mScreenWidth, STWidth(10));
//        view.backgroundColor = UIColor.fe_backgroundColor;
//        view;
//    });
    [_tableView addFooterRefreshTarget:self action:@selector(loadData)];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isOwnedList) {
        self.title = @"我的测评";
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.navigationBarShadowHidden = YES;
    [self.dataManager.list resetData];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)updateListData {
    [self.dataManager.list resetData];
    [self loadData];
}

- (void)loadData {
    @weakObj(self);
    TCPeriodStage period = TCPeriodStageNone;
    NSNumber *isOwn = @1;
   
    [self.dataManager getProductListByPeriodStage:period isOwn:isOwn onSuccess:^{
        selfweak.tableView.alreadyLoadAllData = selfweak.dataManager.list.alreadyLoadAll;
        
        [selfweak.tableView reloadData];
        [selfweak showEmptyViewIfEmpty];
    } failure:^{
        [selfweak showNetErrorViewIfNeeded];
    }];
    
}

- (void)showNetErrorViewIfNeeded {
    if (self.dataManager.list.isEmpty) {
        @weakObj(self);
        [self showEmptyViewForNoNetInView:selfweak.view refreshHandler:^{
            [selfweak loadData];
        }];
    }
}

- (void)showEmptyViewIfEmpty {
    if (self.dataManager.list.isEmpty) {
        [self showEmptyViewInView:self.tableView type:FEErrorType_NoData];
    } else {

        [self hideEmptyView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.list.currentCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return STWidth(110);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"TCTestListTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        TCTestListTableViewCell *_cell = [[TCTestListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        _cell.prefersWiderCellStyle = YES;
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = _cell;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray <TCTestProductItemModel *>*list = self.dataManager.list.data;
   
    if (indexPath.row < list.count) {
        TCTestProductItemModel *item = list[indexPath.row];

        TCTestListTableViewCell *_cell = (TCTestListTableViewCell *)cell;
        [_cell setTitleText:item.name participantsCount:item.userCount.intValue iconImageURL:[NSURL URLWithString:item.image] alreadyPurchase:item.isOwn.boolValue presentPrice:item.priceYuan originPrice:item.originPriceYuan];
        if (item.isOwn.boolValue) {
            [_cell setCompleted:item.status.boolValue];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray <TCTestProductItemModel *>*list = self.dataManager.list.data;

    if (indexPath.row < list.count) {
        TCTestProductItemModel *item = list[indexPath.row];
        TCTestDetailViewController *detailViewController = [[TCTestDetailViewController alloc] initWithDimensionId:item.dimensionId];
        detailViewController.title = item.name;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
 
}

@end
