//
//  StudentRatioModel.h
//  smartapp
//
//  Created by lafang on 2019/3/16.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentRatioModel : FEBaseModel
//"university_id": "i7e2ylaqujabyy6h",
//"women_ratio": 0.34,//女
//"men_ratio": 0.66, //男
//"students_total": 16285//总人数

@property(nonatomic,strong)NSString *universityId;
@property(nonatomic,strong)NSNumber *womenRatio;
@property(nonatomic,strong)NSNumber *menRatio;
@property(nonatomic,strong)NSNumber *studentsTotal;

@end

NS_ASSUME_NONNULL_END
