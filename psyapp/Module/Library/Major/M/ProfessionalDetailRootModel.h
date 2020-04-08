//
//  ProfessionalDetailRootModel.h
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "ProfessionalIntroducesModel.h"
#import "ProfessionalOccupationsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessionalDetailRootModel : FEBaseModel

//"major_name":"string",
//"major_code":"string",
//"degree":"string",
//"learn_year":4,
//"subject":"string",
//"category":"string",
//"course":"string",        //开设课程
//"introduces":[                      //专业介绍
//"occupations":[                 //职业列表
//"employment":"string"           //就业方向

@property(nonatomic,strong)NSString *majorName;
@property(nonatomic,strong)NSString *majorCode;
@property(nonatomic,strong)NSString *degree;
@property(nonatomic,strong)NSNumber *learnYear;
@property(nonatomic,strong)NSString *subject;
@property(nonatomic,strong)NSString *category;
@property(nonatomic,strong)NSString *course;
@property(nonatomic,strong)NSArray *introduces;
@property(nonatomic,strong)NSArray *occupations;
@property(nonatomic,strong)NSString *employment;
@property(nonatomic,strong)NSNumber *isFollow;


@end

NS_ASSUME_NONNULL_END
