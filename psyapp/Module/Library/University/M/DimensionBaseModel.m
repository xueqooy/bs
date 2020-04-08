//
//  DimensionBaseModel.m
//  smartapp
//
//  Created by lafang on 2018/8/16.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "DimensionBaseModel.h"

@implementation DimensionBaseModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"topicDimensionId":@"topic_dimension_id",
             @"dimensionId":@"dimension_id",
             @"topicId":@"topic_id",
             @"dimensionName":@"dimension_name",
             @"algorithm":@"algorithm",
             @"orderby":@"orderby",
             @"factorCount":@"factor_count",
             @"definition":@"definition",
             @"descriptionD":@"description",
             @"icon":@"icon",
             @"unlockFlowers":@"unlock_flowers",
             @"useCount":@"use_count",
             @"flowers":@"flowers",
             @"suitableUser":@"suitable_user",
             @"appraisalType":@"appraisal_type",
             @"preDimensions":@"pre_dimensions",
             @"isLocked":@"is_locked",
             @"childDimension":@"child_dimension",
             @"questionCount":@"question_count",
             @"estimatedTime":@"estimated_time",
             @"backgroundImage":@"background_image",
             @"backgroundColor":@"background_color",
             @"isDuplicate":@"is_duplicate",
             @"examId":@"exam_id",
             @"instruction":@"instruction",
             @"reportForbid" : @"report_forbid",
             @"status" : @"status",
             @"childDimensionId" : @"child_dimension_id",
             @"reportStatus" : @"report_status",
             @"reportForbidHint" : @"report_forbid_hint"
             };
}

+ (NSValueTransformer *)childDimensionJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:DimensionChildModel.class];
    
}

@end
