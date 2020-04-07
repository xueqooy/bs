//
//  CareerChartDataChildModel.h
//  smartapp
//
//  Created by lafang on 2019/3/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CareerChartDataChildModel : FEBaseModel

//"item_id":"uuid",       //量表或因子ID
//"item_name":"string",   //量表或因子名称
//"score":50.5            //得分

@property(nonatomic,strong)NSString *itemId;
@property(nonatomic,strong)NSString *itemName;
@property(nonatomic,strong)NSNumber *score;

@end

NS_ASSUME_NONNULL_END
