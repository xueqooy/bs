//
//  CareerChartDataModel.h
//  smartapp
//
//  Created by lafang on 2019/3/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "CareerChartDataItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CareerChartDataModel : FEBaseModel

//"chart_item_id":"string",       //当前chart的主题或量表ID
//"chart_item_name":"String",     //当前chart的主题或量表名称
//"chart_type":1,             //图表类型，1-雷达图，2-曲线图，3-柱状图，4-条状图
//"score_type":1,             //分数类型，1-T分数，2-百分位分数，3-原始分
//"min_score":1,              //最小分数
//"max_score":1,              //最大分数
//"chart_description":"string",   //图表说明
//"items":[   //图表中的数据项

@property(nonatomic,strong)NSString *chartItemId;
@property(nonatomic,strong)NSString *chartItemName;
@property(nonatomic,strong)NSNumber *chartType;
@property(nonatomic,strong)NSNumber *scoreType;
@property(nonatomic,strong)NSNumber *minScore;
@property(nonatomic,strong)NSNumber *maxScore;
@property(nonatomic,strong)NSString *chartDescription;
@property(nonatomic,strong)NSArray *items;

@property(nonatomic,assign) BOOL isShowChartDesc;//是否展开报表说明

@end

NS_ASSUME_NONNULL_END
