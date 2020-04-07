//
//  SizeTool.m
//  smartapp
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "SizeTool.h"
static CGFloat kUIWidth = 375.f;
static CGFloat kUIHeight = 667.f;
static CGFloat screenWidth;
static CGFloat screenHeight;
@implementation SizeTool

+ (void)initialize {
    screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
}

+ (CGFloat)widthRatio:(CGFloat)ratio {
    return ratio * screenWidth;
}

+ (CGFloat)heightRatio:(CGFloat)ratio {
    return ratio * screenHeight;
}

+ (CGFloat)width:(CGFloat)width {
    return width/kUIWidth * screenWidth;
}

+ (CGFloat)height:(CGFloat)height {
    return height/kUIWidth * screenWidth ;
}

+ (CGFloat)originHeight:(CGFloat)height {
    return height/kUIHeight * screenHeight;
}



+ (CGSize)sizeWithWidth:(CGFloat)width height:(CGFloat)height {
    return CGSizeMake([SizeTool width:width], [SizeTool height:height]);
}


#pragma mark -- Font
+ (UIFont *)fontBold:(CGFloat)size {
    CGFloat scaleSize = [self height:size];
    return [UIFont systemFontOfSize:scaleSize weight:UIFontWeightBold];
//    UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size: scaleSize]; //iOS 9.0后的PingFang字体
//    if (font == nil) { //兼容旧版本，导入的字体
//        font = [UIFont fontWithName:@"PingFang-SC-Semibold" size:scaleSize];
//    }
//    return font;
}

+ (UIFont *)fontRegular:(CGFloat)size {
    CGFloat scaleSize = [self height:size];
    return [UIFont systemFontOfSize:scaleSize weight:UIFontWeightRegular];

//    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size: scaleSize]; //iOS 9.0后的PingFang字体
//    if (font == nil) { //兼容旧版本，导入的字体
//        font = [UIFont fontWithName:@"PingFang-SC-Regular" size:scaleSize];
//    }
//    return font;
}

+ (UIFont *)font:(CGFloat)size {
    CGFloat scaleSize = [self height:size];
    return [UIFont systemFontOfSize:scaleSize weight:UIFontWeightMedium];

//    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size: scaleSize];
//    if (font == nil) {
//        font = [UIFont systemFontOfSize:scaleSize];
//    }
//    return font;
}

+ (void)logFontFamily {
    for (NSString *fontFamilyName in [UIFont familyNames])
    {
        NSLog(@"fontFamilyName:'%@'", fontFamilyName);
        for (NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"------------------------------------");
    }
}


@end
