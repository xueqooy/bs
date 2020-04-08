//
//  EnrollmentRootModel.h
//  smartapp
//
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "EnrollmentOfficeModel.h"
#import "EnrollmentNavigationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnrollmentRootModel : FEBaseModel

@property(nonatomic,strong)EnrollmentOfficeModel *enrollmentOffice;
@property(nonatomic,strong)NSArray *enrollmentNavigation;

@end

NS_ASSUME_NONNULL_END
