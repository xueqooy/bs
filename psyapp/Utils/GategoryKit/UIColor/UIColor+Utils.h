//
//  UIColor+IOSUtils.h
//  Toos
//
//  Created by xiaoming on 15/12/24.
//  Copyright © 2015年 shandandan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)

/**
 Creates a Color from a Hex representation string
 @param hexString   Hex string that looks like @"#FF0000" or @"FF0000"
 @return    Color
 */
+ (instancetype)colorFromHexString:(NSString *)hexString;

+ (instancetype)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 *  RGBA Helper method
 *
 *  @param red    0 -- 255.0f
 *  @param green  0 -- 255.0f
 *  @param blue   0 -- 255.0f
 *  @param alpha  0 -- 1.0f
 *
 *  @return UIColor
 */
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

/**
 获取标题的字体颜色 262626 - 黑色标题
 
 */
+ (UIColor *)getTitleColor;

/**
 获取背景色 #ffffff
 
 */
+ (UIColor *)getBackgroundColor;

/**
 获取表格分割线的颜色 cccaca
 */
+ (UIColor *)getSeparatorColor;

/**
 获取内容的字体颜色 6b6b6b
 */
+ (UIColor *)getContentColor;
/**
 获取次级内容的字体颜色 aaaaaa - 最浅的黑  ----- 也可以作为按钮不可点击的颜色
 
 */
+ (UIColor *)getContentSecondColor;

/**
 获取默认文字颜色。placeHoler的颜色 cccaca
 
 */
+ (UIColor *)getPlaceHoderColor;

/**
 获取红色的颜色 #BB0D23
 
 */
+ (UIColor *)getRedColor;

/**
 获取导航栏的背景颜色
 
 */
+ (UIColor *)getNavigationBarColor;

/**
 获取统一的蓝色的背景颜色
 
 @return blue
 */
+ (UIColor *)getBlueColor;

/**
 获取输入框的光标颜色
 
 @return 黑色
 */
+ (UIColor *)getTextFieldCursorColor;


/*
 *获取颜色的RGBA值
 @return RGBA值
 */
+ (NSMutableArray *)changeUIColorToRGB:(UIColor *)color;
@end
