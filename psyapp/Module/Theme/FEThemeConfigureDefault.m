//
//  FEThemeConfigureDefault.m
//  smartapp
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "FEThemeConfigureDefault.h"

NSString *const FEThemeConfigureDefaultIdentifier = @"Default";

@implementation FEThemeConfigureDefault
- (UIColor *)themeMainColor {
    return mHexColor(@"##91d5ff");
}

- (UIColor *)themeTextColorHighlighted {
    return mHexColor(@"#FC674F");
}

- (UIColor *)themeWarningColor {
    return mHexColor(@"f56c6c");
}

- (UIColor *)themeSafeColor {
    return mHexColor(@"7fe6bc");
}

- (UIColor *)themeSeparatorColor {
    return mHexColor(@"ebedf0");
}

- (UIColor *)themeBackgroundColor {
    return mHexColor(@"f5f7fa");
}

- (UIColor *)themeTitleTextColor {
    return mHexColor(@"18181a");
}

- (UIColor *)themeTitleTextColorLighten {
    return mHexColor(@"303133");
}

- (UIColor *)themePlaceholderColor {
    return mHexColor(@"c0c4cc");
}

- (UIColor *)themeUnselectedTextColor {
    return mHexColor(@"a4aebc");
}

- (UIColor *)themeMainTextColor {
    return mHexColor(@"606266");
}

- (UIColor *)themeAuxiliaryTextColor {
    return mHexColor(@"909399");
}

- (UIColor *)themeContentBackgroundColor {
    return mHexColor(@"ffffff");
}

- (UIColor *)themeButtonBackgrondColorDisabled {
    return mHexColorA(@"#306DFE", 0.4);
}

- (UIColor *)themeButtonBackgrounColorActive {
    return mHexColor(@"f0f2f5");
}


- (UIColor *)themeColorDependedOnBackgroundColorOfView:(UIView *)view {
    if (view == nil) {
        return self.themeContentBackgroundColor;
    }
    UIColor *backgroundColor = view.backgroundColor;
    if (CGColorEqualToColor(backgroundColor.CGColor, self.themeMainColor.CGColor)) {
        return self.themeContentBackgroundColor;
    } else if (CGColorEqualToColor(backgroundColor.CGColor, self.themeButtonBackgrounColorActive.CGColor)){
        return self.themeUnselectedTextColor;
    } else if (CGColorEqualToColor(backgroundColor.CGColor, self.themeContentBackgroundColor.CGColor)){
        return self.themeTitleTextColorLighten;
    } else {
        return self.themeContentBackgroundColor;
    }
}

#pragma mark - Image
- (UIImage *)themeNormalNavigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:self.themeMainColor];
}

- (UIImage *)themeMainColorNavigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:self.themeMainColor];
}

- (UIImage *)themeNavigationBarBackButtonImage {
    return [UIImage imageNamed:@"share_back_white"];
}

- (NSString *)themeName {
    return FEThemeConfigureDefaultIdentifier;
}
@end
