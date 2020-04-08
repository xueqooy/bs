//
//  UniversitySituationModel.m
//  smartapp
//
//  Created by lafang on 2019/3/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversitySituationModel.h"

@implementation UniversitySituationModel

//@property(nonatomic,strong) StudentDataModel *studentData;
//@property(nonatomic,strong) StudentRatioModel *studentRatio;
//@property(nonatomic,strong) NSString *brief_introduction;
//@property(nonatomic,strong) UniversityBasicInfoModel *basic_info;
//@property(nonatomic,strong) UniversityRankingModel *ranking;
//@property(nonatomic,strong) UniverSitynameItemModel *advantage_specialty;//优势专业
//@property(nonatomic,strong) UniverSitynameItemModel *famous_alumni;//知名校友
//@property(nonatomic,strong) UniverSitynameItemModel *faculty_strength;//师资力量
//@property(nonatomic,strong) UniverSitynameItemModel *scientific_institution;//科研机构

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"studentData":@"student_data",
             @"studentRatio":@"student_ratio",
             @"briefIntroduction":@"brief_introduction",
             @"basicInfo":@"basic_info",
             @"ranking":@"ranking",
             @"advantageSpecialty":@"advantage_specialty",
             @"famousAlumni":@"famous_alumni",
             @"facultyStrength":@"faculty_strength",
             @"scientificInstitution":@"scientific_institution",
             @"isFollow":@"is_follow"
             };
}

+ (NSValueTransformer *)basicInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:UniversityBasicInfoModel.class];
}

//+ (NSValueTransformer *)rankingJSONTransformer {
//    return [MTLJSONAdapter dictionaryTransformerWithModelClass:UniversityRankingModel.class];
//}

+ (NSValueTransformer *)advantageSpecialtyJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:UniverSitynameItemModel.class];
}

+ (NSValueTransformer *)rankingJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:UniversityRankingItemModel.class];
}

+ (NSValueTransformer *)facultyStrengthJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:UniverSitynameItemModel.class];
}
+ (NSValueTransformer *)scientificInstitutionJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:UniverSitynameItemModel.class];
}

+ (NSValueTransformer *)studentDataJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:StudentDataModel.class];
}

+ (NSValueTransformer *)studentRatioJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:StudentRatioModel.class];
}







@end
