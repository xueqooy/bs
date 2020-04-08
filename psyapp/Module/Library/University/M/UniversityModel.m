//
//  UniversityModel.m
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityModel.h"

@implementation UniversityModel

//@"china_degree" : @"本科"
//@"city_data" : @"北京"

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"universityId":@"id",
             @"basicInfo":@"basic_info",
             @"logoUrl":@"logo_url",
             @"backgroundImg":@"background_img",
             @"cnName":@"cn_name",
             @"enName":@"en_name",
             @"ranking":@"ranking",
             @"chinaDegree":@"china_degree",
             @"cityData":@"city_data",
             @"state":@"state",
             @"majorInfo":@"major_info"
             };
}


+ (NSValueTransformer *)basicInfoJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:UniversityBasicInfoModel.class];
    
}

+ (NSValueTransformer *)majorInfoJSONTransformer {

    return [MTLJSONAdapter dictionaryTransformerWithModelClass:UniversityMajorInfoModel.class];

}

@end
