//
//  NSLayoutConstraint+FEScreenAdapter.m
//  smartapp
//
//  Created by mac on 2019/9/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "NSLayoutConstraint+FEScreenAdapter.h"
#import "SizeTool.h"
#import "NSObject+Utils.h"
static char *AdaptionEnableKey = "AdaptionEnableKey";
@implementation NSLayoutConstraint (FEScreenAdapter)


- (BOOL)adaptionEnable {
    NSNumber *obj = objc_getAssociatedObject(self, AdaptionEnableKey);
    return obj.boolValue;
}

- (void)setAdaptionEnable:(BOOL)adaptionEnable {
    NSNumber *obj = @(adaptionEnable);
    objc_setAssociatedObject(self, AdaptionEnableKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (adaptionEnable) {
        self.constant = STWidth(self.constant);
    }

}




@end
