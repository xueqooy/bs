//
//  ProfessionalModel.h
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "ProfessionalCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessionalModel : FEBaseModel

//"category":"string",        //专业门类
//"majors":[

@property(nonatomic,strong) NSString *category;
@property(nonatomic,strong) NSArray *majors;

@property(nonatomic,assign)BOOL isShow;//是否展开子级列表

@end

NS_ASSUME_NONNULL_END
