//
//  FEThemeConfigureDark.m
//  smartapp
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "FEThemeConfigureDark.h"

NSString *const FEThemeConfigureDarkIdentifier =  @"Dark";
@implementation FEThemeConfigureDark
- (UIColor *)themeMainColor {
    return mHexColor(@"99801d");
}

- (UIColor *)themeTextColorHighlighted {
    return mHexColor(@"99542a");
}

- (UIColor *)themeWarningColor {
    return mHexColor(@"994343");
}

- (UIColor *)themeSafeColor {
    return mHexColor(@"54997d");
}

- (UIColor *)themeSeparatorColor {
    return mHexColorA(@"ffffff", 0.15);
}

- (UIColor *)themeBackgroundColor {
    return mHexColor(@"000000");
    
}
- (UIColor *)themePlaceholderColor {
    return mHexColorA(@"ffffff", 0.45);
}

- (UIColor *)themeTitleTextColor {
    return mHexColorA(@"ffffff", 0.6);
}

- (UIColor *)themeTitleTextColorLighten { 
    return mHexColorA(@"ffffff", 0.6);
}

- (UIColor *)themeMainTextColor {
    return mHexColorA(@"ffffff", 0.6);
}

- (UIColor *)themeAuxiliaryTextColor {
    return mHexColorA(@"ffffff", 0.45);
}
- (UIColor *)themeUnselectedTextColor {
    return mHexColorA(@"ffffff", 0.45);
}

- (UIColor *)themeContentBackgroundColor {
    return mHexColor(@"1a1513");
}

- (UIColor *)themeButtonBackgrondColorDisabled {
    return mHexColorA(@"ffffff", 0.15);
}
- (UIColor *)themeButtonBackgrounColorActive {
    return mHexColorA(@"ffffff", 0.25);
}

- (UIColor *)themeColorDependedOnBackgroundColorOfView:(UIView *)view{
    if (view == nil) {
        return self.themeTitleTextColor;
    }
    UIColor *backgroundColor = view.backgroundColor;
    if (CGColorEqualToColor(backgroundColor.CGColor, self.themeMainColor.CGColor)) {
        return self.themeContentBackgroundColor; //1a1513
    } else if (CGColorEqualToColor(backgroundColor.CGColor, self.themeButtonBackgrondColorDisabled.CGColor) ||
               CGColorEqualToColor(backgroundColor.CGColor, self.themeButtonBackgrounColorActive.CGColor)){
        return self.themeAuxiliaryTextColor;  //0.45
    } else {
        return self.themeTitleTextColor;      //0.6
    }
}
#pragma mark - Image
- (UIImage *)themeNormalNavigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:self.themeContentBackgroundColor];
}

- (UIImage *)themeMainColorNavigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:self.themeMainColor];
}

- (UIImage *)themeNavigationBarBackButtonImage {
    return [UIImage imageNamed:@"share_back_white"];
}

- (NSString *)themeName {
    return FEThemeConfigureDarkIdentifier;
}
@end
