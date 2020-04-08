//
//  ProfessionalOccupationsModel.h
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessionalOccupationsModel : FEBaseModel

//"occupation_name":"string", //职业名称
//"occupation_id":"string"    //职业ID

@property(nonatomic,strong) NSString *occupationName;
@property(nonatomic,strong) NSNumber *occupationId;

@end

NS_ASSUME_NONNULL_END
