//
//  UniversityMajorInfoModel.m
//  smartapp
//
//  Created by lafang on 2019/4/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityMajorInfoModel.h"

@implementation UniversityMajorInfoModel

//@property(nonatomic,strong)NSString *assessmentLevel;
//@property(nonatomic,strong)NSString *majorName;
//@property(nonatomic,strong)NSNumber *majorType;
//@property(nonatomic,strong)NSNumber *mid;
//@property(nonatomic,strong)NSString *typeName;
//@property(nonatomic,strong)NSString *specialName;
//@property(nonatomic,strong)NSString *universityName;
//@property(nonatomic,strong)NSNumber *year;
//@property(nonatomic,strong)NSString *majorCode;
//@property(nonatomic,strong)NSString *universityId;

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"assessmentLevel":@"assessment_level",
             @"majorName":@"major_name",
             @"majorType":@"major_type",
             @"mid":@"mid",
             @"typeName":@"type_name",
             @"specialName":@"special_name",
             @"universityName":@"university_name",
             @"year":@"year",
             @"majorCode":@"major_code",
             @"universityId":@"university_id",
             @"subjectsRequired":@"subjects_required"
             };
}



@end
