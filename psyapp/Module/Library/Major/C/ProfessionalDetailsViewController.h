//
//  ProfessionalDetailsViewController.h
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "YNPageViewController.h"
#import "ProfessionalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessionalDetailsViewController : YNPageViewController

@property(nonatomic,strong)NSString *majorCode;

+ (instancetype)suspendTopPausePageVC;

@end

NS_ASSUME_NONNULL_END
