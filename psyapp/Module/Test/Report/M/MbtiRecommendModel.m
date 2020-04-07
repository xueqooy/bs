//
//  MbtiRecommendModel.m
//  smartapp
//
//  Created by lafang on 2019/3/24.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "MbtiRecommendModel.h"

@implementation MbtiRecommendModel

//"area_id":12,               //职业区域ID
//"area_name":"string"        //职业区域名称

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"areaId":@"area_id",
             @"areaName":@"area_name",
             };
}

@end
