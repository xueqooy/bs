//
//  ChartItemsDynamicModel.h
//  smartapp
//
//  Created by lafang on 2018/12/11.
//  Copyright © 2018 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "ChartDatasDynamicModel.h"
#import "ChartItemDataModel.h"

@interface ChartItemsDynamicModel : FEBaseModel

@property(nonatomic,strong) NSString *compareName;
@property(nonatomic,strong) NSString *compareId;
@property(nonatomic,strong) NSArray *chartDatas;

@end
