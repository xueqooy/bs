//
//  TCNetworkReachabilityHelper.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCNetworkReachabilityHelper.h"

@implementation TCNetworkReachabilityHelper
+ (void)startMonitoring {
    AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    //TODO:本地缓存
    [networkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                break;

            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
               
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                break;
        }
        [NSNotificationCenter.defaultCenter postNotificationName:nc_networking_status_change object:@(status)];
    }];
    [networkReachabilityManager startMonitoring];
}

+ (void)stopMonitoring {
    AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [networkReachabilityManager stopMonitoring];
}

+ (BOOL)isReachable {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}
@end
