//
//  TCMyAccountViewController.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface TCMyAccountViewController : FEBaseViewController
@property (nonatomic, assign) BOOL backIfRechargeSuccess;
@property (nonatomic, copy) void (^rechargeSuccessAndBackHandler) (void);
@end

NS_ASSUME_NONNULL_END
