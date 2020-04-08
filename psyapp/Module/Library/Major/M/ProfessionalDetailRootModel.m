//
//  ProfessionalDetailRootModel.m
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalDetailRootModel.h"

@implementation ProfessionalDetailRootModel

//"major_name":"string",
//"major_code":"string",
//"degree":"string",
//"learn_year":4,
//"subject":"string",
//"category":"string",
//"learn_course":"string",        //开设课程
//"introduces":[                      //专业介绍
//"occupations":[                 //职业列表
//"employment":"string"           //就业方向

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"majorName":@"major_name",
             @"majorCode":@"major_code",
             @"degree":@"degree",
             @"learnYear":@"learn_year",
             @"subject":@"subject",
             @"category":@"category",
             @"course":@"course",
             @"introduces":@"introduces",
             @"occupations":@"occupations",
             @"employment":@"employment",
             @"isFollow":@"is_follow"
             };
}

+ (NSValueTransformer *)introducesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ProfessionalIntroducesModel.class];
}

+ (NSValueTransformer *)occupationsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ProfessionalOccupationsModel.class];
}

@end
