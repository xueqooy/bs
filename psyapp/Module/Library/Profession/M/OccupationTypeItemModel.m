//
//  OccupationTypeItemModel.m
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "OccupationTypeItemModel.h"

@implementation OccupationTypeItemModel

//"category":"string",        //行业 - 分类
//"area_name":"stirng",       //ACT - 26种职业区域名称
//"area_id":1                 //ACT - 职业区域ID

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"category":@"category",
             @"areaName":@"area_name",
             @"areaId":@"area_id",
             };
}

@end
