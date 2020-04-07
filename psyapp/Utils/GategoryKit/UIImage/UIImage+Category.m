//
//  UIImage+Category.m
//  slp_ios_student
//
//  Created by zhengxinyuan on 16/4/26.
//  Copyright © 2016年 ND. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

+ (UIImage *)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = {3, 1};
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)imageDotBorderWithSize:(CGSize)size
{


    return [self imageWithSize:size borderColor:[UIColor redColor] borderWidth:3.0f];

}

+ (UIImage *)getGradientImageWithColors:(NSArray<NSNumber *> *)colors locations:(NSArray<NSNumber *> *)locations imageSize:(CGSize)size {
    if (colors.count/4 != locations.count || colors.count%4 != 0) return nil;
    
    CGFloat colors_c[colors.count];
    CGFloat locations_c[locations.count];
    for (int i = 0; i < colors.count; i ++) {
        colors_c[i] = [colors[i] floatValue];
    }
    
    for (int i = 0; i < locations.count; i ++) {
        locations_c[i] = [locations[i] floatValue];
    }
    
    
    CGFloat width = size.width ;
    CGFloat height = size.height;
    
    CGGradientRef cggr;
    CGColorSpaceRef cgcs;
    size_t num = locations.count;
    cgcs = CGColorSpaceCreateDeviceRGB();
    cggr = CGGradientCreateWithColorComponents(cgcs, colors_c, locations_c, num);
    CGPoint startPoint, endPoint;
    startPoint = CGPointMake(0.0, 0.0);
    endPoint = CGPointMake(width ,height);
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(ctx, cggr, startPoint, endPoint, 0);
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return gradientImage;
}

+ (UIImage *)getGradientImageWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)start endPoint:(CGPoint)end imageSize:(CGSize)size {
    if (colors.count != locations.count) return nil;
    
    CGFloat locations_c[locations.count];
    NSMutableArray *mutableColors = @[].mutableCopy;
    for (int i = 0; i < locations.count; i ++) {
        locations_c[i] = [locations[i] floatValue];
        [mutableColors addObject:(__bridge id)(colors[i].CGColor)];
    }
    
    
    CGFloat width = size.width ;
    CGFloat height = size.height;
    
    CGGradientRef cggr;
    CGColorSpaceRef cgcs;

    cgcs = CGColorSpaceCreateDeviceRGB();
    cggr = CGGradientCreateWithColors(cgcs, (__bridge CFArrayRef)mutableColors, locations_c);

    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(ctx, cggr, start, end, 0);
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return gradientImage;
}


+ (UIImage *)gradientImageWithWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)start endPoint:(CGPoint)end size:(CGSize)size {
    if (colors.count != locations.count) return nil;
       CGFloat locations_c[locations.count];
       NSMutableArray *mutableColors = @[].mutableCopy;
       for (int i = 0; i < locations.count; i ++) {
           locations_c[i] = [locations[i] floatValue];
           [mutableColors addObject:(__bridge id)(colors[i].CGColor)];
       }
        
       CGFloat width = size.width ;
       CGFloat height = size.height;
       
       CGGradientRef cggr;
       CGColorSpaceRef cgcs;

       cgcs = CGColorSpaceCreateDeviceRGB();
       cggr = CGGradientCreateWithColors(cgcs, (__bridge CFArrayRef)mutableColors, locations_c);

       CGPoint sp = CGPointMake(width * start.x, height * start.y);
       CGPoint ep = CGPointMake(width * end.x, height * end.y);
    
       UIGraphicsBeginImageContext(CGSizeMake(width, height));
       CGContextRef ctx = UIGraphicsGetCurrentContext();
       CGContextDrawLinearGradient(ctx, cggr, sp, ep, 0);
       UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
       UIGraphicsEndImageContext();
       return gradientImage;
}
@end
