//
//  TCVisitorInfoPerfectionViewController.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/25.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCDeviceLoginInfoPerfectionViewController : FEBaseViewController
+ (void)showWithPresentedViewController:(UIViewController *)viewController onPerfectionSuccess:(void (^)(void))perfectionSuccess;
@end

NS_ASSUME_NONNULL_END
