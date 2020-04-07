//
//  FEThemeManager.h
//  smartapp
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEThemeProtocol.h"
#import "FEThemeConfigureDark.h"
#import "FEThemeConfigureDefault.h"
NS_ASSUME_NONNULL_BEGIN

#define FEThemeDarkCommonAlpha 0.6

@interface FEThemeManager : NSObject
@property (class, nonatomic, strong, readonly, nullable) NSObject <FEThemeProtocol>*currentTheme;
@end

@interface UIColor (FETheme)
@property (class, nonatomic, strong, readonly) UIColor *fe_mainColor;
@property (class, nonatomic, strong, readonly) UIColor *fe_textColorHighlighted;
@property (class, nonatomic, strong, readonly) UIColor *fe_warningColor;
@property (class, nonatomic, strong, readonly) UIColor *fe_safeColor;
@property (class, nonatomic, strong, readonly) UIColor *fe_separatorColor;
@property (class, nonatomic, strong, readonly) UIColor *fe_backgroundColor;
@property (class, nonatomic, strong, readonly) UIColor *fe_placeholderColor;
@property (class, nonatomic, strong, readonly) UIColor *fe_titleTextColor;
@property (class, nonatomic, strong, readonly) UIColor *fe_titleTextColorLighten;
@property (class, nonatomic, strong, readonly) UIColor *fe_mainTextColor;
@property (class, nonatomic, strong, readonly) UIColor *fe_auxiliaryTextColor;
@property (class, nonatomic, strong, readonly) UIColor *fe_unselectedTextColor;
@property (class, nonatomic, strong, readonly) UIColor *fe_contentBackgroundColor;
@property (class, nonatomic, strong, readonly) UIColor *fe_buttonBackgroundColorDisabled;
@property (class, nonatomic, strong, readonly) UIColor *fe_buttonBackgroundColorActive;

+ (instancetype)fe_dynamicColorDependedOnBackgroundColorOfView:(UIView *)view;
+ (instancetype)fe_dynamicColorWithDefault:(UIColor *)defaultColor darkColor:(UIColor *)darkColor;
+ (instancetype)fe_dynamicColorWithDefault:(UIColor *)defaultColor darkWithAlpha:(CGFloat)darkAlpha;
@end

@interface UIImage (FETheme)
@property (class, nonatomic, strong, readonly) UIImage *fe_normalNavigationBarBackgroundImage;
@property (class, nonatomic, strong, readonly) UIImage *fe_mainColorNavigationBarBackgroundImage;
@property (class, nonatomic, strong, readonly) UIImage *fe_navigationBarBackButtonImage;
@end

@interface UIButton (FETheme)
@property (nonatomic, assign) BOOL fe_adjustTitleColorAutomatically;//当背景颜色改变是否自动调整字体颜色
@end

@interface UILabel (FETheme)
@property (nonatomic, assign) BOOL fe_adjustTextColorAutomatically;//当背景颜色改变是否自动调整字体颜色
@end

@interface UIImageView (FETheme)

@end
NS_ASSUME_NONNULL_END
