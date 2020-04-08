//
//  ChartItemDataModel.h
//  smartapp
//
//  Created by lafang on 2018/12/11.
//  Copyright © 2018 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

@interface ChartItemDataModel : FEBaseModel

@property(nonatomic,strong) NSString *itemId;
@property(nonatomic,strong) NSString *itemName;
@property(nonatomic,strong) NSNumber *score;

@end
