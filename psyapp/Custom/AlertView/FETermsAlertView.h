//
//  FETermsAlertView.h
//  smartapp
//
//  Created by mac on 2019/12/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FETermsAlertView : FEBaseAlertView
@property (nonatomic, copy) void (^agreeHandler)(void);
@end

NS_ASSUME_NONNULL_END
