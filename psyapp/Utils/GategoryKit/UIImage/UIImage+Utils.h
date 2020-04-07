//
//  UIImage+Utils.h
//
//  Created by zhangmingwei on 2017/12/12.
//  Copyright © 2017年 zhangmingwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;

///根据色值 获取渐变 UIImage
+ (UIImage *)getImageFromColors:(NSArray *)colors ByGradientType:(GradientType)gradientType frame:(CGRect)frame;
//比例缩放
+ (UIImage *)scaleImageWithName:(NSString *)imageName withScale:(CGFloat)scale;
+ (UIImage *)scaleImageWithName:(NSString *)imageName toSize:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *) renderAtSize:(const CGSize) size;
- (UIImage *) maskWithImage:(const UIImage *) maskImage;
- (UIImage *) maskWithColor:(UIColor *) color;
// 使用绘图返回圆形图片
- (UIImage *)circleImage;
@end
