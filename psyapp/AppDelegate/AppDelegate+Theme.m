//
//  AppDelegate+Theme.m
//  smartapp
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "AppDelegate+Theme.h"

#import "FEThemeConfigureDark.h"
#import "FEThemeConfigureDefault.h"

#import <QMUIKit.h>

@implementation AppDelegate (Theme)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL overrideMethod = @selector(application:didFinishLaunchingWithOptions:);
        OverrideImplementation(self.class, overrideMethod, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(AppDelegate *selfObject, UIApplication *application, NSDictionary *launchOptions) {
                //注册主题监听
                [NSNotificationCenter.defaultCenter addObserver:selfObject selector:@selector(handleThemeDidChangeNotification:) name:QMUIThemeDidChangeNotification object:nil];
                //设置用于生成主题的 block
                QMUIThemeManagerCenter.defaultThemeManager.themeGenerator = ^__kindof NSObject * _Nullable(__kindof NSString * _Nonnull identifier) {
                    if ([identifier isEqualToString:FEThemeConfigureDefaultIdentifier])
                        return FEThemeConfigureDefault.new;
                    if ([identifier isEqualToString:FEThemeConfigureDarkIdentifier])
                        return FEThemeConfigureDark.new;
                    return nil;
                };
                
                //针对 iOS 13 开启自动响应系统的 Dark Mode 切换
                if (@available(iOS 13.0, *)) {
                    QMUIThemeManagerCenter.defaultThemeManager.identifierForTrait = ^__kindof NSObject<NSCopying> * _Nonnull(UITraitCollection * _Nonnull trait) {
                        if (trait.userInterfaceStyle == UIUserInterfaceStyleDark) {
                            return FEThemeConfigureDarkIdentifier;
                        }
                        return FEThemeConfigureDefaultIdentifier;
                    };
                    
                    //让 QMUIThemeManager 自动响应系统的 Dark Mode 切换
                    QMUIThemeManagerCenter.defaultThemeManager.respondsSystemStyleAutomatically = YES;
                } else {
                    QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier = FEThemeConfigureDefaultIdentifier;
                }
        

                void (*originSelectorIMP)(id, SEL, UIApplication *, NSDictionary *);
                originSelectorIMP = (void (*)(id, SEL, UIApplication *, NSDictionary *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, application, launchOptions);
            };
        });
    });
}

- (void)handleThemeDidChangeNotification:(NSNotification *)sender {
    QMUIThemeManager *manager = sender.object;
    mLog(@"模式发生切换，当前模式是%@",manager.currentThemeIdentifier);
}
@end
