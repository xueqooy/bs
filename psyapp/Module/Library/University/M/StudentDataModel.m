//
//  StudentDataModel.m
//  smartapp
//
//  Created by lafang on 2019/3/16.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "StudentDataModel.h"

@implementation StudentDataModel

//"university_id": "i7e2ylaqujabyy6h",
//"international_students": 2423,//国际学生人数
//"undergraduate_students": 16285,//本科生数量
//"postgraduates_students": 14728//研究生数量

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"universityId":@"university_id",
             @"internationalStudents":@"international_students",
             @"undergraduateStudents":@"undergraduate_students",
             @"postgraduatesStudents":@"postgraduates_students",
             };
}

@end
