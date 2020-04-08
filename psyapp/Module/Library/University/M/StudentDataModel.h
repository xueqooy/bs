//
//  StudentDataModel.h
//  smartapp
//
//  Created by lafang on 2019/3/16.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentDataModel : FEBaseModel

//"university_id": "i7e2ylaqujabyy6h",
//"international_students": 2423,//国际学生人数
//"undergraduate_students": 16285,//本科生数量
//"postgraduates_students": 14728//研究生数量

@property(nonatomic,strong) NSString *universityId;
@property(nonatomic,strong) NSNumber *internationalStudents;
@property(nonatomic,strong) NSNumber *undergraduateStudents;
@property(nonatomic,strong) NSNumber *postgraduatesStudents;

@end

NS_ASSUME_NONNULL_END
