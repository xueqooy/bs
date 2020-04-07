//
//  JudgeModel.m
//  smartapp
//
//  Created by lafang on 2019/4/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "JudgeModel.h"

@implementation JudgeModel

//@property(nonatomic,strong)NSString *title;
//@property(nonatomic,assign)BOOL *isEvaluate;
//@property(nonatomic,strong)NSArray *items;

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"title":@"title",
             @"isEvaluate":@"is_evaluate",
             @"items":@"items",
             };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:JudgeItemModel.class];
    
}

@end
