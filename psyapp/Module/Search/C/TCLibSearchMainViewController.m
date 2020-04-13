//
//  TCSearchMainViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCLibSearchMainViewController.h"
#import "BSUniversitySearchViewController.h"
#import "BSOccupationSearchViewController.h"
#import "BSMajorSearchViewController.h"

#import "FESearchBar.h"
#import "FESearchRecordView.h"
#import "SegmentView.h"

#import "TCDiscoverySearchDataManager.h"

@interface TCLibSearchMainViewController () <UISearchBarDelegate>

@property (nonatomic, strong) BSUniversitySearchViewController *universitySearchViewController;
@property (nonatomic, strong) BSOccupationSearchViewController *occupationSearchViewController;
@property (nonatomic, strong) BSMajorSearchViewController *majorSearchViewController;
@property (nonatomic, strong) FESearchBar *searchBar;
@property (nonatomic, strong) SegmentView *segmentView;

@property(nonatomic,strong) FESearchRecordView *searchRecordView;

@property (nonatomic, copy, readonly) NSString *searchFilter;
@property (nonatomic, strong) TCDiscoverySearchDataManager *dataManager;
@end

@implementation TCLibSearchMainViewController

- (void)present {
    FENavigationViewController *searchNavigationController = [[FENavigationViewController alloc] initWithRootViewController:self];
    searchNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [QMUIHelper.visibleViewController presentViewController:searchNavigationController animated:NO completion:nil];
}

- (void)loadView {
    [super loadView];
    _segmentView = [SegmentView new];
    _segmentView.header.itemWidth = mScreenWidth / 3;
    _segmentView.header.itemSpacing = 0;
    _segmentView.frame = self.view.bounds;
    [self.view addSubview:_segmentView];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    _searchRecordView = [[FESearchRecordView alloc] initWithKey:@"lib_search_record_key"];
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
    [self initViewControllers];

    if (![NSString isEmptyString:_keyword]) {
        _searchBar.text = _keyword;
        [self startSearch];
    }
    
    [self loadPopularSearchData];
}

- (void)loadPopularSearchData {
    @weakObj(self);
    AVQuery *query = [AVQuery queryWithClassName:@"PopularSearch"];
    [query whereKey:@"field" equalTo:@"lib"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSMutableArray *wordsArray = @[].mutableCopy;
        for (AVObject *object in objects) {
            NSString *words = [object objectForKey:@"words"];
            if ([NSString isEmptyString:words] == NO) {
                [wordsArray addObject:words];
            }
        }
        selfweak.searchRecordView.popularSearchTextArray = wordsArray;
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}

- (void)initNavigationBar {
    UIView *titleView = UIView.new;
    titleView.frame = CGRectMake(0, 0, STWidth(300), 32);
    _searchBar = [[FESearchBar alloc] initWithFrame:CGRectMake(0, 0, STWidth(270), 32)];
    _searchBar.delegate = self;
    [titleView addSubview:_searchBar];
    self.navigationItem.titleView = titleView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dissmissController)];
    
    UIImageView *searchImageView = UIImageView.new;
    searchImageView.frame = CGRectMake(0, 0, 22, 22);
    searchImageView.image = [UIImage imageNamed:@"search_gray"];
    UIView *leftView = UIView.new;
    leftView.frame = CGRectMake(0, 0, 22, 22);
    [leftView addSubview:searchImageView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem.tintColor = UIColor.fe_placeholderColor;
    self.navigationItem.rightBarButtonItem.tintColor = UIColor.fe_mainTextColor;
}

- (void)initViewControllers {
    _universitySearchViewController = BSUniversitySearchViewController.new;
    _universitySearchViewController.dataManager = self.dataManager;
  
    _majorSearchViewController = BSMajorSearchViewController.new;
    _majorSearchViewController.dataManager = self.dataManager;
    
    _occupationSearchViewController = BSOccupationSearchViewController.new;
    
    [_segmentView setViewControllers:@[_universitySearchViewController, _majorSearchViewController, _occupationSearchViewController] parentViewController:self titles:@[@"学校", @"专业" , @"职业"]];
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
    [_universitySearchViewController startSearchWithFilter:filter];
    [_majorSearchViewController startSearchWithFilter:filter];
    [_occupationSearchViewController startSearchWithFilter:filter];
}

- (void)dissmissController {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:NO completion:^{

    }];
}

#pragma mark - searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self startSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText isEqualToString:@""]) {
        self.searchRecordView.hidden = NO;
    }
}
@end
