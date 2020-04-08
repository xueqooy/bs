//
//  UniversityMajorInfoModel.h
//  smartapp
//
//  Created by lafang on 2019/4/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityMajorInfoModel : FEBaseModel

@property(nonatomic,strong)NSString *assessmentLevel;
@property(nonatomic,strong)NSString *majorName;
@property(nonatomic,strong)NSNumber *majorType;
@property(nonatomic,strong)NSNumber *mid;
@property(nonatomic,strong)NSString *typeName;
@property(nonatomic,strong)NSString *specialName;
@property(nonatomic,strong)NSString *universityName;
@property(nonatomic,strong)NSNumber *year;
@property(nonatomic,strong)NSString *majorCode;
@property(nonatomic,strong)NSString *universityId;
@property(nonatomic,strong)NSString *subjectsRequired;

@end

NS_ASSUME_NONNULL_END
