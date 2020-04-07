//
//  FastClickUtils.m
//  smartapp
//
//  Created by lafang on 2018/11/8.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FastClickUtils.h"
#import "DateUtil.h"

static long mLastClickTime;
static __weak id _obj;
@implementation FastClickUtils

+(BOOL) isFastClick{
    
    long long time = [DateUtil longLongFromDate:[NSDate date]];
    long long deltaTime = time - mLastClickTime;
    if (0 < deltaTime && deltaTime < 500) {
        mLog(@"点击太快了！");
        return YES;
    }
    mLastClickTime = time;
    
    return NO;
}

+ (BOOL)isFastClickForObj:(id)obj {
    if (_obj != obj) {
        _obj = obj;
        mLastClickTime = [DateUtil longLongFromDate:[NSDate date]];
        return NO;
    }
    
    _obj = obj;
    return [self isFastClick];
}
@end
