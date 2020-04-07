//
//  TCVisiotorBindingViewController.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/25.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseViewController.h"


@interface TCDeviceLoginAlertViewController : FEBaseViewController
+ (void)showWithPresentedViewController:(UIViewController *)viewController needPerfectInfoAfterRegister:(BOOL)need onRegisterSuccess:(void (^)(void))registerSuccess perfectionSuccess:(void (^)(void))perfectionSuccess;
@end

