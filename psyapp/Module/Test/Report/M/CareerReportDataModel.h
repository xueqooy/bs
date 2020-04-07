//
//  CareerReportDataModel.h
//  smartapp
//
//  Created by lafang on 2019/3/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "CareerSubItemsModel.h"
#import "CareerChartDataModel.h"
#import "MbtiDateModel.h"
#import "MbtiRecommendModel.h"


#import "TCTestReportRecommendProductModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CareerReportDataModel : FEBaseModel

//"title":"string",           //报告标题
//"compare_name":"string",    //对比样本名称
//"description":"string",     //场景描述
//"result":"string",          //测评结果（场景下不一定有总体测评结果）
//"score":50.5,               //测评得分（原始分或者T分数，场景下不一定有总体得分）
//"sub_result":["string"],        //子维度测评结果的集合（对于场景下没有设定总体结果的情况，用这个字段显示）
//"rank":90,                  //超过%90的用户（测评得分是原始分就没有排名）
//"appraisal":"string",           //评价（测评得分是原始分就没有评价）
//"chart_type":0,             //报告图表类型，默认0，5 - 百分比堆积柱状图
//"chart_datas": [
//"sub_items":[

//"vice_result":"",           //典型形像（MBTI）
//"mbti_date":[
// "recommend":[   //MBTI推荐数据

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *compareName;
@property(nonatomic, strong) NSString *dDescription;
@property(nonatomic, strong) NSString *result;
@property(nonatomic, strong) NSNumber *score;
@property(nonatomic, strong) NSArray<NSString *> *subResult;
@property(nonatomic, strong) NSNumber *rank;
@property(nonatomic, strong) NSString *appraisal;
@property(nonatomic, strong) NSNumber *chartType;
@property(nonatomic, strong) NSArray <CareerChartDataModel *>*chartDatas;
@property(nonatomic, strong) NSArray <CareerSubItemsModel *>*subItems;
@property(nonatomic, strong) NSString *viceResult;
@property(nonatomic, strong) NSArray <MbtiDateModel *>*mbtiDate;
@property(nonatomic, strong) NSArray <MbtiRecommendModel *>*recommend;

@property (nonatomic, assign) NSNumber *isBadTendency;
@property (nonatomic, assign) NSNumber *maxScore;
@property (nonatomic, assign) NSNumber *minScore;
@property (nonatomic, copy) NSString *trend;
@property (nonatomic, copy) NSString *suggest;
@property (nonatomic, strong) NSNumber *reportStatus;

//合并答题报告字段
@property(nonatomic, strong) NSNumber *isMergeAnswer;
@property(nonatomic, copy) NSString *subTitle;
@property(nonatomic, copy) NSArray <NSString *> *results;
@property(nonatomic, copy) NSString *subItemId;
@property(nonatomic, copy) NSArray <CareerReportDataModel *> *subReport;

//推荐商品 请求后赋值

@property (nonatomic, strong) TCTestReportRecommendProductModel *recommendProductData;

@end

NS_ASSUME_NONNULL_END
