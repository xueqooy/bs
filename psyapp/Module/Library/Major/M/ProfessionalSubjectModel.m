//
//  ProfessionalSubjectModel.m
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalSubjectModel.h"

@implementation ProfessionalSubjectModel

//"subject":"string", //所属学科
//"categorys":[

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"subject":@"subject",
             @"categorys":@"categorys",
             };
}

+ (NSValueTransformer *)categorysJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ProfessionalModel.class];
}

@end
