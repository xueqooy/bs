//
//  ReportResultsModel.m
//  smartapp
//
//  Created by lafang on 2018/9/4.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "ReportResultsModel.h"

@implementation ReportResultsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"header":@"header",
             @"relationId":@"relation_id",
             @"result":@"result",
             @"content":@"content",
             @"title":@"title",
             @"color":@"color",
             @"descriptionChart":@"description",
             @"factorResult":@"factor_result",
             };
}

+ (NSValueTransformer *)factorResultJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:FactorResultModel.class];
}

@end
