//
//  UIImage+Category.h
//  slp_ios_student
//
//  Created by zhengxinyuan on 16/4/26.
//  Copyright © 2016年 ND. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

+ (UIImage *)imageDotBorderWithSize:(CGSize)size;

+ (UIImage *)getGradientImageWithColors:(NSArray <NSNumber *>*)colors locations:(NSArray <NSNumber *>*)locations imageSize:(CGSize)size;
//colors为RGBA 比如@[@1.0, @0.8, @1.0, @0.5,
//                  @0.2, @0.5, @1.0, @1.0]
+ (UIImage *)getGradientImageWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)start endPoint:(CGPoint)end imageSize:(CGSize)size;


+ (UIImage *)gradientImageWithWithColors:(NSArray <UIColor *>*)colors locations:(NSArray <NSNumber *> *)locations startPoint:(CGPoint)start endPoint:(CGPoint)end size:(CGSize)size;
@end
