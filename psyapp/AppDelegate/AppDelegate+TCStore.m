//
//  AppDelegate+TCStore.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/10.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "AppDelegate+TCStore.h"

#import <QMUILab.h>

#import "TCIAPManager.h"
@implementation AppDelegate (TCStore)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL extendMethod1 = @selector(application:didFinishLaunchingWithOptions:);
        SEL extendMethod2 = @selector(applicationWillTerminate:);
        ExtendImplementationOfNonVoidMethodWithTwoArguments(self.class, extendMethod1, UIApplication *, NSDictionary *, BOOL, ^BOOL(AppDelegate *selfObject, UIApplication *application, NSDictionary *launchOptions, BOOL originReturnValue) {
            [TCIAPManager.shareInstance start];
            return originReturnValue;
        });
        
        ExtendImplementationOfVoidMethodWithSingleArgument(self.class, extendMethod2, UIApplication *, ^(AppDelegate *selfObject, UIApplication *application) {
            [TCIAPManager.shareInstance stop];

        });
    });
    
}
@end
