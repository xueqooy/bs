//
//  UniversityMajorModel.h
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityMajorModel : FEBaseModel

//"id": 2008,
//"university_id": "i7e2ylaqujabyy6h",
//"university_name": "天津大学",
//"major_name": "材料成型及控制工程",
//"major_code": "080203",
//"major_type": 1,
//"special_name": "材料成型及控制工程",
//"type_name": "本科",
//"year": 2019,
//"assessment_level": null

@property(nonatomic,strong)NSNumber *majorId;
@property(nonatomic,strong)NSString *universityId;
@property(nonatomic,strong)NSString *universityName;
@property(nonatomic,strong)NSString *majorName;
@property(nonatomic,strong)NSString *majorCode;
@property(nonatomic,strong)NSNumber *majorType;
@property(nonatomic,strong)NSString *specialName;
@property(nonatomic,strong)NSString *typeName;
@property(nonatomic,strong)NSNumber *year;
@property(nonatomic,strong)NSString *assessmentLevel;

@end

NS_ASSUME_NONNULL_END
