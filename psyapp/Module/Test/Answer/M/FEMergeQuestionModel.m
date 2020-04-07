//
//  FEMergeAnswerModel.m
//  smartapp
//
//  Created by mac on 2019/11/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEMergeQuestionModel.h"
@implementation FEMergeSubquestionAnswerModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"optionID" : @"option_id",
             @"optionText" : @"option_text"
             };
}
@end

@implementation FEMergeSubquestionOptionModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"optionID" : @"option_id",
             @"content" : @"content"
             };
}

@end

@implementation FEMergeSubquestionModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"childFactorID" : @"child_factor_id",
             @"subStem" : @"sub_stem",
             @"answers" : @"answers",
             };
}


@end

@implementation FEMergeQuestionModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"questionID" : @"question_id",
             @"stem" : @"stem",
             @"type" : @"type",
             @"options" : @"options",
             @"subQuestions" : @"sub_questions",
             };
}

+ (NSValueTransformer *)subQuestionsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:FEMergeSubquestionModel.class];
}

+ (NSValueTransformer *)optionsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:FEMergeSubquestionOptionModel.class];
}
@end
