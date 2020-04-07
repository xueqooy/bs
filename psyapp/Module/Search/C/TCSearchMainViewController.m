//
//  TCSearchMainViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCSearchMainViewController.h"
#import "TCTestSearchViewController.h"

#import "FESearchBar.h"
#import "FESearchRecordView.h"

#import "TCDiscoverySearchDataManager.h"

@interface TCSearchMainViewController () <UISearchBarDelegate>

@property (nonatomic, strong) TCTestSearchViewController *testViewController;

@property (nonatomic, strong) FESearchBar *searchBar;
@property(nonatomic,strong) FESearchRecordView *searchRecordView;

@property (nonatomic, copy, readonly) NSString *searchFilter;
@property (nonatomic, strong) TCDiscoverySearchDataManager *dataManager;
@end

@implementation TCSearchMainViewController

- (void)loadView {
    [super loadView];
    _testViewController = TCTestSearchViewController.new;
    [self addChildViewController:_testViewController];
    _testViewController.view.frame = self.view.bounds;
    [self.view addSubview:_testViewController.view];
    [_testViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    _searchRecordView = [[FESearchRecordView alloc] init];
    _searchRecordView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight - mNavBarAndStatusBarHeight);
    [self.view addSubview:_searchRecordView];
    
    @weakObj(self);
    _searchRecordView.selectCompletionHandler = ^(NSString * _Nonnull seekString) {
        selfweak.searchBar.text = seekString;
        [selfweak startSearch];
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarShadowHidden = NO;
    self.dataManager = TCDiscoverySearchDataManager.new;
   
    [self initNavigationBar];
  
    _testViewController.dataManager = self.dataManager;

    if (![NSString isEmptyString:_keyword]) {
        _searchBar.text = _keyword;
        [self startSearch];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}

- (void)initNavigationBar {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, 40)];
    _searchBar = [[FESearchBar alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(titleView.frame) - 30, 30)];
    _searchBar.delegate = self;
    _searchBar.qmui_placeholderColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
    _searchBar.qmui_textColor = UIColor.whiteColor;
    [titleView addSubview:_searchBar];
    self.navigationItem.titleView = titleView;
    
    UIView *rightView = UIView.new;
    rightView.frame = CGRectMake(0, 0, 22, 22);
    UIButton *button = UIButton.new;
    [button setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    button.frame = rightView.bounds;
    [button addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:button];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    });
}

- (NSString *)searchFilter {
    return [_searchBar.text qmui_trim];
}

- (void)startSearch {
    [self.searchBar resignFirstResponder];

    
    NSString *filter = self.searchFilter;
    if([filter isEqualToString:@""]){
        [QSToast toastWithMessage:@"搜索内容不能为空"];
        return;
    }
    if(filter.length<2){
        [QSToast toastWithMessage:@"搜索字符不能少于两位"];
        return;
    }
    
    self.searchRecordView.hidden = YES;
    [self.searchRecordView saveSearchRecord:filter];
    [_testViewController startSearchWithFilter:filter];

}



#pragma mark - searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self startSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText isEqualToString:@""]) {
        [self.dataManager.dimensionResult resetData];
        self.searchRecordView.hidden = NO;
    }
}
@end
