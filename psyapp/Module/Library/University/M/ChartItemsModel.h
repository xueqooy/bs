//
//  ChartItemsModel.h
//  smartapp
//
//  Created by lafang on 2018/9/4.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

@interface ChartItemsModel : FEBaseModel

@property(nonatomic,strong) NSString *itemId;
@property(nonatomic,strong) NSString *itemName;
@property(nonatomic,strong) NSNumber *compareScore;
@property(nonatomic,strong) NSNumber *childScore;

@end
