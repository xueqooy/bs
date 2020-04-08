//
//  UniversityDetailsViewController.h
//  smartapp
//
//  Created by lafang on 2019/3/5.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"
#import "UniversityModel.h"
#import "YNPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityDetailsViewController : YNPageViewController

@property(nonatomic,strong)UniversityModel *universityModel;

+ (instancetype)suspendTopPausePageVC;

@end

NS_ASSUME_NONNULL_END
