//
//  BSOccupationSearchViewController.m
//  psyapp
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "BSOccupationSearchViewController.h"
#import "OccupationTableViewCell.h"
#import "OccupationDetailsViewController.h"
#import "FEOccupationDataManager.h"
@interface BSOccupationSearchViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) FEOccupationDataManager *manager;

@end

@implementation BSOccupationSearchViewController
@synthesize filter = _filter;
@synthesize countDidChange = _countDidChange;

- (instancetype)init {
    self = [super init];
    self.manager = FEOccupationDataManager.sharedManager;
    self.manager.searchData = nil;
    return self;
}

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
    [_manager searchWithKeyName:self.filter andSuccess:^(BOOL isEmpty) {
        @strongObj(self);
        self.tableView.alreadyLoadAllData = YES;
        self.countDidChange(self.manager.searchData.count);
        [self.tableView reloadData];
        [self showEmptyViewIfEmpty];

    } ifFailure:^{
        @strongObj(self);

       [self showNetErrorViewIfNeeded];

    }];
   
}

- (void)startSearchWithFilter:(NSString *)filter {
    self.filter = filter;
    [self loadData];
}

- (void)showNetErrorViewIfNeeded {

    @weakObj(self);
    [self showEmptyViewForNoNetInView:selfweak.view refreshHandler:^{
        [selfweak loadData];
    }];

}

- (void)showEmptyViewIfEmpty {
    if (_manager.searchData.count == 0) {
        [self showEmptyViewInView:self.view type:FEErrorType_NoSeek];
    } else {
        [self hideEmptyView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _manager.searchData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return STWidth(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OccupationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OccupationTableViewCell"];

    if (cell == nil) {
        OccupationTableViewCell *_cell = [[OccupationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OccupationTableViewCell"];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = _cell;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    OccupationTableViewCell *_cell = ((OccupationTableViewCell *)cell);
    ProfessionalOccupationsModel *model = _manager.searchData[indexPath.row];
    [_cell updateModel:model isLastRow:(indexPath.row == _manager.searchData.count - 1)? YES : NO ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfessionalOccupationsModel *model = _manager.searchData[indexPath.row];
    
    OccupationDetailsViewController *vc = [[OccupationDetailsViewController alloc] init];
    vc.occupationId = [NSString stringWithFormat:@"%@", model.occupationId];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
