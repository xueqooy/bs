//
//  FEOccupationLibViewController.m
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEOccupationLibViewController.h"
#import "OccupationDetailsViewController.h"
#import "FEIndustryViewController.h"
#import "FEProfessionViewController.h"
#import "OccupationTableViewCell.h"
#import "FESearchBar.h"
#import "STSegmentView.h"

#import "FEOccupationDataManager.h"
@interface FEOccupationLibViewController () <STSegmentViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) FESearchBar *searchBar;
@property (nonatomic, weak) STSegmentView *segmentView;
@property (nonatomic, weak) UITableView *searchResultTableView;


@property (nonatomic, strong) FEIndustryViewController *industryVC;
@property (nonatomic, strong) FEProfessionViewController *professionVC;

@property (nonatomic, weak) FEOccupationDataManager *dataManager;

@property (nonatomic, assign) NSInteger currentVCIndex;
@property (nonatomic, assign) BOOL searching;
@end

@implementation FEOccupationLibViewController

- (void)loadView {
    [super loadView];
    
    [self setBarButtonItem];
    
    STSegmentView *segmentView = [[STSegmentView alloc] init];
    _segmentView = segmentView;
    [self.view addSubview:_segmentView];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(0.5);
        make.height.mas_equalTo(50);
    }];
    [_segmentView layoutIfNeeded];
    _segmentView.titleArray = @[@"行业分类",@"职业分类"];
    _segmentView.titleSpacing = 20;
    _segmentView.labelFont = [UIFont boldSystemFontOfSize:16];
    _segmentView.bottomLabelTextColor = UIColor.fe_titleTextColorLighten;
    _segmentView.topLabelTextColor = UIColor.fe_textColorHighlighted;
    _segmentView.selectedBackgroundColor = [UIColor whiteColor];
    _segmentView.selectedBgViewCornerRadius = 20;
    _segmentView.sliderHeight = 1;
    _segmentView.sliderColor = UIColor.fe_textColorHighlighted;
    _segmentView.sliderTopMargin = 0;
    _segmentView.duration = 0.25;
    _segmentView.backgroundColor = UIColor.fe_contentBackgroundColor;
    
    if (_areaID || _areaName) {
        [_segmentView setButtonSelected:1];
    }
    
    UITableView *searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  0.5, mScreenWidth, mScreenHeight - mBottomSafeHeight) style:UITableViewStylePlain];
    _searchResultTableView = searchResultTableView;
    _searchResultTableView.rowHeight = STWidth(60);

    _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:searchResultTableView];
    _searchResultTableView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataManager = [FEOccupationDataManager sharedManager];
    
    _segmentView.delegate = self;
    _searchBar.delegate = self;
    _searchResultTableView.delegate = self;
    _searchResultTableView.dataSource = self;
    
    
    [_industryVC removeFromParentViewController];
    [_professionVC removeFromParentViewController];
    [_industryVC.view removeFromSuperview];
    [_professionVC.view removeFromSuperview];
    
    _industryVC = [FEIndustryViewController new];
    _professionVC = [FEProfessionViewController new];
    [self addChildViewController:_industryVC];
    [self addChildViewController:_professionVC];
    
    if (_areaID || _areaName) {
        _currentVCIndex = 1;
        [self.view addSubview:_professionVC.view];
        
        _industryVC.view.frame = CGRectMake(-mScreenWidth,  50.5, mScreenWidth, mScreenHeight - mBottomSafeHeight - 50.5 - mNavBarAndStatusBarHeight);
        _professionVC.view.frame = CGRectMake(0,  50.5, mScreenWidth, mScreenHeight - mBottomSafeHeight - 50.5);
        
        //展开查询的目标项
        [_professionVC expandRowWithAreaID:_areaID areaName:_areaName];
    } else {
        _currentVCIndex = 0;
        [self.view addSubview:_industryVC.view];
        
        _industryVC.view.frame = CGRectMake(0,  50.5, mScreenWidth, mScreenHeight - mBottomSafeHeight - 50.5);
        _professionVC.view.frame = CGRectMake(mScreenWidth,  50.5, mScreenWidth, mScreenHeight - mBottomSafeHeight - mNavBarAndStatusBarHeight - 50.5);
    }
    

    
}

- (void)dealloc {
    _segmentView.delegate = nil;
    _searchBar.delegate = nil;
    _searchResultTableView.delegate = nil;
    _searchResultTableView.dataSource = nil;
}

- (void)setBarButtonItem {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, STWidth(300), 32)];
    //创建searchBar
    FESearchBar *searchBar = [[FESearchBar alloc] initWithFrame:CGRectMake(0, 0, STWidth(270), 32)];
    searchBar.placeholder = @"搜行业/职业";
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    self.navigationItem.titleView = titleView;
    
    _searchBar = searchBar;
    
    UIImageView *searchImageView = UIImageView.new;
    searchImageView.frame = CGRectMake(0, 0, 22, 22);
    searchImageView.image = [UIImage imageNamed:@"search_gray"];
    UIView *rightView = UIView.new;
    rightView.frame = CGRectMake(0, 0, 22, 22);
    [rightView addSubview:searchImageView];
    @weakObj(self);
    [rightView addTapGestureWithBlock:^{
        [selfweak startSearching];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];

}

#pragma mark - STSegmentViewDelegate
- (void)buttonClick:(NSInteger)index {
    if (_currentVCIndex != index) {
        _currentVCIndex = index;
        
        if (_currentVCIndex == 1) {
            [self transitionFromViewController:_industryVC toViewController:_professionVC duration:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _segmentView.userInteractionEnabled = NO;
                _industryVC.view.transform = CGAffineTransformTranslate(_industryVC.view.transform , -mScreenWidth, 0);
                _professionVC.view.transform = CGAffineTransformTranslate(_professionVC.view.transform , -mScreenWidth, 0);
            } completion:^(BOOL finished) {
                [_industryVC.view removeFromSuperview];
                _segmentView.userInteractionEnabled = YES;

            }];
        } else {
            [self transitionFromViewController:_professionVC toViewController:_industryVC duration:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _segmentView.userInteractionEnabled = NO;

                _industryVC.view.transform = CGAffineTransformTranslate(_industryVC.view.transform , mScreenWidth, 0);
                _professionVC.view.transform = CGAffineTransformTranslate(_professionVC.view.transform , mScreenWidth, 0);
            } completion:^(BOOL finished) {
                _segmentView.userInteractionEnabled = YES;

                [_professionVC.view removeFromSuperview];
            }];
        }
        
      
    }
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([searchBar.text isEqualToString:@""]) {
        return;
    }
    [self startSearching];
    _searchResultTableView.hidden = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if([searchText isEqualToString:@""]) {
        [self hideEmptyView];
        self.searchResultTableView.hidden = YES;
    }
    
}

- (void)startSearching {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    @weakObj(self);
    [_dataManager searchWithKeyName:self.searchBar.text andSuccess:^(BOOL isEmpty) {
        @strongObj(self);
        if (isEmpty) {
            [self showEmptyViewInView:self.view type:FEErrorType_NoSeek];

        } else {
            [self hideEmptyView];
            self.searchResultTableView.hidden = NO;
            [self.view bringSubviewToFront:self.searchResultTableView];
        }
        [self.searchResultTableView reloadData];

    } ifFailure:^{
        @strongObj(self);
        [self showEmptyViewForNoNetInView:self.view refreshHandler:^{
            [selfweak startSearching];
        }];
    }];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataManager.searchData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OccupationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OccupationTableViewCell"];
    if (cell == nil) {
        cell = [[OccupationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OccupationTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ProfessionalOccupationsModel *model = _dataManager.searchData[indexPath.row];
    [cell updateModel:model isLastRow:(indexPath.row == _dataManager.searchData.count - 1)? YES : NO ];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfessionalOccupationsModel *model = _dataManager.searchData[indexPath.row];
    
    OccupationDetailsViewController *vc = [[OccupationDetailsViewController alloc] init];
    vc.occupationId = [NSString stringWithFormat:@"%@", model.occupationId];
    
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
