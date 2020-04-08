//
//  ProfessionalCategoryModel.m
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalCategoryModel.h"

@implementation ProfessionalCategoryModel

//"major_code":"stirng",      //专业代码
//"major_name":"string"       //专业名称

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"majorCode":@"major_code",
             @"majorName":@"major_name",
             };
}

@end
