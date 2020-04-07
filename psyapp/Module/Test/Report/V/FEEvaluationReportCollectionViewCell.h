//
//  FEEvaluationReportCollectionViewCell.h
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEReportOverallDescView.h"
#import "FEUIColumn.h"
#import "FEReportCircleScoreView.h"
#import "FEReportAppraiseView.h"
#import "FEReportCategoryView.h"
#import "FEReportItemResultView.h"
#import "FEReportItemDescView.h"
#import "FEReportScoreDescView.h"
#import "FEReportRecommendedArticleView.h"
#import "FEReportMoreButton.h"
#import "FEReportGeneralTextContentView.h"
#import "FEReportTitleLabel.h"

#import "CareerReportDataModel.h"


#define GeneralSpacing STWidth(15)
#define GeneralInsets UIEdgeInsetsMake(STWidth(15), STWidth(15), STWidth(15), STWidth(15))
@interface FEEvaluationReportCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) void (^scrollViewContentOffsetFromBottonChangedHandler)(CGFloat offsetFromBottom, CGFloat scrollViewOffsetY);
@property (nonatomic, copy) void (^recommendedProductClickHandler)(TCRecommendProductModel *model);


- (void)updateWithReportModel:(CareerReportDataModel *)reportModel shouldContainTitle:(BOOL)should;
@end

