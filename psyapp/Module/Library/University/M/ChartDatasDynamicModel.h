//
//  ChartDatasDynamicModel.h
//  smartapp
//
//  Created by lafang on 2018/12/11.
//  Copyright © 2018 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "ReportResultsModel.h"
#import "ChartItemsDynamicModel.h"
#import "DimensionBaseModel.h"

@interface ChartDatasDynamicModel : FEBaseModel

@property(nonatomic,strong) NSNumber *isTopic;
@property(nonatomic,strong) NSString *chartItemId;
@property(nonatomic,strong) NSString *chartItemName;
@property(nonatomic,strong) NSNumber *chartType;
@property(nonatomic,strong) NSNumber *scoreType;
@property(nonatomic,strong) NSNumber *minScore;
@property(nonatomic,strong) NSNumber *maxScore;
@property(nonatomic,strong) NSString *chartDescription;
@property(nonatomic,strong) NSArray *items;

@property(nonatomic,strong) ReportResultsModel *resultModel;

//报告界面使用的变量
@property(nonatomic,strong) NSString *curCompareId;//0-全国 5-学校，6-年级，7-班级
@property(nonatomic,strong) DimensionBaseModel *dimensionModel;
@property(nonatomic,assign) BOOL isShowChartDesc;//是否张开报表说明

@end
