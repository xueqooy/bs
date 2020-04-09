//
//  BSMajorSearchViewController.m
//  psyapp
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "BSMajorSearchViewController.h"
#import "ProfessionalDetailsViewController.h"
#import "OccupationTableViewCell.h"
@interface BSMajorSearchViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BSMajorSearchViewController
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
    [self.dataManager getSearchResultByFilter:self.filter type:BSSearchTypeMajor onSuccess:^{
        selfweak.tableView.alreadyLoadAllData = YES;

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
    if (self.dataManager.majorResult.count == 0) {
        [self showEmptyViewInView:self.view type:FEErrorType_NoSeek];
    } else {
        [self hideEmptyView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.majorResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return STWidth(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"OccupationTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        OccupationTableViewCell *_cell = [[OccupationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = _cell;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    OccupationTableViewCell *_cell = ((OccupationTableViewCell *)cell);
    [_cell updateWithName:self.dataManager.majorResult[indexPath.row].majorName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfessionalCategoryModel *model = self.dataManager.majorResult[indexPath.row];

    ProfessionalDetailsViewController *vc = [ProfessionalDetailsViewController suspendTopPausePageVC] ;
    vc.majorCode = model.majorCode;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
