//
//  ProfessionalModel.m
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalModel.h"

@implementation ProfessionalModel

//"category":"string",        //专业门类
//"majors":[

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"category":@"category",
             @"majors":@"majors",
             };
}

+ (NSValueTransformer *)majorsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ProfessionalCategoryModel.class];
}


@end
