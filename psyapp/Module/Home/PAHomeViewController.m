//
//  PAHomeViewController.m
//  psyapp
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "PAHomeViewController.h"
#import "PAMineViewController.h"
#import "PATestListViewController.h"
#import "TCTestListViewController.h"
#import "TCSearchMainViewController.h"
#import "TCDeviceLoginInfoPerfectionViewController.h"

#import "UIImage+Category.h"
#import "TCImageHeaderScrollingAnimator.h"
#import "PAHomeGridViewCell.h"

#import "PATestCategoryManager.h"
@interface PAHomeViewController () <UIScrollViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) QMUIButton *topLeftButton;
@property (nonatomic, strong) QMUIButton *topRightButton;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) QMUIGridView *gridView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *errorView;

@end

@implementation PAHomeViewController {
    NSArray *_categoryTitles;
    NSArray *_categoryImageNames;
    NSArray *_categoryTintColors;
    
    BOOL _dataLoaded;
}
- (void)loadView {
    [super loadView];
    CGFloat headerHeight = STWidth(162) + mStatusBarHeight;
    UIView *topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, headerHeight)];
    topBackgroundView.backgroundColor = UIColor.fe_mainColor;
    [self.view addSubview:topBackgroundView];
    UIView *bottomBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight, mScreenHeight,  mScreenHeight - headerHeight)];
    bottomBackgroundView.backgroundColor = UIColor.fe_contentBackgroundColor;
    [self.view addSubview:bottomBackgroundView];
    
    _scrollView = UIScrollView.new;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    @weakObj(self);
    _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfweak loadDataWithCompletion:nil];
    }];

    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_scrollView.mj_header;
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"数据加载中···" forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = UIColor.whiteColor;
    header.backgroundColor = UIColor.clearColor;
    header.lastUpdatedTimeLabel.hidden = YES;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    _headerView = UIImageView.new;
    _headerView.frame = CGRectMake(0, 0, mScreenWidth, headerHeight);
    _headerView.userInteractionEnabled = YES;
    UIImage *gradientImage = [UIImage gradientImageWithWithColors:@[UIColor.fe_mainColor, mHexColor(@"#9EBAFF")] locations:@[@0, @1] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) size:CGSizeMake(mScreenWidth, headerHeight)];
    _headerView.image = gradientImage;
    [_scrollView addSubview:_headerView];
    [_scrollView sendSubviewToBack:_headerView];
    
    UILabel *searchLabel = [UILabel.alloc qmui_initWithFont:STFontBold(24) textColor:UIColor.whiteColor];
    searchLabel.text = @"搜索测评";
    [_headerView addSubview:searchLabel];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(STWidth(15));
        make.bottom.offset(STWidth(-80));
    }];
    
    _searchBar = UISearchBar.new;
    [_searchBar setImage:[UIImage imageNamed:@"share_clear"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    _searchBar.layer.cornerRadius = STWidth(4);
    _searchBar.clipsToBounds = YES;
    _searchBar.qmui_textField.backgroundColor = UIColor.clearColor;
    _searchBar.qmui_textColor = UIColor.fe_mainTextColor;
    _searchBar.qmui_placeholderColor = UIColor.fe_placeholderColor;
    _searchBar.placeholder = @"输入标题或内容";
    
    _searchBar.qmui_font = STFontRegular(12);
    _searchBar.backgroundImage = [UIImage qmui_imageWithColor:UIColor.fe_contentBackgroundColor];
    [_headerView addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(345, 40));
        make.centerX.offset(0);
        make.bottom.offset(-STWidth(30));
    }];
    
    _topLeftButton = QMUIButton.new;
    [_topLeftButton setImage:[UIImage imageNamed:@"home_test"] forState:UIControlStateNormal];
    [_topLeftButton setTitleColor:UIColor.fe_mainColor forState:UIControlStateNormal];
    [_topLeftButton addTarget:self action:@selector(actionForTopButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topLeftButton];
    [_topLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.top.offset(mStatusBarHeight + 7);
        make.left.offset(STWidth(15));
    }];
    
    _topRightButton = QMUIButton.new;
    [_topRightButton setImage:[UIImage imageNamed:@"home_mine"] forState:UIControlStateNormal];
    [_topRightButton setTitleColor:UIColor.fe_mainColor forState:UIControlStateNormal];
    [_topRightButton addTarget:self action:@selector(actionForTopButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topRightButton];
    [_topRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.top.offset(mStatusBarHeight + 7);
        make.right.offset(-STWidth(15));
    }];
 
    
    UIView *gridViewBackgroundView = UIView.new;
    gridViewBackgroundView.backgroundColor = UIColor.fe_contentBackgroundColor;
    [_scrollView addSubview:gridViewBackgroundView];
    [gridViewBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerHeight);
        make.left.right.bottom.offset(0);
    }];
    _gridView = [[QMUIGridView alloc] initWithColumn:2 rowHeight:STWidth(125)];
    _gridView.separatorWidth = STWidth(15);
    _gridView.separatorColor = UIColor.clearColor;
    [gridViewBackgroundView addSubview:_gridView];
    [_gridView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.size.mas_equalTo(CGSizeMake(mScreenWidth - STWidth(30), STWidth(400)));
        make.edges.mas_equalTo(UIEdgeInsetsMake(STWidth(20), STWidth(15), STWidth(20), STWidth(15)));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self forcePefectInfoWhenDeviceloginIfNeeded];
    self.searchBar.delegate = self;
    @weakObj(self);
    [self.view addTapGestureWithBlock:^{
        [selfweak.searchBar resignFirstResponder];
    }];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initData];
    [self loadDataWithCompletion:nil];
    [self updateGridView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}

- (void)initData {
    _categoryTitles = @[@"学习能力", @"心理健康", @"自我认知", @" 家庭与学校", @"生涯规划"];
    _categoryImageNames = @[@"home_xxnl", @"home_xljk", @"home_zwrz", @"home_jtyxx", @"home_sygh"];
    _categoryTintColors = @[mHexColor(@"#FF5752"), mHexColor(@"#30DBCB"), mHexColor(@"#EF7E39"), mHexColor(@"#393BDE"), mHexColor(@"#368BDE")];
}

- (void)loadDataWithCompletion:(void(^)(BOOL success))completion {
    [PATestCategoryManager.sharedInstance loadCategoriesOnSucess:^{
        [self->_scrollView.mj_header endRefreshing];
        self->_dataLoaded = YES;
        if (completion) completion(YES);
    } failure:^{
        [self->_scrollView.mj_header endRefreshing];
        self->_dataLoaded = NO;
        if (completion) completion(NO);
    }];
}

- (void)updateGridView {
    for (int i = 0; i < _categoryTitles.count; i ++) {
        NSString *title = _categoryTitles[i];
        NSString *imageName = _categoryImageNames[i];
        PAHomeGridViewCell *cell = PAHomeGridViewCell.new;
        cell.title = title;
        cell.image = [UIImage imageNamed:imageName];
        cell.tintColor = _categoryTintColors[i];
        @weakObj(self);
        cell.onTouch = ^{
            [selfweak gotoListPageWithCategoryName:title];
        };
        [_gridView addSubview:cell];
    }
}

- (void)actionForTopButton:(UIButton *)sender {
    if (sender == _topRightButton) {
        PAMineViewController *mineViewController = PAMineViewController.new;
        [self.navigationController pushViewController:mineViewController animated:YES];
    } else {
        TCTestListViewController *ownedViewController = TCTestListViewController.new;
        ownedViewController.isOwnedList = YES;
        [self.navigationController pushViewController:ownedViewController animated:YES];
    }
}

- (void)forcePefectInfoWhenDeviceloginIfNeeded {
    if (UCManager.sharedInstance.didFormalAccountLogin == NO) {
        if (UCManager.sharedInstance.needPerfectInfoForDeviceAccount) {
            [TCDeviceLoginInfoPerfectionViewController showWithPresentedViewController:self onPerfectionSuccess:^{
            }];
            return;
        }
    }
}

- (void)gotoListPageWithCategoryName:(NSString *)categoryName  {
    @weakObj(self);
    void (^block)(void) = ^{
        if ([NSString isEmptyString:categoryName]) return;
           PATestListViewController *viewController = PATestListViewController.new;
           viewController.categoryName = categoryName;
           [selfweak.navigationController pushViewController:viewController animated:YES];
    };
    
    if (_dataLoaded == NO) {
        [self loadDataWithCompletion:^(BOOL success) {
            if (success) {
                block();
            } 
        }];
        return;
    }
    block();
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = _scrollView.contentOffset.y;
    if (contentOffsetY < 0) {
        _headerView.frame = CGRectMake(0, contentOffsetY, mScreenWidth, STWidth(162) + mStatusBarHeight - contentOffsetY);

    } else {
        _headerView.frame = CGRectMake(0, 0, mScreenWidth, STWidth(162) + mStatusBarHeight);
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([NSString isEmptyString:searchBar.text.qmui_trim]) {
        [QSToast toast:mKeyWindow message:@"搜索内容不能为空" offset:CGPointMake(0, - STWidth(50)) duration:1];
        return;
    };
    TCSearchMainViewController *searchViewController = TCSearchMainViewController.new;
    searchViewController.keyword = searchBar.text.qmui_trim;
    [self.navigationController pushViewController:searchViewController animated:YES];
}
@end
