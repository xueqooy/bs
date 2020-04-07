//
//  QuestionChildModel.m
//  smartapp
//
//  Created by lafang on 2018/8/16.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "QuestionChildModel.h"

@implementation QuestionChildModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"qid":@"id",
             @"examId":@"exam_id",
             @"userId":@"user_id",
             @"childId":@"child_id",
             @"childFactorId":@"child_factor_id",
             @"questionId":@"question_id",
             @"optionId":@"option_id",
             @"optionText":@"option_text",
             };
}

@end
