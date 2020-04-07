//
//  TCMyOrderListViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCMyOrderListViewController.h"
#import "TCTestDetailViewController.h"

#import "TCMyOrderTableViewCell.h"

@interface TCMyOrderListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TCMyOrderListDataManager *dataManager;
@end

@implementation TCMyOrderListViewController
- (instancetype)initWithOrderType:(TCMyOrderType)type {
    self = [self init];
    self.type = type;
    self.dataManager = [TCMyOrderListDataManager.alloc initWithOrderType:self.type];
    return self;
}


- (void)loadView {
    [super loadView];
    self.view.backgroundColor = UIColor.fe_backgroundColor;
    _tableView = [UITableView new];
    _tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    @weakObj(self);
    [_tableView setFooterRefreshAction:^{
        [selfweak loadData];
    }];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self loadData];
}

- (void)loadData {
    @weakObj(self);
    [self.dataManager getOrderListOnSuccess:^{
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
        [self showEmptyViewInView:self.tableView type:FEErrorType_NoHistory];
    } else {
        [self hideEmptyView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.list.currentCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.type == TCMyOrderTypeEmoney? STWidth(80) : STWidth(100);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"TCMyOrderTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TCMyOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray <TCMyOrderRecordModel *>*list = self.dataManager.list.data;

    if (indexPath.row < list.count) {
        TCMyOrderRecordModel *item = list[indexPath.row];
        TCMyOrderTableViewCell *_cell = (TCMyOrderTableViewCell *)cell;
        if (self.type != TCMyOrderTypeEmoney) {
            TCProductOrderRecordModel *productItem = (TCProductOrderRecordModel *)item;
            [_cell setIconImageURLString:productItem.image name:productItem.name date:productItem.createTime price:productItem.priceYuan isEMoney:NO];
        } else {
            [_cell setIconImageURLString:@"" name:@"" date:item.createTime price:item.priceYuan isEMoney:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == TCMyOrderTypeEmoney) return;
    TCProductOrderRecordModel *orderRecord = (TCProductOrderRecordModel *)self.dataManager.list.data[indexPath.row];
    if ([NSString isEmptyString:orderRecord.itemId]) return;
    if (self.type == TCMyOrderTypeTest) {
        TCTestDetailViewController *dimensionDetailViewController = [[TCTestDetailViewController alloc] initWithDimensionId:orderRecord.itemId];
        [self.navigationController pushViewController:dimensionDetailViewController animated:YES];
    }
}

@end
