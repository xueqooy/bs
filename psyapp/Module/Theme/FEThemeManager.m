//
//  FEThemeManager.m
//  smartapp
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "FEThemeManager.h"
#import <QMUITheme.h>
@interface FEThemeManager ()
@property (nonatomic, strong) UIColor *fe_mainColor;
@property (nonatomic, strong) UIColor *fe_textColorHighlighted;
@property (nonatomic, strong) UIColor *fe_warningColor;
@property (nonatomic, strong) UIColor *fe_safeColor;
@property (nonatomic, strong) UIColor *fe_separatorColor;
@property (nonatomic, strong) UIColor *fe_backgroundColor;
@property (nonatomic, strong) UIColor *fe_placeholderColor;
@property (nonatomic, strong) UIColor *fe_titleTextColor;
@property (nonatomic, strong) UIColor *fe_titleTextColorLighten;
@property (nonatomic, strong) UIColor *fe_mainTextColor;
@property (nonatomic, strong) UIColor *fe_mainTextColorLighten;
@property (nonatomic, strong) UIColor *fe_auxiliaryTextColor;
@property (nonatomic, strong) UIColor *fe_unselectedTextColor;
@property (nonatomic, strong) UIColor *fe_contentBackgroundColor;

@property (nonatomic, strong) UIImage *fe_normalNavigationBarBackgroundImage;
@property (nonatomic, strong) UIImage *fe_mainColorNavigationBarBackgroundImage;
@property (nonatomic, strong) UIImage *fe_navigationBarBackButtonImage;
@property (nonatomic, strong) UIColor *fe_buttonBackgroundColorDisabled;
@property (nonatomic, strong) UIColor *fe_buttonBackgroundColorActive;

- (UIColor *)fe_dynamicColorDependedOnBackgroundColorOfView:(UIView *)view;
+ (instancetype)sharedInstance;

@end

@implementation FEThemeManager
+ (instancetype)sharedInstance {
    static FEThemeManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fe_mainColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeMainColor;
        }];
        
        self.fe_safeColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeSafeColor;
        }];
        
        self.fe_warningColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeWarningColor;
        }];
        
        self.fe_mainTextColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeMainTextColor;
        }];
        
        self.fe_separatorColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeSeparatorColor;
        }];
        
        self.fe_titleTextColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeTitleTextColor;
        }];
        
        self.fe_titleTextColorLighten = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeTitleTextColorLighten;
        }];
        
        self.fe_textColorHighlighted = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeTextColorHighlighted;
        }];
        
        self.fe_auxiliaryTextColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeAuxiliaryTextColor;
        }];

        self.fe_unselectedTextColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeUnselectedTextColor;
        }];
        
        self.fe_placeholderColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themePlaceholderColor;
        }];
        
        self.fe_backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeBackgroundColor;
        }];
        
        self.fe_contentBackgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeContentBackgroundColor;
        }];
        
        self.fe_buttonBackgroundColorDisabled = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeButtonBackgrondColorDisabled;
        }];
        
        self.fe_buttonBackgroundColorActive = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeButtonBackgrounColorActive;
        }];
        
        self.fe_mainColorNavigationBarBackgroundImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeMainColorNavigationBarBackgroundImage;
        }];
        
        self.fe_normalNavigationBarBackgroundImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeNormalNavigationBarBackgroundImage;
        }];
    
        self.fe_navigationBarBackButtonImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
            return theme.themeNavigationBarBackButtonImage;
        }];
        
    }
    return self;
}

- (UIColor *)fe_dynamicColorDependedOnBackgroundColorOfView:(UIView *)view{
    @weakObj(view);
    return [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSString * _Nullable identifier, __kindof NSObject <FEThemeProtocol>* _Nullable theme) {
        return [theme themeColorDependedOnBackgroundColorOfView:viewweak];
    }];
}


+ (NSObject<FEThemeProtocol> *)currentTheme {
    return QMUIThemeManagerCenter.defaultThemeManager.currentTheme;
}
@end

@implementation UIColor (FETheme)
+ (UIColor *)fe_mainColor {
    return FEThemeManager.sharedInstance.fe_mainColor;
}

+ (UIColor *)fe_textColorHighlighted {
    return FEThemeManager.sharedInstance.fe_textColorHighlighted;
}

+ (UIColor *)fe_warningColor {
    return FEThemeManager.sharedInstance.fe_warningColor;
}

+ (UIColor *)fe_safeColor {
    return FEThemeManager.sharedInstance.fe_safeColor;
}

+ (UIColor *)fe_separatorColor {
    return FEThemeManager.sharedInstance.fe_separatorColor;
}

+ (UIColor *)fe_backgroundColor {
    return FEThemeManager.sharedInstance.fe_backgroundColor;
}

+ (UIColor *)fe_placeholderColor {
    return FEThemeManager.sharedInstance.fe_placeholderColor;
}

+ (UIColor *)fe_titleTextColor {
    return FEThemeManager.sharedInstance.fe_titleTextColor;
}

+ (UIColor *)fe_titleTextColorLighten {
    return FEThemeManager.sharedInstance.fe_titleTextColorLighten;
}

+ (UIColor *)fe_mainTextColor {
    return FEThemeManager.sharedInstance.fe_mainTextColor;
}

+ (UIColor *)fe_auxiliaryTextColor {
    return FEThemeManager.sharedInstance.fe_auxiliaryTextColor;
}

+ (UIColor *)fe_unselectedTextColor {
    return FEThemeManager.sharedInstance.fe_unselectedTextColor;
}

+ (UIColor *)fe_contentBackgroundColor {
    return FEThemeManager.sharedInstance.fe_contentBackgroundColor;
}

+ (UIColor *)fe_buttonBackgroundColorDisabled {
    return FEThemeManager.sharedInstance.fe_buttonBackgroundColorDisabled;
}

+ (UIColor *)fe_buttonBackgroundColorActive {
    return FEThemeManager.sharedInstance.fe_buttonBackgroundColorActive;
}

+ (instancetype)fe_dynamicColorDependedOnBackgroundColorOfView:(UIView *)view {
    return [FEThemeManager.sharedInstance fe_dynamicColorDependedOnBackgroundColorOfView:view];
}

+ (instancetype)fe_dynamicColorWithDefault:(UIColor *)defaultColor darkColor:(UIColor *)darkColor {
    return [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSString * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        if ([identifier isEqualToString:FEThemeConfigureDarkIdentifier]) {
            return darkColor;
        }
        return defaultColor;
    }];
}

+ (instancetype)fe_dynamicColorWithDefault:(UIColor *)defaultColor darkWithAlpha:(CGFloat)darkAlpha {
    return [UIColor fe_dynamicColorWithDefault:defaultColor darkColor:[defaultColor colorWithAlphaComponent:darkAlpha]];
}

@end


@implementation UIImage (FETheme)

+ (UIImage *)fe_normalNavigationBarBackgroundImage {
    return FEThemeManager.sharedInstance.fe_normalNavigationBarBackgroundImage;
}

+ (UIImage *)fe_mainColorNavigationBarBackgroundImage {
    return FEThemeManager.sharedInstance.fe_mainColorNavigationBarBackgroundImage;
}

+ (UIImage *)fe_navigationBarBackButtonImage {
    return FEThemeManager.sharedInstance.fe_navigationBarBackButtonImage;
}

@end

@implementation UIButton (FETheme)

static char kAssociatedObjectKey_fe_adjustTitleColorAutomatically;
- (void)setFe_adjustTitleColorAutomatically:(BOOL)fe_adjustTitleColorAutomatically {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_fe_adjustTitleColorAutomatically, [NSNumber numberWithBool:fe_adjustTitleColorAutomatically], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (fe_adjustTitleColorAutomatically) {
        [self setTitleColor:[UIColor fe_dynamicColorDependedOnBackgroundColorOfView:self] forState:UIControlStateNormal];
    }
}

- (BOOL)fe_adjustTitleColorAutomatically {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_fe_adjustTitleColorAutomatically)) boolValue];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL extendMethod = @selector(setBackgroundColor:);
        ExtendImplementationOfVoidMethodWithSingleArgument(self.class, extendMethod, UIColor *, ^(UIButton *selfObject, UIColor *backgroundColor) {
            if (selfObject.fe_adjustTitleColorAutomatically) {
                [selfObject setTitleColor:[UIColor fe_dynamicColorDependedOnBackgroundColorOfView:selfObject] forState:UIControlStateNormal];
            }
        });
    });
}
@end

@implementation UILabel (FETheme)


static char kAssociatedObjectKey_fe_adjustTextColorAutomatically;
- (void)setFe_adjustTextColorAutomatically:(BOOL)fe_adjustTextColorAutomatically {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_fe_adjustTextColorAutomatically, [NSNumber numberWithBool:fe_adjustTextColorAutomatically], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (fe_adjustTextColorAutomatically) {
        [self setTextColor:[UIColor fe_dynamicColorDependedOnBackgroundColorOfView:self]];
    }
}

- (BOOL)fe_adjustTextColorAutomatically {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_fe_adjustTextColorAutomatically)) boolValue];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL extendMethod = @selector(setBackgroundColor:);
        ExtendImplementationOfVoidMethodWithSingleArgument(self.class, extendMethod, UIColor *, ^(UILabel *selfObject, UIColor *backgroundColor) {
            if (selfObject.fe_adjustTextColorAutomatically) {
                [selfObject setTextColor:[UIColor fe_dynamicColorDependedOnBackgroundColorOfView:selfObject] ];
            }
        });
    });
}
@end

@implementation UIImageView (FETheme)
- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(__kindof NSString *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    if ([identifier isEqualToString:FEThemeConfigureDarkIdentifier]) {
        self.alpha = 0.8;
    } else {
        self.alpha = 1;
    }
}
@end
