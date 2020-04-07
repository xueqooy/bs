//
//  MbtiRecommendModel.h
//  smartapp
//
//  Created by lafang on 2019/3/24.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MbtiRecommendModel : FEBaseModel

//"area_id":12,               //职业区域ID
//"area_name":"string"        //职业区域名称

@property(nonatomic,strong)NSString *areaId;
@property(nonatomic,strong)NSString *areaName;

@end

NS_ASSUME_NONNULL_END
