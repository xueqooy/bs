//
//  ProfessionalCategoryModel.h
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessionalCategoryModel : FEBaseModel

//"major_code":"stirng",      //专业代码
//"major_name":"string"       //专业名称

@property(nonatomic,strong) NSString *majorCode;
@property(nonatomic,strong) NSString *majorName;

@end

NS_ASSUME_NONNULL_END
