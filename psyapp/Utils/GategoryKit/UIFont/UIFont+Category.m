//
//  UIFont+Category.m
//  slp_ios_student
//
//  Created by 曾新 on 16/3/10.
//  Copyright © 2016年 ND. All rights reserved.
//

#import "UIFont+Category.h"

@implementation UIFont (Category)

// px转为fontSize
+ (UIFont *)systemFontOfPXSize:(CGFloat)pxSize {

    CGFloat fontSize = pxSize * 72 / 96;
    
    return [UIFont systemFontOfSize:fontSize];
}

@end
