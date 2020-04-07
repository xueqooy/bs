//
//  CareerSubItemsModel.m
//  smartapp
//
//  Created by lafang on 2019/3/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "CareerSubItemsModel.h"

@implementation CareerSubItemsModel

//"item_name":"string",       //项目名称
//"item_id":"string",         //项目ID
//"result":"string",          //测评结果
//"score":50.5,               //测评得分（原始分或者T分数）
//"rank":90,                  //超过%90的用户
//"description":"string"      //项目描述

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"itemName":@"item_name",
             @"itemId":@"item_id",
             @"result":@"result",
             @"score":@"score",
             @"rank":@"rank",
             @"pDescription":@"description",
             @"appraisal" : @"appraisal",
             @"isBadTendency" : @"is_bad_tendency",
             @"maxScore" : @"max_score",
             @"minScore" : @"min_score",
             @"trend" : @"trend",
             @"suggest" : @"suggest"
             };
}

@end
