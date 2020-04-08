//
//  OccupationTypeItemModel.h
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OccupationTypeItemModel : FEBaseModel

//"category":"string",        //行业 - 分类
//"area_name":"stirng",       //ACT - 26种职业区域名称
//"area_id":1                 //ACT - 职业区域ID

@property(nonatomic,strong) NSString *category;
@property(nonatomic,strong) NSString *areaName;
@property(nonatomic,strong) NSNumber *areaId;

@end

NS_ASSUME_NONNULL_END
