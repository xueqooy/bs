//
//  PALibViewController.m
//  psyapp
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "PALibViewController.h"
#import "TCSearchMainViewController.h"
#import "UniversityListViewController.h"
#import "ProfessionalViewController.h"
#import "FEOccupationLibViewController.h"
#import "TCLibSearchMainViewController.h"
#import "FEMyFollowsViewController.h"

#import "TCImageHeaderScrollingAnimator.h"
#import "PAHomeGridViewCell.h"
#import "UIImage+Category.h"
#import "TCSearchAppearanceButton.h"

#import "PATestCategoryManager.h"
@interface PALibViewController () <UIScrollViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) QMUIButton *topLeftButton;
@property (nonatomic, strong) QMUIButton *topRightButton;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) TCSearchAppearanceButton *searchButton;
@property (nonatomic, strong) QMUIGridView *gridView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *errorView;

@end

@implementation PALibViewController {
    NSArray *_categoryTitles;
    NSArray *_categoryImageNames;
    NSArray *_categoryTintColors;
    
    BOOL _dataLoaded;
}

- (instancetype)init {
    self = [super init];
    [self initData];
    return self;
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
    searchLabel.text = @"搜索学校/专业/职业";
    [_headerView addSubview:searchLabel];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(STWidth(15));
        make.bottom.offset(STWidth(-80));
    }];
    
    _searchButton = TCSearchAppearanceButton.new;
    _searchButton.frame = CGRectZero;
    _searchButton.layer.cornerRadius = STWidth(20);
    [_searchButton addTarget:self action:@selector(gotoSeachPage) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_searchButton];
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
    CGFloat itemHeight = STWidth(80);
    CGFloat verticalSpacing = STWidth(15);
    _gridView = [[QMUIGridView alloc] initWithColumn:1 rowHeight:itemHeight];
    _gridView.separatorWidth = verticalSpacing;
    _gridView.separatorColor = UIColor.clearColor;
    [gridViewBackgroundView addSubview:_gridView];
    [_gridView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.size.mas_equalTo(CGSizeMake(mScreenWidth - STWidth(30), itemHeight * _categoryTitles.count + verticalSpacing * (_categoryTitles.count - 1)));
        make.edges.mas_equalTo(UIEdgeInsetsMake(STWidth(20), STWidth(15), STWidth(20), STWidth(15)));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self loadDataWithCompletion:nil];
    [self updateGridView];
}


- (void)initData {
    _categoryTitles = @[@"学校库", @"专业库", @"职业库", @"选科助手"];
    _categoryImageNames = @[@"home_xxnl", @"home_xljk", @"home_zwrz", @"home_jtyxx"];
    _categoryTintColors = @[mHexColor(@"#FF5752"), mHexColor(@"#30DBCB"), mHexColor(@"#EF7E39"), mHexColor(@"#393BDE")];
}

- (void)loadDataWithCompletion:(void(^)(BOOL success))completion {
    
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
        FEMyFollowsViewController *followsViewController =  [[FEMyFollowsViewController alloc] initWithNibName:@"FEMyFollowsViewController" bundle:nil];
        [self.navigationController pushViewController:followsViewController animated:YES];
    }
}



- (void)gotoListPageWithCategoryName:(NSString *)categoryName  {
    if ([categoryName isEqualToString:_categoryTitles.firstObject]) {
       UniversityListViewController *vc = UniversityListViewController.new;
       [self.navigationController pushViewController:vc animated:YES];
   } else if ([categoryName isEqualToString:_categoryTitles[1]]) {
       ProfessionalViewController *vc = ProfessionalViewController.new;
       [self.navigationController pushViewController:vc animated:YES];
   } else if ([categoryName isEqualToString:_categoryTitles[2]]) {
       FEOccupationLibViewController *vc = FEOccupationLibViewController.new;
       [self.navigationController pushViewController:vc animated:YES];
   }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = _scrollView.contentOffset.y;
    if (contentOffsetY < 0) {
        _headerView.frame = CGRectMake(0, contentOffsetY, mScreenWidth, STWidth(162) + mStatusBarHeight - contentOffsetY);

    } else {
        _headerView.frame = CGRectMake(0, 0, mScreenWidth, STWidth(162) + mStatusBarHeight);
    }
}


- (void)gotoSeachPage{
    TCLibSearchMainViewController *searchViewController = TCLibSearchMainViewController.new;
    [searchViewController present];
}
@end

