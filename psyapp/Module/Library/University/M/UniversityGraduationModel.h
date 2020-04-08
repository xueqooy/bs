//
//  UniversityGraduationModel.h
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "UniversityGrduationOverallModel.h"
#import "UniversityGraduationSettledModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityGraduationModel : FEBaseModel

//"university_id": "i7e2ylaqujabyy6h",
//"five_year_salary": 13218,//5年薪资
//"overall": [{
//"settled": [{  //总体就业率

@property(nonatomic,strong)NSString *universityId;
@property(nonatomic,strong)NSNumber *fiveYearSalary;
@property(nonatomic,strong)NSArray *overall;
@property(nonatomic,strong)NSArray *settled;

@end

NS_ASSUME_NONNULL_END
