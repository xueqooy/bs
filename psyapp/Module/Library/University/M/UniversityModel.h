//
//  UniversityModel.h
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "UniversityBasicInfoModel.h"
#import "UniversityRankingModel.h"
#import "UniversityMajorInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityModel : FEBaseModel

//"cn_name": "清华大学",
//"basic_info": {
//    "public_or_private": "public",
//    "china_belong_to": "教育部直属",
//    "institute_quality": ["985", "双一流", "C9"],
//    "institute_type": "综合类"
//},
//"logo_url": "http://cdn.applysquare.net/a2/institute/cn.tsinghua/logo.png",
//"background_img": "",
//"en_name": "Tsinghua University",
//"ranking": {
//@"china_degree" : @"本科"
//@"city_data" : @"北京"

@property(nonatomic,strong) NSString *universityId;
@property(nonatomic,strong) UniversityBasicInfoModel *basicInfo;
@property(nonatomic,strong) NSString *logoUrl;
@property(nonatomic,strong) NSString *backgroundImg;
@property(nonatomic,strong) NSString *cnName;
@property(nonatomic,strong) NSString *enName;
//@property(nonatomic,strong) UniversityRankingModel *ranking;
@property(nonatomic,strong) NSDictionary *ranking;//不解析成model,方便通过key取值
@property(nonatomic,strong) NSString *chinaDegree;
@property(nonatomic,strong) NSString *cityData;
@property(nonatomic,strong) NSString *state;

@property(nonatomic,strong)UniversityMajorInfoModel *majorInfo;

@end

NS_ASSUME_NONNULL_END
