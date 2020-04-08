//
//  UniversityGraduationModel.m
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityGraduationModel.h"

@implementation UniversityGraduationModel

//@property(nonatomic,strong)NSString *universityId;
//@property(nonatomic,strong)NSString *fiveYearSalary;
//@property(nonatomic,strong)NSArray *overall;
//@property(nonatomic,strong)NSArray *settled;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"universityId":@"university_id",
             @"fiveYearSalary":@"five_year_salary",
             @"overall":@"overall",
             @"settled":@"settled",
             };
}


+ (NSValueTransformer *)overallJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:UniversityGrduationOverallModel.class];
}

+ (NSValueTransformer *)settledJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:UniversityGraduationSettledModel.class];
}

@end
