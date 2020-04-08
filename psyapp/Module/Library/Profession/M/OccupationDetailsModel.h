//
//  OccupationDetailsModel.h
//  smartapp
//
//  Created by lafang on 2019/3/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "ProfessionalIntroducesModel.h"
#import "ProfessionalCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OccupationDetailsModel : FEBaseModel

//"occupation_id":"string",           //职业ID
//"occupation_name":"string",         //职业名称
//"realm":"string",                   //行业领域
//"category":"string",                //职业类型
//"introduces":[                      //职业介绍
//"majors":[                          //对口专业

@property(nonatomic,strong)NSString *occupationName;
@property(nonatomic,strong)NSNumber *occupationId;
@property(nonatomic,strong)NSString *realm;
@property(nonatomic,strong)NSString *category;
@property(nonatomic,strong)NSArray *introduces;
@property(nonatomic,strong)NSArray *majors;
@property(nonatomic,strong)NSNumber *isFollow;


@end

NS_ASSUME_NONNULL_END
