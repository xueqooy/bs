//
//  ProfessionalAdminsionModel.m
//  smartapp
//
//  Created by lafang on 2019/4/1.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalAdminsionModel.h"

@implementation ProfessionalAdminsionModel

//@property(nonatomic,strong)NSNumber *paid;
//@property(nonatomic,strong)NSString *batch;
//@property(nonatomic,strong)NSNumber *lowWc;
//@property(nonatomic,strong)NSString *major;
//@property(nonatomic,strong)NSString *school;
//@property(nonatomic,strong)NSString *province;
//@property(nonatomic,strong)NSNumber *lowScore;
//@property(nonatomic,strong)NSNumber *averageScore;
//@property(nonatomic,strong)NSNumber *luquNum;
//@property(nonatomic,strong)NSNumber *high_score;
//@property(nonatomic,strong)NSNumber *year;
//@property(nonatomic,strong)NSString *provinceSchool;
//@property(nonatomic,strong)NSString *kind;
//@property(nonatomic,strong)NSString *mark;
//@property(nonatomic,strong)NSString *bkcc;

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"paid":@"id",
             @"batch":@"batch",
             @"lowWc":@"low_wc",
             @"major":@"major",
             @"school":@"school",
             @"province":@"province",
             @"lowScore":@"low_score",
             @"averageScore":@"average_score",
             @"luquNum":@"luqu_num",
             @"highScore":@"high_score",
             @"year":@"year",
             @"provinceSchool":@"province_school",
             @"kind":@"kind",
             @"mark":@"mark",
             @"bkcc":@"bkcc",
             };
}

@end
