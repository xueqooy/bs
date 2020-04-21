//
//  BSUniversitySearchViewController.m
//  psyapp
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "BSUniversitySearchViewController.h"
#import "UniversityDetailsViewController.h"

#import "UniversityTableViewCell.h"

@interface BSUniversitySearchViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BSUniversitySearchViewController
@synthesize dataManager = _dataManager;
@synthesize filter = _filter;
@synthesize countDidChange = _countDidChange;
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
    [self.dataManager getSearchResultByFilter:self.filter type:BSSearchTypeUniversity onSuccess:^{
        selfweak.tableView.alreadyLoadAllData = YES;
        self.countDidChange(self.dataManager.universityResult.count);

        [selfweak.tableView reloadData];
        [selfweak showEmptyViewIfEmpty];
    } failure:^{
        [selfweak showNetErrorViewIfNeeded];
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
    if (self.dataManager.universityResult.count == 0) {
        [self showEmptyViewInView:self.view type:FEErrorType_NoSeek];
    } else {
        [self hideEmptyView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.universityResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return STWidth(80);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"UniversityTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UniversityTableViewCell *_cell = [[UniversityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = _cell;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UniversityTableViewCell *_cell = ((UniversityTableViewCell *)cell);
    [_cell updateModel:self.dataManager.universityResult[indexPath.row] rankFilter:@"" isLastRow:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UniversityModel *model = self.dataManager.universityResult[indexPath.row];

    UniversityDetailsViewController *vc = [UniversityDetailsViewController suspendTopPausePageVC];
    vc.universityModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end

