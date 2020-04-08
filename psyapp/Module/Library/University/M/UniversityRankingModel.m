//
//  UniversityRankingModel.m
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityRankingModel.h"

@implementation UniversityRankingModel

//"arwu": 45,
//"cn_zonghelei15": 0,
//"qs": 17,
//"cn_yuyanlei15": 0,
//"cn_caijinglei15": 0,
//"cn_yishulei15": 0,
//"cn_zhengfalei15": 0,
//"cn_minzulei15": 0,
//"usnews_global": 50,
//"cn_shifanlei15": 0,
//"cn_yiyaolei15": 0,
//"cn_nonglinlei15": 0,
//"cn_zhuanke16": 0,
//"times": 22,
//"applysq": 0,
//"cn_ligonglei15": 1,
//"cn_china15": 2,
//"usnews": 0,
//"cn_tiyulei15": 0,
//"fortune500": 0

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"arwu":@"arwu",
             @"cnZonghelei15":@"cn_zonghelei15",
             @"qs":@"qs",
             @"cnYuyanlei15":@"cn_yuyanlei15",
             @"cnCaijinglei15":@"cn_caijinglei15",
             @"cnYishulei15":@"cn_yishulei15",
             @"cnZhengfalei15":@"cn_zhengfalei15",
             @"cnMinzulei15":@"cn_minzulei15",
             @"usnewsGlobal":@"usnews_global",
             @"cnShifanlei15":@"cn_shifanlei15",
             @"cnYiyaolei15":@"cn_yiyaolei15",
             @"cnNonglinlei15":@"cn_nonglinlei15",
             @"cnZhuanke16":@"cn_zhuanke16",
             @"times":@"times",
             @"applysq":@"applysq",
             @"cnLigonglei15":@"cn_ligonglei15",
             @"cnChina15":@"cn_china15",
             @"usnews":@"usnews",
             @"cnTiyulei15":@"cn_tiyulei15",
             @"fortune500":@"fortune500",
             };
}

@end
