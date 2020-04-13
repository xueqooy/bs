//
//  TCDicoveryBannerViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/28.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDiscoveryBannerViewController.h"
#import "ArticleDetailViewController.h"

#import "NewPagedFlowView.h"
#import "TCAdvertPopupView.h"

#import "TCBannerDataManager.h"
#import "TCBannerModel.h"
//#import "FEAppURLHandler.h"
#import "TCTaskSerialQueue.h"
#import "TCBannerEventHandler.h"
@interface TCDiscoveryBannerViewController () <NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property (nonatomic, strong) NewPagedFlowView *bannerView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) TCBannerDataManager *dataManager;

@property (nonatomic, strong) TCTaskSerialQueue *adDisplayTaskQueue;
@end

@implementation TCDiscoveryBannerViewController {
    BOOL _needsDisplayBannerAd;
}

@synthesize dataLoadedBlock = _dataLoadedBlock;
- (instancetype)init {
    self = [super init];
    self.dataManager = TCBannerDataManager.new;
    return self;
}

- (CGFloat)height {
    return STWidth(150);
}

- (void)loadView {
    [super loadView];
    
    _bannerView = [NewPagedFlowView new];
    _bannerView.minimumPageAlpha = 0.1;
    _bannerView.isCarousel = YES;
    _bannerView.isOpenAutoScroll = YES;
    _bannerView.backgroundColor = UIColor.fe_contentBackgroundColor;
    [self.view addSubview:_bannerView];
    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
       
    _pageControl = UIPageControl.new;
    _bannerView.pageControl = _pageControl;
    [_bannerView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(STWidth(10));
        make.centerX.offset(0);
    }];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bannerView.delegate = self;
    _bannerView.dataSource = self;
}

- (UIScrollView *)bannerScrollView {
    return _bannerView.scrollView;
}

- (void)setNeedsBannerAdDisplay {
    _needsDisplayBannerAd = YES;
}

- (void)displayBannerAdIfNeeded {
    if (_needsDisplayBannerAd == NO) return;
    _needsDisplayBannerAd = NO;
    NSSet *set = self.dataManager.undisplayedBannerAds.copy;
    if (set) {
        for (TCBannerModel *model in set.allObjects) {
            @weakObj(self);
            void (^block)(void) = ^{
                @strongObj(self);
                TCAdvertPopupView *view = TCAdvertPopupView.new;
                view.hideAnimated = NO;
                view.hideWhenTapImage = YES;
                GCD_ASYNC_GLOBAL(^{
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.adImageURL]];
                    GCD_ASYNC_MAIN(^{
                        UIImage *image = [UIImage imageWithData:imageData];
                        view.imageView.image = image;
                        [view showWithAnimated:NO];
                    });
                });
                view.didHideBlock = ^{
                    @strongObj(self);
                    if (self) {
                        [self.adDisplayTaskQueue next];
                    }
                };
                view.didTapImage = ^{
                    @strongObj(self);
                    if (self) {
                        [self handleBannerClick:model];
                    }
                };
            };
            [self.adDisplayTaskQueue addTaskBlock:block];
        }
        
        [self.adDisplayTaskQueue next];
    }
}

- (void)loadData {
    @weakObj(self);
    [self.dataManager getBannerOnSuccess:^{
        [selfweak dataDidLoad];
    } failure:^{
        
    }];
}

- (void)dataDidLoad {
    if (_dataLoadedBlock) _dataLoadedBlock(self.dataManager.banners.count > 0);
    [_bannerView reloadData];
    [self displayBannerAdIfNeeded];
}

- (void)handleBannerClick:(TCBannerModel *)banner {
    [TCBannerEventHandler handleBannerClickForBanner:banner viewController:self];
}



- (TCTaskSerialQueue *)adDisplayTaskQueue {
    if (_adDisplayTaskQueue == nil) {
        _adDisplayTaskQueue = TCTaskSerialQueue.new;
    }
    return _adDisplayTaskQueue;
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return STSize(345, 150);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    TCBannerModel *banner = self.dataManager.banners[subIndex];
    [self.dataManager countBannerClick:banner.uniqueId];
    [self handleBannerClick:banner];
}



- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
}

- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.dataManager.banners.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = STWidth(4);
        bannerView.layer.masksToBounds = YES;
    }
    
    NSURL *imageURL = [NSURL URLWithString:self.dataManager.banners[index].imgUrl];
    
    [bannerView.mainImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"default_21"] options:0 progress:nil completed:nil];
    
    return bannerView;
}


@end
