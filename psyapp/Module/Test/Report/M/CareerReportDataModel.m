//
//  CareerReportDataModel.m
//  smartapp
//
//  Created by lafang on 2019/3/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "CareerReportDataModel.h"

@implementation CareerReportDataModel

//"compare_name":"string",    //对比样本名称
//"description":"string",     //场景描述
//"result":"string",          //测评结果（场景下不一定有总体测评结果）
//"score":50.5,               //测评得分（原始分或者T分数，场景下不一定有总体得分）
//"sub_result":["string"],        //子维度测评结果的集合（对于场景下没有设定总体结果的情况，用这个字段显示）
//"rank":90,                  //超过%90的用户（测评得分是原始分就没有排名）
//"appraisal":"string",           //评价（测评得分是原始分就没有评价）
//"chart_datas": [
//"sub_items":[

//"vice_result":"",           //典型形像（MBTI）
//"mbti_date":[
// "recommend":[   //MBTI推荐数据

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"title":@"title",
             @"compareName":@"compare_name",
             @"dDescription":@"description",
             @"result":@"result",
             @"score":@"score",
             @"subResult":@"sub_result",
             @"rank":@"rank",
             @"appraisal":@"appraisal",
             @"chartType":@"chart_type",
             @"chartDatas":@"chart_datas",
             @"subItems":@"sub_items",
             @"viceResult":@"vice_result",
             @"mbtiDate":@"mbti_date",
             @"recommend":@"recommend",
             @"isBadTendency" : @"is_bad_tendency",
             @"maxScore" : @"max_score",
             @"minScore" : @"min_score",
             @"trend" : @"trend",
             @"suggest" : @"suggest",
             @"reportStatus" : @"report_status",
             @"isMergeAnswer" : @"is_merge_answer",
             @"subTitle" : @"sub_title",
             @"results" : @"results",
             @"subItemId" : @"sub_item_id",
             @"subReport" : @"sub_report"
             };
}

+ (NSValueTransformer *)chartDatasJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:CareerChartDataModel.class];
}

+ (NSValueTransformer *)subItemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:CareerSubItemsModel.class];
}

+ (NSValueTransformer *)mbtiDateJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:MbtiDateModel.class];
}

+ (NSValueTransformer *)recommendJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:MbtiRecommendModel.class];
}

+ (NSValueTransformer *)subReportJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:CareerReportDataModel.class];
}

- (void)setRecommendProductData:(TCTestReportRecommendProductModel *)recommendProductData {
    _recommendProductData = recommendProductData;
    for (CareerReportDataModel *subReportItem in self.subReport) {
        subReportItem.recommendProductData = _recommendProductData;
    }
    
}
@end
