//
//  FEEvaluationReportCollectionViewCell.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEEvaluationReportCollectionViewCell.h"
#import "TCRecommendTestProductView.h"
#import "NSObject+FEObserver.h"
#import "UIImage+Utils.h"
#import "UIView+FEUI.h"
@interface FEEvaluationReportCollectionViewCell ()
@property (nonatomic, strong) CareerReportDataModel *reportModel;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, weak) FEUIColumn *rootCotainer;

@property (nonatomic, strong) UIImageView *skeletonView;

@property (nonatomic, copy) void (^updateWithRecommendDataHandler)(void);

@property (nonatomic, assign) BOOL shouldContainTitle;
@end
@implementation FEEvaluationReportCollectionViewCell


- (void)updateWithReportModel:(CareerReportDataModel *)reportModel shouldContainTitle:(BOOL)should{

    self.reportModel = reportModel;
    self.shouldContainTitle = should;
    [self buildUI];

}

- (UIImageView *)skeletonView {
    if (!_skeletonView) {
        _skeletonView = [[UIImageView alloc] initWithImage: [UIImage scaleImageWithName:@"report_load_bg" toSize:self.bounds.size] ];
        _skeletonView.contentMode = UIViewContentModeBottom;
    }
    return _skeletonView;
}

- (void)buildUI {
    if (_scrollView == nil) {
        //添加骨架图
//        [self addSubview:self.skeletonView];
//        [QSLoadingView show];
        //延迟创建视图，否则将造成滚动卡顿
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //移除骨架图
                [self.skeletonView removeFromSuperview];
            });
            self->_scrollView = [[UIScrollView alloc]init];
            self->_scrollView.showsVerticalScrollIndicator = NO;
            self->_scrollView.alwaysBounceVertical = YES;
            [self->_scrollView.layer setMasksToBounds:YES];
            self->_scrollView.alwaysBounceHorizontal = NO;
            [self addSubview:self->_scrollView];
            [self->_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
            [self bringSubviewToFront:self.skeletonView];
            
            [self addScrollObserver];
            [self buildRootContainer];

        });
    }
}


- (void)addScrollObserver {
    @weakObj(self);
    [self.scrollView fe_addObserver:self forKeyPath:@"contentOffset" withBlock:^(id  _Nullable oldValue, id  _Nullable newValue) {
        @strongObj(self);
        CGFloat offsetY = self.scrollView.contentOffset.y;
        CGFloat offsetFromBottom = self.scrollView.contentSize.height - (CGRectGetHeight(self.scrollView.bounds) + offsetY);
        if (self.scrollViewContentOffsetFromBottonChangedHandler) {
            self.scrollViewContentOffsetFromBottonChangedHandler(offsetFromBottom, offsetY);
        }
    }];
}

- (void)buildRootContainer {
    FEUIColumn *rootContainer =
    [[FEUIColumn alloc]
     //推荐阅读的container等到数据请求后再添加
     initWithChildren:self.rootContainerChildren
     padding:UIEdgeInsetsMake(0, 0, 0, 0)
     spacing:GeneralSpacing
    ];
    
    [self.scrollView
     feui_addRootContainer:rootContainer
     padding:UIEdgeInsetsMake(0, GeneralSpacing, GeneralSpacing, GeneralSpacing)];

    _rootCotainer = rootContainer;
    
    //如果有阅读
    if (_updateWithRecommendDataHandler) {
        _updateWithRecommendDataHandler();
        _updateWithRecommendDataHandler = nil;
    }
}

- (NSArray <FEUIComponent *>*)rootContainerChildren {
    return @[
        self.overallDescContainer,
        self.comprehensiveContainer,
        self.detailedDescContainer,
        self.recommendedProductContainer
    ];
}

#pragma mark - 报告的描述
- (FEUIComponent *)overallDescContainer {
    NSArray *children;
    UIEdgeInsets padding;
    if (_shouldContainTitle) {
        children = @[self.titleLabel, self.overallDescView];
        padding = UIEdgeInsetsMake(STWidth(14), GeneralSpacing, STWidth(10), GeneralSpacing);
    } else {
        children = @[self.overallDescView];
        padding = UIEdgeInsetsMake(0, GeneralSpacing, STWidth(10), GeneralSpacing);
    }
    
    return
    [[FEUIColumn alloc]
     initWithChildren:children
     padding:padding
     spacing:GeneralSpacing
    ];
}

- (FEUIComponent *)overallDescView {
    return
    [[FEReportOverallDescView alloc]
     initWithDescriptionContent:_reportModel.dDescription
     projectedContentWidth:STWidth(315)
     ];
}

- (FEUIComponent *)titleLabel {//单报告类型需要添加的title
    return
    [[FEReportTitleLabel alloc]
     initWithTitle:_reportModel.title];
}

#pragma mark - 综合说明
- (FEUIComponent *)comprehensiveContainer {
    FEUIColumn *container =
    [[FEUIColumn alloc]
     initWithChildren:@[self.circleScoreView, self.scoreDescVew, self.appraiseView]
     padding:UIEdgeInsetsMake(STWidth(15), GeneralSpacing, GeneralSpacing, GeneralSpacing)
     spacing:GeneralSpacing
    ];
    [container setBackgroundColor:UIColor.fe_contentBackgroundColor cornerRadius:STWidth(12)];
   
    return container;
}

- (FEUIComponent *)circleScoreView {
    if (_reportModel.score == nil) {
        if (![NSString isEmptyString:self.reportModel.result]) { //特殊情况，没有score显示result
            return [[FEReportGeneralTextContentView alloc]
            initWithText:self.reportModel.result];
        } else {
            return FEUIComponent.emptyInstance;
        }
    }
    return
    [[FEReportCircleScoreView alloc]
     initWithMaxScore:_reportModel.maxScore? _reportModel.maxScore.floatValue : 100
     score:[NSString formatFloatNumber:_reportModel.score AfterDecimalPoint:1] 
     result:_reportModel.result
     isBadTendency:_reportModel.isBadTendency? _reportModel.isBadTendency.boolValue : NO
    ];
}

- (FEUIComponent *)scoreDescVew {
    if (_reportModel.score == nil) {
        return FEUIComponent.emptyInstance;
    }
    return
    [[FEReportScoreDescView alloc]
     initWithScore:_reportModel.score
     desc:_reportModel.trend
     ];
}

- (FEUIComponent *)appraiseView {
    if ([NSString isEmptyString:_reportModel.appraisal]) {
        return FEUIComponent.emptyInstance;
    }
    return
    [[FEReportAppraiseView alloc]
     initWithAppraiseContent: _reportModel.appraisal
    ];
}

#pragma mark - 详细说明
- (FEUIComponent *)detailedDescContainer {
    if (_reportModel.subItems.count == 0) {
        return [FEUIColumn emptyInstance];
    }
    
    FEUIColumn *container =
    [[FEUIColumn alloc]
     initWithChildren:@[self.detailedDescCategoryView, self.detailedDescItemsContainer]
     padding:UIEdgeInsetsMake(GeneralSpacing, 0, 0, 0)
     spacing:0
    ];
    [container setBackgroundColor:UIColor.fe_contentBackgroundColor cornerRadius:STWidth(12)];
    return container;
}

- (FEUIComponent *)detailedDescCategoryView {
    return
    [[FEReportCategoryView alloc]
     initWithCategoryTitle:@"详细说明"
    ];
}

- (FEUIComponent *)detailedDescItemsContainer  {
    return
    [[FEUIColumn alloc]
     initWithChildren:self.detailedDescItems
     padding:GeneralInsets
     spacing:STWidth(20)];
}

- (NSMutableArray <FEUIComponent *>*)detailedDescItems {
    NSMutableArray <FEUIComponent *>*items = @[].mutableCopy;
    for(int i = 0; i < _reportModel.subItems.count; i ++) {
        CareerSubItemsModel *itemModel = _reportModel.subItems[i];
        
        FEUIColumn *item =
        [[FEUIColumn alloc]
         initWithChildren:@[
             [[FEReportItemResultView alloc]
              initWithItemName:itemModel.itemName
              result:[self getItemResultForModel:itemModel]
              isBadTendency:itemModel.isBadTendency ? [itemModel.isBadTendency boolValue] : NO
              projectedContentWidth:mScreenWidth - STWidth(90)
             ],
             [[FEReportItemDescView alloc]
              initWithItemDesc:itemModel.pDescription
              score:[NSString stringWithFormat:@"%@",itemModel.score? itemModel.score : @""]
              maxScore:[NSString stringWithFormat:@"%@",itemModel.maxScore? itemModel.maxScore : @""]
              scoreDesc:itemModel.trend
              appraisal:itemModel.appraisal
              suggest:itemModel.suggest
              ]
         ]
         padding:UIEdgeInsetsZero
         spacing:STWidth(10)
        ];
        [items addObject:item];
    }
    return items;
}

- (NSArray *)getItemResultForModel:(CareerSubItemsModel *)model {
    return [model.result componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",，。.、"]];
}

#pragma mark - 推荐商品
- (FEUIComponent *)recommendedProductContainer {
//    if (_reportModel.recommendedProductData == nil || _reportModel.recommendedProductData.count == 0) {
//        return [FEUIColumn emptyInstance];
//    }
    
    FEUIColumn *container =
    [[FEUIColumn alloc]
     initWithChildren:@[self.recommendedProductCategoryView, self.recommendedProductItemsContainer]
     padding:UIEdgeInsetsMake(GeneralSpacing, 0, 0, 0)
     spacing:0
    ];
    container.backgroundColor = UIColor.fe_contentBackgroundColor;
    [container setBackgroundColor:UIColor.fe_contentBackgroundColor cornerRadius:STWidth(12)];
    return container;
}

- (FEUIComponent *)recommendedProductCategoryView {
    if (!self.reportModel.recommendProductData || (self.reportModel.recommendProductData.recommendDimension == nil && self.reportModel.recommendProductData.recommendCourse == nil) || (self.reportModel.recommendProductData.recommendDimension.count == 0  && self.reportModel.recommendProductData.recommendCourse.count == 0)) {
        return [FEUIComponent emptyInstance];
    }
    return
    [[FEReportCategoryView alloc]
     initWithCategoryTitle:@"你可能感兴趣"
    ];
}

- (FEUIComponent *)recommendedProductItemsContainer  {
    return
    [[FEUIColumn alloc]
     initWithChildren:self.recommendedProductItmes
     padding:GeneralInsets
     spacing:STWidth(20)];
}

- (NSMutableArray <FEUIComponent *>*)recommendedProductItmes {
    NSMutableArray <FEUIComponent *>*items = @[].mutableCopy;
    NSArray *randomRecommendData = [self.reportModel.recommendProductData generateThreeRandomTestData];
    for(int i = 0; i < randomRecommendData.count; i ++) {
        TCRecommendProductModel *itemModel = randomRecommendData[i];
        TCRecommendTestProductView *item = [[TCRecommendTestProductView alloc] initWithTitleText:itemModel.name participantsCount:itemModel.productType == TCProductTypeTest?itemModel.itemUseCount.integerValue : -1 iconImageURL:[NSURL URLWithString:itemModel.image] alreadyPurchase:NO presentPrice:itemModel.priceYuan originPrice:itemModel.originPriceYuan];
        item.onClick = ^{
            if (self.recommendedProductClickHandler) {
                self.recommendedProductClickHandler(itemModel);
            }
        };
        [items addObject:item];
    }
    return items;
}

@end
