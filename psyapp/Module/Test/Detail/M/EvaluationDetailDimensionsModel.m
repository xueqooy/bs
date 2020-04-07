//
//  EvaluationDetailDimensionsModel.m
//  smartapp
//
//  Created by mac on 2019/7/26.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "EvaluationDetailDimensionsModel.h"

@implementation EvaluationDetailDimensionMergeResultModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
         @"result" : @"result",
         @"isBadTendency" : @"is_bad_tendency"
    };
}
@end


@implementation EvaluationDetailDimensionsModel
- (instancetype)init {
    self = [super init];
    self.retestRemainTime = -999;
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"examID" : @"exam_id",
             @"topicDimensionID" : @"topic_dimension_id",
             @"childDimensionID" : @"child_dimension_id",
             @"dimensionID" : @"dimension_id",
             @"dimensionName" : @"dimension_name",
             @"reportForbid" : @"report_forbid",
             @"topicId":@"topic_id",
             @"descriptionD":@"description",
             @"instruction":@"instruction",
             @"backgroundImage":@"background_image",
             @"useCount":@"use_count",
             @"questionCount":@"question_count",
             @"estimatedTime":@"estimated_time",
             @"costTime":@"cost_time",
             @"isDuplicate":@"is_duplicate",
             @"isLocked":@"is_locked",
             @"status" : @"status",
             @"score" : @"score",
             @"result" : @"result",
             @"isBadTendency" : @"is_bad_tendency",
             @"reportStatus" : @"report_status",
             @"reportForbidHint" : @"report_forbid_hint",
             @"isMergeAnswer" : @"is_merge_answer",
             @"results" : @"results",
             @"isOwn" : @"is_own",
             @"price" : @"price",
             @"originPrice" : @"price_original",
             @"productId" : @"product_id",
             @"targetUser" : @"target_user",
             @"gain" : @"gain",
             @"whatTest" : @"what_test",
             @"finishTime" : @"finish_time",
             @"retestGap" : @"retest_gap"
             };
}

- (CGFloat)priceYuan {
    if (_price) {
        return _price.floatValue / 100;
    } else {
        return 0;
    }
}

- (CGFloat)originPriceYuan {
    if (_originPrice) {
        return _originPrice.floatValue / 100;
    } else {
        return 0;
    }
}

+ (NSValueTransformer *)resultsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:EvaluationDetailDimensionMergeResultModel.class];
}

@end
