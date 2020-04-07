//
//  JudgeItemModel.m
//  smartapp
//
//  Created by lafang on 2019/4/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "JudgeItemModel.h"

@implementation JudgeItemModel

//@property(nonatomic,strong)NSString *evaluate_title_id;
//@property(nonatomic,strong)NSString *content;
//@property(nonatomic,strong)NSNumber *value;
//@property(nonatomic,assign)BOOL *is_evaluate;

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"optionId":@"id",
             @"evaluateTitleId":@"evaluate_title_id",
             @"content":@"content",
             @"value":@"value",
             @"isEvaluate":@"is_evaluate",
             };
    
}

@end
