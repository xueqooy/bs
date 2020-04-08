//
//  DimensionChildModel.m
//  smartapp
//
//  Created by lafang on 2018/8/16.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "DimensionChildModel.h"

@implementation DimensionChildModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"childDimensionId":@"id",
             @"examId":@"exam_id",
             @"childExamId":@"child_exam_id",
             @"childId":@"child_id",
             @"childTopicId":@"child_topic_id",
             @"dimensionId":@"dimension_id",
             @"userId":@"user_id",
             @"costTime":@"cost_time",
             @"status":@"status",
             @"createTime":@"create_time",
             @"updateTime":@"update_time",
             @"completeFactorCount":@"complete_factor_count",
             @"flowers":@"flowers",
             @"reportStatus": @"report_status"
             };
}


@end
