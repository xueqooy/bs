//
//  OccupationTypeModel.h
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "OccupationTypeItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OccupationTypeModel : FEBaseModel

//"realm":"string",                   //行业 - 领域
//"personality_type":"string",        //ACT - 六大人格分类
//"sub_items":[

@property(nonatomic,strong)NSString *realm;
@property(nonatomic,strong)NSString *personalityType;
@property(nonatomic,strong)NSArray *subItems;

@end

NS_ASSUME_NONNULL_END
