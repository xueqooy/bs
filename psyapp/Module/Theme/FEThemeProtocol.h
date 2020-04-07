//
//  FEThemeProtocol.h
//  smartapp
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMUIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol FEThemeProtocol <NSObject>
@required
- (NSString *)themeName;
@optional
- (UIColor *)themeMainColor; //主色

- (UIColor *)themeTitleTextColor; //模块/标题栏
- (UIColor *)themeTitleTextColorLighten; //标题
- (UIColor *)themeTextColorHighlighted;   //文本高亮
- (UIColor *)themeWarningColor;       //警告
- (UIColor *)themeSafeColor;          //安全
- (UIColor *)themeSeparatorColor;     //分割
- (UIColor *)themeBackgroundColor;    //背景
- (UIColor *)themePlaceholderColor;   //文本占位

- (UIColor *)themeMainTextColor;      //正文
- (UIColor *)themeAuxiliaryTextColor; //辅助提示
- (UIColor *)themeUnselectedTextColor; //未选中
- (UIColor *)themeContentBackgroundColor; //容器/卡片

- (UIColor *)themeButtonBackgrondColorDisabled; //按钮不可用
- (UIColor *)themeButtonBackgrounColorActive;  //更多按钮


- (UIColor *)themeColorDependedOnBackgroundColorOfView:(UIView *)view; //动态色

- (UIImage *)themeNormalNavigationBarBackgroundImage;          //一般情况下导航栏图片
- (UIImage *)themeMainColorNavigationBarBackgroundImage;       //主色调的导航栏图片,用于测评报告
- (UIImage *)themeNavigationBarBackButtonImage;                //导航栏按钮
@end

NS_ASSUME_NONNULL_END
