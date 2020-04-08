//
//  UniversityGrduationOverallModel.m
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityGrduationOverallModel.h"

@implementation UniversityGrduationOverallModel

//@property(nonatomic,strong)NSNumber *overallId;
//@property(nonatomic,strong)NSString *universityId;
//@property(nonatomic,strong)NSString *degree;
//@property(nonatomic,strong)NSString *type;
//@property(nonatomic,strong)NSNumber *ratio;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"overallId":@"id",
             @"universityId":@"university_id",
             @"type":@"type",
             @"degree":@"degree",
             @"ratio":@"ratio",
             };
}

@end
