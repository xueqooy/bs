//
//  TCDiscoveryArticleListViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/28.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDiscoveryArticleListViewController.h"
#import "ArticleTagViewController.h"

#import "TCNestedScrollingAnimator.h"
#import "SegmentView.h"
#import "TCTitleHeaderView.h"

#import "TCDicoveryArticleListDataManager.h"
@interface TCDiscoveryArticleListViewController ()
@property (nonatomic, strong) TCDicoveryArticleListDataManager *dataManager;

@property (nonatomic, strong) TCTitleHeaderView *titleHeaderView;
@property (nonatomic, strong) SegmentView *segmentView;
@end

CGFloat const kSegmentHeight = 50.f;
@implementation TCDiscoveryArticleListViewController {
    NSMutableArray *_childViewControllers;
}
- (instancetype)init {
    self = [super init];
    _dataManager = TCDicoveryArticleListDataManager.new;
    return self;
}
- (CGFloat)height {
    return 0;
}

- (void)loadView {
    [super loadView];

    
    _segmentView = SegmentView.new;
    _segmentView.header.bottomSeparatorHeight = 0;
    [self.view addSubview:_segmentView];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.fe_contentBackgroundColor;
    @weakObj(self);
    _segmentView.didSwitchToViewController = ^(UIViewController *viewController) {
        if (selfweak.verticalScrollViewBlock) {
            selfweak.verticalScrollViewBlock(selfweak.currentScrollView);
        }
    };
}


- (void)loadData {
    @weakObj(self);
    [self.dataManager getArticleCategoryOnSuccess:^{
        [selfweak dataDidLoad];
    } failure:^{
        [selfweak showNetErrorViewIfNeeded];
    }];
}

- (void)dataDidLoad {
    _childViewControllers = @[].mutableCopy;
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataManager.categories.count; i++) {
        TCCategroyModel *model = self.dataManager.categories[i];
        ArticleTagViewController *vc = [[ArticleTagViewController alloc]init];
        vc.categroyModel = model;
        [_childViewControllers addObject:vc];
        [titleArray addObject:model.name];
    }
    [_segmentView setViewControllers:_childViewControllers parentViewController:self titles:titleArray];
    if (_horizontalSrollViewBlock) {
        _horizontalSrollViewBlock(_segmentView.scrollView, _segmentView.headerScrollView);
    }
    
    if (_verticalScrollViewBlock) {
        _verticalScrollViewBlock(self.currentScrollView);
    }
}

- (void)showNetErrorViewIfNeeded {
    [QSLoadingView dismiss];
    if (self.dataManager.categories.count == 0) {
        @weakObj(self);
        [self showEmptyViewForNoNetInView:selfweak.view refreshHandler:^{
            [selfweak loadData];
        }];
    }
}

- (BOOL)showEmptyViewIfEmpty {
    if (self.dataManager.categories.count == 0) {
        [self showEmptyViewInView:self.view type:FEErrorType_NoData];
        return YES;
    } else {
        [self hideEmptyView];
        return NO;
    }
}

- (UIScrollView *)currentScrollView {
    return self.segmentView.currentViewController.view.subviews.firstObject;
}

- (void)resetAllScrollViewOffset {
    for (UIViewController *viewController in _segmentView.viewControllers) {
        UIView *view = viewController.view.subviews.firstObject;
        if (view && [view isKindOfClass:UIScrollView.class]) {
            UIScrollView *scrollView = ((UIScrollView *)view);
            scrollView.contentOffset = CGPointZero;
        }
    }
}

@end
