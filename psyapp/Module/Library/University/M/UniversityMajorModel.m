//
//  UniversityMajorModel.m
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityMajorModel.h"

@implementation UniversityMajorModel

//"id": 2008,
//"university_id": "i7e2ylaqujabyy6h",
//"university_name": "天津大学",
//"major_name": "材料成型及控制工程",
//"major_code": "080203",
//"major_type": 1,
//"special_name": "材料成型及控制工程",
//"type_name": "本科",
//"year": 2019,
//"assessment_level": null

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"majorId":@"id",
             @"universityId":@"university_id",
             @"universityName":@"university_name",
             @"majorName":@"major_name",
             @"majorCode":@"major_code",
             @"majorType":@"major_type",
             @"specialName":@"special_name",
             @"typeName":@"type_name",
             @"year":@"year",
             @"assessmentLevel":@"assessment_level",
             };
}


@end
