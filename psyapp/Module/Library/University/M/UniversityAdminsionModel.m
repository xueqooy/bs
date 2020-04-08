//
//  UniversityAdminsionModel.m
//  smartapp
//
//  Created by lafang on 2019/4/1.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityAdminsionModel.h"

@implementation UniversityAdminsionModel

//@property(nonatomic,strong) NSString *batch;
//@property(nonatomic,strong) NSString *bkcc;
//@property(nonatomic,strong) NSString *kind;
//@property(nonatomic,strong) NSString *lowScore;
//@property(nonatomic,strong) NSString *lowWc;
//@property(nonatomic,strong) NSString *luquNum;
//@property(nonatomic,strong) NSString *mark;
//@property(nonatomic,strong) NSString *provinceScore;
//@property(nonatomic,strong) NSString *school;
//@property(nonatomic,strong) NSString *year;
//@property(nonatomic,strong) NSString *provinceSchool;
//@property(nonatomic,strong) NSString *school;
//@property(nonatomic,strong) NSString *uaid;

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"batch":@"batch",
             @"bkcc":@"bkcc",
             @"kind":@"kind",
             @"lowScore":@"low_score",
             @"lowWc":@"low_wc",
             @"luquNum":@"luqu_num",
             @"mark":@"mark",
             @"provinceScore":@"province_score",
             @"year":@"year",
             @"school":@"school",
             @"provinceSchool":@"province_school",
             @"uaid":@"id",
             @"province":@"province",
             };
}

@end
