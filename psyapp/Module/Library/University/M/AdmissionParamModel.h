//
//  AdmissionParamModel.h
//  smartapp
//  院校录取-专业录取-参数数据模型
//  Created by lafang on 2019/3/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdmissionParamModel : FEBaseModel

@property(nonatomic,strong) NSString *province;  //省份
@property(nonatomic,strong) NSString *kind;      //文理科
@property(nonatomic,strong) NSString *batch;     //批次
@property(nonatomic,strong) NSString *bkcc;      //本科、专科
@property(nonatomic,strong) NSString *year;      //年份
@property(nonatomic,strong) NSString *school;    //学校

@end

NS_ASSUME_NONNULL_END
