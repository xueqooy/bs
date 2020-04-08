//
//  UniversityKeySubjectModel.m
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityKeySubjectModel.h"

@implementation UniversityKeySubjectModel

//"type": "国家重点学科",
//"name": "一级学科国家重点学科",
//"total": 7,
//"items":

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"type":@"type",
             @"name":@"name",
             @"total":@"total",
             @"items":@"items",
             };
}

@end
