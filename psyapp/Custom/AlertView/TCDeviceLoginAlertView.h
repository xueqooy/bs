//
//  TCDeviceLoginAlertView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/25.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCDeviceLoginAlertView : FEBaseAlertView
@property (nonatomic, copy) void (^deviceLoginHandler)(void);
@property (nonatomic, copy) void (^accountLoginHandler)(void);
@end

NS_ASSUME_NONNULL_END
