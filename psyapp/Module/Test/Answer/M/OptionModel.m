//
//  OptionModel.m
//  smartapp
//
//  Created by lafang on 2018/8/16.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "OptionModel.h"

@implementation OptionModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"optionId":@"option_id",
             @"questionId":@"question_id",
             @"type":@"type",
             @"score":@"score",
             @"content":@"content",
             @"showValue":@"show_value",
             @"orderby":@"orderby",
             };
}

@end
