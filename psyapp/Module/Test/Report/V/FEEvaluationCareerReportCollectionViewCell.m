//
//  FEEvaluationCareerReportCollectionViewCell.m
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEEvaluationCareerReportCollectionViewCell.h"

#import "FEReportGeneralTextContentView.h"
#import "FEReportRadarChartView.h"
#import "FEReportMBTIDescView.h"
#import "FEReportProportionChartView.h"
#import "FEReportFlowLayoutTagView.h"

@interface FEEvaluationReportCollectionViewCell ()
@property (nonatomic, strong) CareerReportDataModel *reportModel;
- (NSArray <FEUIComponent *>*)rootContainerChildren;
- (FEUIComponent *)overallDescContainer;//报告的描述
- (FEUIComponent *)detailedDescContainer;//详细说明
- (FEUIComponent *)appraiseView;//评价
@end

//父类方法声明
typedef enum CareerReportType {
    ReportTypeStudiesOrInterests,//学业能力、职业兴趣 （描述，雷达图+评价，详细说明）
    ReportTypeMBTI,  //职业性格倾向 （描述，条形比重图+评价，推荐职业类型）
    ReportTypeGener //无图形的报告类型 （描述，结论+评价，详细说明）
}CareerReportType;

@interface FEEvaluationCareerReportCollectionViewCell ()
@property (nonatomic, assign) CareerReportType reportType;
@end

@implementation FEEvaluationCareerReportCollectionViewCell
- (void)updateWithReportModel:(CareerReportDataModel *)reportModel shouldContainTitle:(BOOL)should{
    self.reportModel = reportModel;
    _reportType = self.reportType;
    [super updateWithReportModel:reportModel shouldContainTitle:should];
}

- (NSArray *)rootContainerChildren {
    NSArray *children;
    switch (_reportType) {
        case ReportTypeGener:
            children = @[
                self.overallDescContainer,
                self.generalComprehensiveContainer,
                self.detailedDescContainer
            ];
            break;
        case ReportTypeStudiesOrInterests:
            children = @[
                self.overallDescContainer,
                self.studiesAndInterestsComprehensiveContainer,
                self.detailedDescContainer
            ];
            break;
        case ReportTypeMBTI:
            children = @[
                self.overallDescContainer,
                self.MBTIComprehensiveContainer,
                self.MBTIOccupationRecommendContainer
            ];
            break;
        default:
            children = @[
                self.overallDescContainer
            ];
            break;
    }
    return children;
}
#pragma mark - 一般报告的综合评价
- (FEUIComponent *)generalComprehensiveContainer {
    FEUIColumn *container =
    [[FEUIColumn alloc]
     initWithChildren:@[
         self.generalTextContent,
         self.appraiseView]
     padding:GeneralInsets
     spacing:GeneralSpacing];
    [container setBackgroundColor:UIColor.fe_contentBackgroundColor cornerRadius:STWidth(12)];
    return container;
}

- (FEUIComponent *)generalTextContent {
    if ([NSString isEmptyString:self.reportModel.result]) {
        return FEUIComponent.emptyInstance;
    }
    return
    [[FEReportGeneralTextContentView alloc]
     initWithText:self.reportModel.result];
}


#pragma mark - 学业兴趣和职业能力报告的综合评价

- (FEUIComponent *)studiesAndInterestsComprehensiveContainer {
    FEUIColumn *container =
    [[FEUIColumn alloc]
     initWithChildren:@[
         self.generalTextContent,
         self.radarChartView,
         self.appraiseView]
     padding:GeneralInsets
     spacing:GeneralSpacing];
    [container setBackgroundColor:UIColor.fe_contentBackgroundColor cornerRadius:STWidth(12)];
    return container;
}

- (FEUIComponent *)radarChartView {
    if (self.reportModel.chartDatas.count == 0) {
        return FEUIComponent.emptyInstance;
    }
    return
    [[FEReportRadarChartView alloc]
     initWithChartData:self.reportModel.chartDatas[0] size:STSize(300, 250)];
}

#pragma mark - MBTI报告的综合评价 和 职业类型推荐
- (FEUIComponent *)MBTIComprehensiveContainer {
    FEUIColumn *container =
    [[FEUIColumn alloc]
    initWithChildren:@[
        self.MBTIDescView,
        self.MBTIProportionChartViewContainer,
        self.appraiseView]
    padding:GeneralInsets
    spacing:GeneralSpacing];;
    [container setBackgroundColor:UIColor.fe_contentBackgroundColor cornerRadius:STWidth(12)];
    return container;
}

- (FEUIComponent *)MBTIDescView {
    if ([NSString isEmptyString:self.reportModel.result]) {
        return FEUIComponent.emptyInstance;
    }
    return
    [[FEReportMBTIDescView alloc]
     initWithType:self.reportModel.result
     image:self.reportModel.viceResult];
}

- (FEUIComponent *)MBTIProportionChartViewContainer {
    return
    [[FEUIColumn alloc]
     initWithChildren:self.MBTIProportionChartViews
     padding:UIEdgeInsetsZero
     spacing:STWidth(10)];
}

- (NSArray <FEUIComponent *> *)MBTIProportionChartViews {
    NSMutableArray <FEUIComponent *>*views = @[].mutableCopy;
    for (MbtiDateModel *model in self.reportModel.mbtiDate) {
        FEReportProportionChartView *view =
        [[FEReportProportionChartView alloc] initWithLeftName:model.leftName leftPercent:model.left.floatValue rightName:model.rightName rightPercent:model.right.floatValue];
        [views addObject:view];
    }
    return views;
}

- (FEUIComponent *)MBTIOccupationRecommendContainer {
    
    NSMutableArray<NSString *> *itemNames = @[].mutableCopy;
    for(int i=0;i<self.reportModel.recommend.count;i++){
        [itemNames addObject:self.reportModel.recommend[i].areaName];
    }
    
    FEReportFlowLayoutTagView *tagView =
    [[FEReportFlowLayoutTagView alloc]
     initWithTitle:@"推荐职业类型"
     itemNames:itemNames
     projectedWidth:STWidth(315)];
    tagView.tagClickHandler = ^(NSInteger idx) {
        if (self.occupationRecommendTagClickHandler) {
            self.occupationRecommendTagClickHandler(idx);
        }
    };
    
    FEUIColumn *container =
    [[FEUIColumn alloc]
     initWithChildren:@[tagView]
     padding:GeneralInsets
     spacing:0];
    [container setBackgroundColor:UIColor.fe_contentBackgroundColor cornerRadius:STWidth(12)];

    return container;
}


- (CareerReportType)reportType {
    if (self.reportModel.chartType.integerValue == 5) {
        return ReportTypeMBTI;
    }
    
    if([self.reportModel.title containsString:@"学业能力"] ||
       [self.reportModel.title containsString:@"职业兴趣"] ||
       [self.reportModel.title containsString:@"学业兴趣"]
       ){
        return ReportTypeStudiesOrInterests;
    }else{
        return ReportTypeGener;
    }
}
@end
