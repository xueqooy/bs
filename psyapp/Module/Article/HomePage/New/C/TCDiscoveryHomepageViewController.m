//
//  TCDiscoveryHomepageViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/26.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDiscoveryHomepageViewController.h"
#import "TCDiscoveryBannerViewController.h"
#import "TCDiscoveryArticleListViewController.h"
#import "TCDeviceLoginInfoPerfectionViewController.h"
#import "TCSearchMainViewController.h"

#import "TCNestedScrollingAnimator.h"

#import "TCDiscoveryHomepageDataManager.h"
/**
 负责业务上学段的选择 和 滚动的处理
 */

@interface TCDiscoveryHomepageViewController ()
@property (nonatomic, strong) TCNestedSimultaneousScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStackView;

@property (nonatomic, strong) TCNestedScrollingAnimator *nestedScrollingAnimator;

@property (nonatomic, strong) TCDiscoveryBannerViewController *bannerViewController;
@property (nonatomic, strong) TCDiscoveryArticleListViewController *articleListViewController;

@property (nonatomic, strong) TCDiscoveryHomepageDataManager *dataManager;
@end


@implementation TCDiscoveryHomepageViewController {
    CGFloat _verticalSpacing;
}

- (instancetype)init {
    self = [super init];
    _verticalSpacing = STWidth(20.f);
    return self;
}

- (void)loadView {
    [super loadView];
    
    _scrollView = TCNestedSimultaneousScrollView.new;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    @weakObj(self);
//    _scrollView.headerRefreshAction = ^{
//        [TCSystemFeedbackHelper impactLight];
//        [selfweak loadData];
//    };
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    _contentStackView = UIStackView.new;
    _contentStackView.axis = UILayoutConstraintAxisVertical;
    _contentStackView.spacing = _verticalSpacing;
    [_scrollView addSubview:_contentStackView];
    [_contentStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(mScreenWidth);
        make.edges.mas_equalTo(UIEdgeInsetsMake(_verticalSpacing, 0, 0, 0));
    }];
    
    [self initViewControllers];
    [self initNavigationBarItems];

    [_contentStackView addArrangedSubview:_bannerViewController.view];
    [_contentStackView addArrangedSubview:_articleListViewController.view];

    [_bannerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_bannerViewController.height);
    }];
   
    [_articleListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_scrollView.mas_height).offset(_articleListViewController.height);
    }];
    
    _nestedScrollingAnimator = TCNestedScrollingAnimator.new;
    _nestedScrollingAnimator.offsetYToEnableSecondaryScroll = self.currentOffsetYToEnableSecondaryScroll;
    _nestedScrollingAnimator.primaryScrollView = _scrollView;
    //当容器scrollView可以滚动时，设置所有嵌套的scroll的contentOffset为zero
    _nestedScrollingAnimator.primaryScrollableBlock = ^{
        [selfweak.articleListViewController resetAllScrollViewOffset];
    };
    //嵌套的scrollView切换时，重新赋值
    _articleListViewController.verticalScrollViewBlock = ^(UIScrollView * _Nonnull scrollView) {
       selfweak.nestedScrollingAnimator.secondaryScrollView = scrollView;
    };
    //处理交叉方向上的scrollView滚动互斥
    _scrollView.mutexViews = @[_bannerViewController.bannerScrollView];
    _articleListViewController.horizontalSrollViewBlock = ^(UIScrollView * _Nonnull contentScrollView, UIScrollView *_Nonnull segmentScrollView) {
        selfweak.scrollView.mutexViews =@[selfweak.bannerViewController.bannerScrollView, contentScrollView, segmentScrollView];
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.fe_contentBackgroundColor;
    _dataManager = TCDiscoveryHomepageDataManager.new;
    if (NO == [self performDeviceAccountInfoIfNeeded]) {
        [self loadData];
    }
}



- (void)startDisplayBannerAd{
    [_bannerViewController setNeedsBannerAdDisplay];
    [_bannerViewController displayBannerAdIfNeeded];
}


- (CGFloat)currentOffsetYToEnableSecondaryScroll {
    return _bannerViewController.height  + _verticalSpacing * 2 + _articleListViewController.height;
}



- (BOOL)performDeviceAccountInfoIfNeeded {
    //设备登录，信息未完善的情况下，完善信息
    if (UCManager.sharedInstance.didFormalAccountLogin == NO) {
        if (UCManager.sharedInstance.needPerfectInfoForDeviceAccount) {
            @weakObj(self);
            [TCDeviceLoginInfoPerfectionViewController showWithPresentedViewController:self onPerfectionSuccess:^{
                [selfweak loadData];
            }];
            return YES;
        }
    }
    return NO;
}

- (void)loadData {
    [_articleListViewController loadData];
    [_bannerViewController loadData];
}

- (void)initViewControllers {
    _bannerViewController = TCDiscoveryBannerViewController.new;
    _articleListViewController = TCDiscoveryArticleListViewController.new;
    
    [self addChildViewController:_bannerViewController];
    [self addChildViewController:_articleListViewController];
}

- (void)initNavigationBarItems {
    UIView *rightView = UIView.new;
    rightView.frame = CGRectMake(0, 0, 22, 22);
    QMUIButton *searchButton = QMUIButton.new;
    searchButton.frame = CGRectMake(0, 0, 22, 22);
    [searchButton setImage:[UIImage imageNamed:@"search_black"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(gotoSearchPage) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:searchButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

- (void)gotoSearchPage {
    [TCSearchMainViewController.new present];
}


@end
