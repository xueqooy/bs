//
//  QuestionBaseModel.m
//  smartapp
//
//  Created by lafang on 2018/8/16.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEQuestionModel.h"

@implementation FEQuestionModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"questionID":@"question_id",
             @"factorID":@"factor_id",
             @"type":@"type",
             @"stem":@"stem",
             @"showType":@"show_type",
             @"orderby":@"orderby",
             @"childFactorID":@"child_factor_id",
             @"options":@"options",
             @"childQuestion":@"child_question"
             };
}

//指向一个array的映射
+ (NSValueTransformer *)optionsJSONTransformer {

    return [MTLJSONAdapter arrayTransformerWithModelClass:OptionModel.class];
    
}


//指向一个dict的映射
+ (NSValueTransformer*)childQuestionJSONTransformer{
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:QuestionChildModel.class];
    
}

@end
