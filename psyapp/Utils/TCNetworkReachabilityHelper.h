//
//  TCNetworkReachabilityHelper.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCNetworkReachabilityHelper : NSObject
@property (nonatomic, class, readonly) BOOL isReachable;

+ (void)startMonitoring;
+ (void)stopMonitoring;
@end

NS_ASSUME_NONNULL_END
