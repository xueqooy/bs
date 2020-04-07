//
//  CareerChartDataItemModel.h
//  smartapp
//
//  Created by lafang on 2019/3/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "CareerChartDataChildModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CareerChartDataItemModel : FEBaseModel

//"compare_id":"uuid",        //对比项ID
//"compare_name":"string",    //对比项名称，如：全国，年级，我
//"chart_datas":[

@property(nonatomic,strong)NSString *compareId;
@property(nonatomic,strong)NSString *compareName;
@property(nonatomic,strong)NSArray *chartDatas;

@end

NS_ASSUME_NONNULL_END
