//
//  TCTestSearchViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestSearchViewController.h"
#import "TCTestDetailViewController.h"

#import "TCTestListTableViewCell.h"
@interface TCTestSearchViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TCTestSearchViewController
@synthesize dataManager = _dataManager;
@synthesize filter = _filter;

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = UIColor.fe_backgroundColor;
    _tableView = [UITableView new];
    _tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView addFooterRefreshTarget:self action:@selector(loadData)];

    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}


- (void)loadData {
    @weakObj(self);
    [self.dataManager getSearchResultByFilter:self.filter type:TCSearchTypeTest onSuccess:^{
        selfweak.tableView.alreadyLoadAllData = selfweak.dataManager.dimensionResult.alreadyLoadAll;

        [selfweak.tableView reloadData];
        [selfweak showEmptyViewIfEmpty];
    } failure:^{
        [selfweak showNetErrorViewIfNeeded];
    }];
}

- (void)startSearchWithFilter:(NSString *)filter {
    [self.dataManager.dimensionResult resetData];
    self.filter = filter;
    [self loadData];
}

- (void)showNetErrorViewIfNeeded {
    if (self.dataManager.dimensionResult.isEmpty) {
        @weakObj(self);
        [self showEmptyViewForNoNetInView:selfweak.view refreshHandler:^{
            [selfweak loadData];
        }];
    }
}

- (void)showEmptyViewIfEmpty {
    if (self.dataManager.dimensionResult.isEmpty) {
        [self showEmptyViewInView:self.view type:FEErrorType_NoSeek];
    } else {
        [self hideEmptyView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.dimensionResult.currentCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return STWidth(110);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"TCTestListTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        TCTestListTableViewCell *_cell = [[TCTestListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _cell.prefersWiderCellStyle = YES;
        cell = _cell;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray <TCDimensionSearchResultItemModel *>*list = self.dataManager.dimensionResult.data;
   
    if (indexPath.row < list.count) {
        TCDimensionSearchResultItemModel *item = list[indexPath.row];
        TCTestListTableViewCell *_cell = (TCTestListTableViewCell *)cell;
        [_cell setTitleText:item.dimensionName participantsCount:item.useCount.intValue iconImageURL:[NSURL URLWithString:item.image] alreadyPurchase:item.isOwn.boolValue presentPrice:item.priceYuan originPrice:item.originPriceYuan];
        if (item.isOwn.boolValue) {
            [_cell setCompleted:item.status.boolValue];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray <TCDimensionSearchResultItemModel *>*list = self.dataManager.dimensionResult.data;

    if (indexPath.row < list.count) {
        TCDimensionSearchResultItemModel *item = list[indexPath.row];
        TCTestDetailViewController *detailViewController = [[TCTestDetailViewController alloc] initWithDimensionId:item.dimensionId];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}

@end
