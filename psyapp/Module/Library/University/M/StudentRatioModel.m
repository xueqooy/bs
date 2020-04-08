//
//  StudentRatioModel.m
//  smartapp
//
//  Created by lafang on 2019/3/16.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "StudentRatioModel.h"

@implementation StudentRatioModel

//"university_id": "i7e2ylaqujabyy6h",
//"women_ratio": 0.34,//女
//"men_ratio": 0.66, //男
//"students_total": 16285//总人数

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"universityId":@"university_id",
             @"womenRatio":@"women_ratio",
             @"menRatio":@"men_ratio",
             @"studentsTotal":@"students_total",
             };
}

@end
