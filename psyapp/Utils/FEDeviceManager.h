//
//  DeviceManager.h
//  smartapp
//
//  Created by lafang on 2018/9/11.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FEDeviceManager : NSObject

//设备名称
+ (NSString *)getDiviceName;

//设备型号
+ (NSString *)getDiviceModel;

//设备uuid
+ (NSString *)getDiviceUUID;

//从keyChain获取uuid
+ (NSString *)getDiviceUUIDFromKeyChain;

+ (NSString *)debug_getDiviceUUID;

//获取设备具体型号   需要#import <sys/utsname.h>
+ (NSString*)getDeviceModelName;

+(BOOL)isIphone5;


@end
