//
//  FEEvaluationReportViewController.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEEvaluationReportViewController.h"
#import "FEBaseViewController+CustomTitleTransition.h"
#import "TCTestDetailViewController.h"

#import "FEEvaluationReportCollectionViewCell.h"
#import "FEEvaluationCareerReportCollectionViewCell.h"
#import "FEEvaluationReportSelectionView.h"
#import "FEEvaluationView.h"

#import "FEEvalutaionReportManager.h"
#import "FEOccupationLibViewController.h"

#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>
@interface FEEvaluationReportViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) FEEvaluationReportSelectionView * reportSelectionView;

@property (nonatomic, strong) NSCache <NSString*, UICollectionViewCell*>*cellCache;

@property (nonatomic, assign) BOOL shouldContainTitleInCell;

@property (nonatomic, strong) FEEvalutaionReportManager *dataManager;

@property (nonatomic, copy) NSString *dimensionId;
@property (nonatomic, copy) NSString *childDimensionId;
@end

@implementation FEEvaluationReportViewController
- (instancetype)initWithDimensionId:(NSString *)dimensionId childDimensionId:(NSString *)childDimensionId {
    self = [super init];
    _dimensionId = dimensionId;
    _childDimensionId = childDimensionId;
    
    return self;
}

- (instancetype)initWithAVObject:(AVObject *)object level:(NSInteger)level {
    self = [super init];
    _dataManager = [[FEEvalutaionReportManager alloc] initWithAVObject:object level:level];
    return self;
}

- (void)loadView {
    [super loadView];

    //顶部圆型背景
    [self p_buildCollectionView];
    [self p_buildLoadingView];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = NO;
    self.navigationBarShadowHidden = YES;

    self.view.backgroundColor = UIColor.fe_mainColor;
    _cellCache = [NSCache new];
    
    [self p_loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
    //原先是在pop之前处理的，现在改为进入界面就处理，因为侧滑pop不能响应自定义的方法
    [self p_removeUnusedViewControllersFromNavigationStackWhenPushFromExam];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [_loadingImageView removeFromSuperview];
    _loadingImageView = nil;
    [super viewDidDisappear:animated];
}



//从测评进入的报告界面，需要移除测评VC，防止重复进入测评
- (void)p_removeUnusedViewControllersFromNavigationStackWhenPushFromExam {
    //获取上一个视图控制器
    UIViewController *lastViewController = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    //如果刚完成Exam，那么返回到倒数第四层视图控制器
    if ([lastViewController isKindOfClass:NSClassFromString(@"FEAnswerViewController")]) {
        //移除中间的视图控制器，然后重新赋值
        NSArray *originViewControllers = self.navigationController.viewControllers;
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:originViewControllers];
        NSRange removeIndexRange = NSMakeRange([self.navigationController.viewControllers count] -2, 1);
        NSIndexSet *removeIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:removeIndexRange];
        [viewControllers removeObjectsAtIndexes:removeIndexSet];
        
        self.navigationController.viewControllers = viewControllers;
    }
}

- (NSInteger)selectedPageIndex {
    return self.reportSelectionView.selectedIndex;
}

#pragma mark - Build UI

- (void)p_buildCollectionView {
     UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
     layout.minimumInteritemSpacing = 0;
     layout.minimumLineSpacing = 0;
     layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
     layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
     //layout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - STWidth(STWidth(57)));
    //cell的scrollView会根据该尺寸设置
     layout.itemSize = CGSizeMake(mScreenWidth, mScreenHeight - mNavBarAndStatusBarHeight - mBottomSafeHeight);
     _flowLayout = layout;
    
     _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
     _collectionView.backgroundColor = UIColor.clearColor;
     _collectionView.showsHorizontalScrollIndicator = NO;
     _collectionView.pagingEnabled = YES;
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
     [self.view addSubview:_collectionView];
     [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, mBottomSafeHeight, 0));
     }];
}

- (void)buildMergedTypeUI {  //合并类型，的标题旋转栏和collectionView同级，单报告标题作为collectionViewCell的内部视图
    _shouldContainTitleInCell = NO;
    CGFloat topOffset = STWidth(57 ) + mTopBarDifHeight;
    [self p_buildReportSelectionViewForMergedType];
    _flowLayout.itemSize = CGSizeMake(mScreenWidth, mScreenHeight - mNavBarAndStatusBarHeight - topOffset);
    _flowLayout.sectionInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
    //self.collectionView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
}

- (void)p_buildReportSelectionViewForMergedType {
    _reportSelectionView = [[FEEvaluationReportSelectionView alloc] initWithItemNames:self.dataManager.reportNames];
    [self.view addSubview:_reportSelectionView];
    [_reportSelectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(STWidth(14));
        make.left.offset(STWidth(15));
        make.right.offset(STWidth(-15));
        make.height.mas_equalTo(STWidth(33));
    }];
    @weakObj(self);
    _reportSelectionView.selectHandler = ^(NSInteger index) {
        @strongObj(self);
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    };
    _reportSelectionView.hidden = YES; //loadingView消失后显示
}

- (void)p_buildLoadingView{
    //骨架图
    _loadingImageView = [UIImageView new];
    _loadingImageView.image = [UIImage qmui_imageWithColor:UIColor.fe_mainColor];
    _loadingImageView.frame = CGRectMake(0, 0, mScreenWidth, CGRectGetHeight(self.view.frame));
    
    [self.view addSubview:_loadingImageView];
  
    //已生成的报告的加载UI
    if (_isCreating == NO) {
       //[QSLoadingView show];
    } else {
        [QSLoadingView dismiss];
        //报告生成中的加载UI
       CALayer *loadingImageViewMask = [CALayer layer];
       loadingImageViewMask.frame = CGRectMake(0, -mNavBarAndStatusBarHeight, mScreenWidth, CGRectGetHeight(self.view.frame) );
       loadingImageViewMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0].CGColor;
       [_loadingImageView.layer addSublayer:loadingImageViewMask];
    
       UIView *animationViewContainer = [UIView new];
       animationViewContainer.backgroundColor = UIColor.fe_contentBackgroundColor;
       animationViewContainer.frame = CGRectMake(0, 0, STWidth(130), STWidth(130));
       animationViewContainer.layer.cornerRadius = STWidth(4);
       animationViewContainer.center = CGPointMake(self.view.center.x, self.view.center.y - mNavBarAndStatusBarHeight);
       [_loadingImageView addSubview:animationViewContainer];
    

       FLAnimatedImageView *loadingAnimationView = [FLAnimatedImageView new];
       loadingAnimationView.frame = CGRectMake(STWidth(17), STWidth(12), STWidth(99), STWidth(77));//使动画之前在屏幕外
       NSURL *url = [[NSBundle mainBundle] URLForResource:@"report_loading" withExtension:@"gif"];
       NSData *data = [NSData dataWithContentsOfURL:url];
       FLAnimatedImage *animationImage = [FLAnimatedImage animatedImageWithGIFData:data];
       loadingAnimationView.animatedImage = animationImage;
    
       [animationViewContainer addSubview:loadingAnimationView];
    
       UILabel *loadingLabel = [UILabel new];
       loadingLabel.text = @"报告生成中...";
       loadingLabel.textColor =UIColor.fe_titleTextColor;
       loadingLabel.font = STFont(12);
       loadingLabel.frame = CGRectMake(STWidth(32), STWidth(104), 0, 0);
       [loadingLabel sizeToFit];
       [animationViewContainer addSubview:loadingLabel];
    }

    
}

#pragma mark - Collection View
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataManager.isMergedReport) {
        return self.dataManager.reportInfo.subReport.count;
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //采取不复用cell的方式，配合缓存，实现懒加载
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section, (long)indexPath.item];
    UICollectionViewCell *_cell = [_cellCache objectForKey:key];
    if (_cell == nil) {
        NSString *className = self.isCareerReport? @"FEEvaluationCareerReportCollectionViewCell" : @"FEEvaluationReportCollectionViewCell";
        NSString *identifier = [NSString stringWithFormat:@"%@%ld-%ld",className, (long)indexPath.section, (long)indexPath.item];
        [collectionView registerClass:NSClassFromString(className)forCellWithReuseIdentifier:identifier];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        [self.cellCache setObject:cell forKey:key];
        
        _cell = cell;
    }
    
    return _cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_reportSelectionView) { //滚动过程中显示的cell不加载数据
        if (_reportSelectionView.targetIndex != indexPath.item && _reportSelectionView.targetIndex != -1) {
            return;
        } else {
            _reportSelectionView.targetIndex = -1;
        }
    }
    
    FEEvaluationReportCollectionViewCell *_cell = (FEEvaluationReportCollectionViewCell *)cell;
    
    if (self.dataManager.isMergedReport) {
        [_cell updateWithReportModel:self.dataManager.reportInfo.subReport[indexPath.item] shouldContainTitle:self.shouldContainTitleInCell];
    } else {
        [_cell updateWithReportModel:self.dataManager.reportInfo shouldContainTitle:self.shouldContainTitleInCell];
    }
    @weakObj(self);
    _cell.scrollViewContentOffsetFromBottonChangedHandler = ^(CGFloat offsetFromBottom, CGFloat scrollViewOffsetY) {
        @strongObj(self);
        //控制单报告界面的title
        if (!self.dataManager.reportInfo.isMergeAnswer.boolValue) {
            [self customTitleTransitionWithPercent:scrollViewOffsetY/mNavBarHeight];
        }
    };

    
    FEEvaluationCareerReportCollectionViewCell *mbtiCell = (FEEvaluationCareerReportCollectionViewCell *)_cell;
    mbtiCell.occupationRecommendTagClickHandler = ^(NSInteger idx) {
        @strongObj(self);
        MbtiRecommendModel *mbtiModel = self.dataManager.reportInfo.recommend[idx];

        NSString *areaName = mbtiModel.areaName;

        FEOccupationLibViewController *vc = [[FEOccupationLibViewController alloc] init];
        vc.areaName = areaName;

        [self.navigationController pushViewController:vc animated:YES];
    };
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page =  self.collectionView.width == 0?0 : (self.collectionView.contentOffset.x / self.collectionView.width);
    page = page + 0.5;
    [_reportSelectionView updateSelectedIndex:(NSInteger)page isTriggeredByTap:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _reportSelectionView.targetIndex = -1;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (_reportSelectionView) {
        [_reportSelectionView adjustSelectedItemToLeftmostEnd];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_reportSelectionView) {
        [_reportSelectionView adjustSelectedItemToLeftmostEnd];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}
#pragma mark - Animation
- (void)p_playOpeningAnimation {
    [_loadingImageView removeFromSuperview];
    _loadingImageView = nil;
    
    
    //显示合并报告的selectionView
    if (self.reportSelectionView) {
        self.reportSelectionView.hidden = NO;
    }

   
}

#pragma mark - Request
- (void)p_loadData {
    @weakObj(self);
    [_dataManager requestReportDataWithSuccess:^{
       @strongObj(self);

        if (self.dataManager.isMergedReport) {
            self.title = @"报告详情";
            [self buildMergedTypeUI];
        } else {
            self.shouldContainTitleInCell = YES;
            self.customTitleLabel = self.defaultCustomTitleLabel;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.customTitleLabel.text = self.dataManager.reportInfo.title;
            });
            
        }
        
        void (^handler)(void) = ^{
            selfweak.collectionView.delegate = selfweak;
            selfweak.collectionView.dataSource = selfweak;
            [selfweak.collectionView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [selfweak p_playOpeningAnimation];
            });
        };
        handler();
        
    } failure:^{
        @strongObj(self);
        [self.loadingImageView removeFromSuperview];
        self.loadingImageView = nil;
    } ifRequstOverUpperLimit:^{
        @strongObj(self);
        [self.navigationController popViewControllerAnimated: YES];
        [QSToast toast:[UIApplication sharedApplication].keyWindow message:@"抱歉！报告正在生成中，请稍后查看"];
    }];
}


@end
