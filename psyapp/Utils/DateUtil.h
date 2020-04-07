//
//  DateUtil.h
//  app
//
//  Created by linjie on 17/3/18.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject
+(NSString*)stringFromLonglong:(long long)msSince1970;
+(NSString*)stringFromDate:(NSDate*)date;
+(NSDate*)dateFromString:(NSString*)dateString;
+(long long)longLongFromDate:(NSDate*)date;
+(NSDate*)dateFromLongLong:(long long)msSince1970;

+ (NSInteger)ageWithDateOfBirth:(NSDate *)date;

+ (NSString *) compareCurrentTime:(NSString *)str;

+ (BOOL) tokenAvailableWithExpiredDate:(NSString *)expired currentDate:(NSString *)current;
+ (NSTimeInterval)tokenRemainTimeWithExpiredDate:(NSString *)expired currentDate:(NSString *)current;

+ (NSString *)getEffectiveTime:(NSString *)time;
+ (NSString *)getEffectiveTime2:(NSString *)time;

+(NSString *)getEffectiveTime:(NSString *)time index:(NSInteger)index;

+(NSInteger)getNowTimestamp;

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

+ (NSString *)hexStringFromString:(NSString *)string;

+ (NSString *)stringFromHexString:(NSString *)hexString;

+(NSString*)getCurrentTimes;

+ (NSString *)getHexByDecimal:(NSInteger)decimal;

@end
