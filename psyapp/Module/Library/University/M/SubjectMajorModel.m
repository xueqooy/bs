//
//  SubjectMajorModel.m
//  smartapp
//
//  Created by lafang on 2019/3/27.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "SubjectMajorModel.h"

@implementation SubjectMajorModel

//"major_name": "1",
//"major_code": "机械设计制造",
//"from_types": "1", //推荐来源 1 高考学科推荐 2 MBTI性格测试 3 职业兴趣 4 工作价值观
//"required_subjects": "1004||1005||1006",//要求的学科组合，举例： 1004||1004,1005||1005|1006 这个代表有三种组合要求，用||分隔，每种组合里面用逗号分隔的代表要同时满足，用|分隔的代表符合一个即可
//"require_university_num":"1||2||4", //有学科要求的学校数量 1||2||4 这个和required_subjects 一一对应，顺序也一样

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"majorName":@"major_name",
             @"majorCode":@"major_code",
             @"fromTypes":@"from_types",
             @"requireSubjects":@"require_subjects",
             @"requireUniversityNum":@"require_university_num",
             };
}

@end
