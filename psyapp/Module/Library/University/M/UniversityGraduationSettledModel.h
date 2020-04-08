//
//  UniversityGraduationSettledModel.h
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityGraduationSettledModel : FEBaseModel

//"id": 107,
//"university_id": "i7e2ylaqujabyy6h",
//"degree_name": "phd",
//"degree": "博士生",
//"ratio": 0.9768

@property(nonatomic,strong)NSNumber *settledId;
@property(nonatomic,strong)NSString *universityId;
@property(nonatomic,strong)NSString *degreeName;
@property(nonatomic,strong)NSString *degree;
@property(nonatomic,strong)NSNumber *ratio;

@end

NS_ASSUME_NONNULL_END
