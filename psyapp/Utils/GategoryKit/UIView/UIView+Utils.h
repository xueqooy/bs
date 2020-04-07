//
//  UIView+CodeFragments.h
//  CodeFragment
//
//  Created by jinyu on 15/2/4.
//  Copyright (c) 2015年 jinyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

typedef enum {
    ShadowColorBlack        =   0,      // 黑色阴影用于：表格、等大视图
    ShadowColorLight        =   1,      // 浅色阴影用于：小按钮。
}ShadowColor;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGSize boundsSize;
@property (nonatomic, assign) CGFloat boundsWidth;
@property (nonatomic, assign) CGFloat boundsHeight;

@property (nonatomic, readonly) CGRect contentBounds;
@property (nonatomic, readonly) CGPoint contentCenter;

- (void)addTapGestureWithBlock:(void (^)(void))block;
- (void)addLongPressGestureWithBlock:(void (^)(void))block;

/**
 *  圆角和边框
 */
-(void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor*)color;

/**
 *  边框宽度  (可在nib使用)
 */
-(void)setBorderWidth:(CGFloat)borderWidth;
/**
 *  边框颜色  (可在nib使用)
 */
-(void)setBorderColor:(UIColor*)borderColor;
/**
 *  圆角  (可在nib使用)
 */
-(void)setCornerRadius:(CGFloat)cornerRadius;
/**
 *  圆形
 */
-(void)setCornerRound;


/**
 *  添加UIView的四个角的任意角的圆角 (需要对设置圆角的view添加frame)
 *
 *  @param radius    圆角的大小
 *  @param corners  设置哪个角为圆角
 */
- (void)util_setRadius:(float)radius forCorners:(UIRectCorner)corners;

/**
 *  给View添加黑色阴影和圆角 - 四个边都有阴影
 *
 *  @param shadowColor      阴影颜色
 *  @param radius           view的圆角
 */
- (void)setShadowWithColor:(ShadowColor)shadowColor cornerRadius:(float)radius;

//截图
- (UIImage *)snapsHotView;

//抖dong
+ (void)shakeView:(UIView*)viewToShake;
@end
