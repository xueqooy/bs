//
//  UIColor+Category.h
//  Pods
//
//  Created by 曾新 on 16/3/9.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

//16进制色值转换
+ (UIColor *)colorWithHexString:(NSString *)colorString;

+ (UIColor *)colorWithHexString:(NSString *)colorString alpha:(CGFloat)alpha;

@end
