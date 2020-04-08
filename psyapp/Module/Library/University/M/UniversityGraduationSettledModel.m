//
//  UniversityGraduationSettledModel.m
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityGraduationSettledModel.h"

@implementation UniversityGraduationSettledModel

//"id": 107,
//"university_id": "i7e2ylaqujabyy6h",
//"degree_name": "phd",
//"degree": "博士生",
//"ratio": 0.9768

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"settledId":@"id",
             @"universityId":@"university_id",
             @"degreeName":@"degree_name",
             @"degree":@"degree",
             @"ratio":@"ratio",
             };
}

@end
