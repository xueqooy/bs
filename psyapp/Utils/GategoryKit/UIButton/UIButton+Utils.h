//
//  UIButton+LeeHitRect.h
//  FlyClip
//
//  Created by zhangmingwei on 2017/11/8.
//  Copyright © 2017年 tongboshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Utils)

// 带 image/title 的按钮 (左右排列) 布局方式
typedef enum {
    imageLeft_WholeCenter   =   0,      // 图片居左，整体居中
    imageLeft_wholeLeft     =   1,      // 图片居左，整体居左
    imageleft_wholeRight    =   2,      // 图片居左，整体居右
    imageRight_wholeCenter  =   3,      // 图片居右，整体居中
    imageRight_wholeLeft    =   4,      // 图片居右，整体居左
    imageRight_wholeRight   =   5,      // 图片居右，整体居右
    
}ButtonLayoutType;

/**
 自定义响应边界 UIEdgeInsetsMake(-3, -4, -5, -6). 表示扩大
 例如： self.btn.hitEdgeInsets = UIEdgeInsetsMake(-3, -4, -5, -6);
 */
@property(nonatomic, assign) UIEdgeInsets hitEdgeInsets;


/**
 自定义响应边界 自定义的边界的范围 范围扩大3.0
 例如：self.btn.hitScale = 3.0;
 */
@property(nonatomic, assign) CGFloat hitScale;

/*
 自定义响应边界 自定义的宽度的范围 范围扩大3.0
 例如：self.btn.hitWidthScale = 3.0;
 */
@property(nonatomic, assign) CGFloat hitWidthScale;

/*
 自定义响应边界 自定义的高度的范围 范围扩大3.0
 例如：self.btn.hitHeightScale = 3.0;
 */
@property(nonatomic, assign) CGFloat hitHeightScale;

/**
 *  获取常用的 UIButton
 *
 *  @param title      按钮文字
 *  @param titleColor 文字颜色
 *  @param font       字体
 *
 *  @return UIButton
 */
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font;

/**
 *  获取带 image/title 的按钮 (左右排列)
 *
 *  @param image      图片
 *  @param title      文字
 *  @param titleColor 字体颜色
 *  @param font       文字大小
 *  @param spacing    image和title的间隔
 *  @param type       排列方式
 *
 *  @return UIButton
 */
+ (UIButton *)buttonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font layoutType:(ButtonLayoutType)type spacing:(float)spacing ;
/**
 *  通过配置参数创建UIButton
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor font:(UIFont *)font radius:(CGFloat)radius title:(NSString *)title;

- (void)setBackgroundNormalColor:(UIColor *)normal andHighlightedColor:(UIColor *)highlighted;
@end
