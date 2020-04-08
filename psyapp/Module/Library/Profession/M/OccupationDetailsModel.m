//
//  OccupationDetailsModel.m
//  smartapp
//
//  Created by lafang on 2019/3/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "OccupationDetailsModel.h"

@implementation OccupationDetailsModel

//@property(nonatomic,strong)NSString *occupationName;
//@property(nonatomic,strong)NSString *occupationId;
//@property(nonatomic,strong)NSString *realm;
//@property(nonatomic,strong)NSString *category;
//@property(nonatomic,strong)ProfessionalIntroducesModel *introduces;
//@property(nonatomic,strong)ProfessionalCategoryModel *majors;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"occupationName":@"occupation_name",
             @"occupationId":@"occupation_id",
             @"realm":@"realm",
             @"category":@"category",
             @"introduces":@"introduces",
             @"majors":@"majors",
             @"isFollow":@"is_follow"
             };
}

+ (NSValueTransformer *)introducesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ProfessionalIntroducesModel.class];
}

+ (NSValueTransformer *)majorsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ProfessionalCategoryModel.class];
}

@end
