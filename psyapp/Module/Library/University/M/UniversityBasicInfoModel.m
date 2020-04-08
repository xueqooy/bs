//
//  UniversityBasicInfoModel.m
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityBasicInfoModel.h"

@implementation UniversityBasicInfoModel

//@property(nonatomic,strong) NSString *publicOrPrivate;
//@property(nonatomic,strong) NSString *chinaBelongTo;
//@property(nonatomic,strong) NSString *instituteQuality;
//@property(nonatomic,strong) NSString *instituteType;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"publicOrPrivate":@"public_or_private",
             @"chinaBelongTo":@"china_belong_to",
             @"instituteQuality":@"institute_quality",
             @"instituteType":@"institute_type",
             };
}

@end
