//
//  TCSearchMainViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCSearchMainViewController.h"
#import "TCArticleSearchViewController.h"

#import "FESearchBar.h"
#import "FESearchRecordView.h"

#import "TCDiscoverySearchDataManager.h"

@interface TCSearchMainViewController () <UISearchBarDelegate>
@property (nonatomic, strong) TCArticleSearchViewController *articleViewController;

@property (nonatomic, strong) FESearchBar *searchBar;
@property(nonatomic,strong) FESearchRecordView *searchRecordView;

@property (nonatomic, copy, readonly) NSString *searchFilter;
@property (nonatomic, strong) TCDiscoverySearchDataManager *dataManager;
@end

@implementation TCSearchMainViewController

- (void)present {
    FENavigationViewController *searchNavigationController = [[FENavigationViewController alloc] initWithRootViewController:self];
    searchNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [QMUIHelper.visibleViewController presentViewController:searchNavigationController animated:NO completion:nil];
}

- (instancetype)init {
    self = [super init];
    _defaultSelectedIndex = 0;
    return self;
}

- (void)loadView {
    [super loadView];
    _articleViewController = [[TCArticleSearchViewController alloc] init];
    [self addChildViewController:_articleViewController];
    [self.view addSubview:_articleViewController.view];
    [_articleViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    _searchRecordView = [[FESearchRecordView alloc] initWithKey:@"article_search_record_key"];
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
    _articleViewController.dataManager = self.dataManager;

    [self initNavigationBar];
  
    
    [self loadPopularSearchData];
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
    searchImageView.image = [UIImage imageNamed:@"search_white"];
    UIView *leftView = UIView.new;
    leftView.frame = CGRectMake(0, 0, 22, 22);
    [leftView addSubview:searchImageView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.rightBarButtonItem.tintColor = UIColor.fe_contentBackgroundColor;
}


- (void)dissmissController {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)loadPopularSearchData {
    @weakObj(self);
    AVQuery *query = [AVQuery queryWithClassName:@"PopularSearch"];
    [query whereKey:@"field" equalTo:@"article"];
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
    [QSLoadingView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [QSLoadingView dismiss];
    });
    [self.searchRecordView saveSearchRecord:filter];
    [_articleViewController startSearchWithFilter:filter];
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

#pragma mark - 友盟统计

@end
