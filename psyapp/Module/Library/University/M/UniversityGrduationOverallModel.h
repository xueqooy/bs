//
//  UniversityGrduationOverallModel.h
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityGrduationOverallModel : FEBaseModel

//"id": 106,
//"university_id": "i7e2ylaqujabyy6h",
//"degree": "undergraduate",
//"type": "domestic_postgraduate", //读研率
//"ratio": 0.4016

@property(nonatomic,strong)NSNumber *overallId;
@property(nonatomic,strong)NSString *universityId;
@property(nonatomic,strong)NSString *degree;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSNumber *ratio;

@end

NS_ASSUME_NONNULL_END
