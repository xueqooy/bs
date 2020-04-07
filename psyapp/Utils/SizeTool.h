//
//  SizeTool.h
//  smartapp
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define STWidth(x) [SizeTool width:x]
#define STHeight(x) [SizeTool height:x]
#define STSize(w, h) [SizeTool sizeWithWidth:w height:h]

#define STFontBold(x) [SizeTool fontBold:x]
#define STFontRegular(x) [SizeTool fontRegular:x]
#define STFont(x) [SizeTool font:x]

@interface SizeTool : NSObject
+ (CGFloat)widthRatio:(CGFloat)ratio;
+ (CGFloat)heightRatio:(CGFloat)ratio;
+ (CGFloat)width:(CGFloat)width;
+ (CGFloat)height:(CGFloat)height;
+ (CGFloat)originHeight:(CGFloat)height;

+ (CGSize )sizeWithWidth:(CGFloat)width height:(CGFloat)height;

+ (UIFont *)fontBold:(CGFloat)size;
+ (UIFont *)fontRegular:(CGFloat)size;
+ (UIFont *)font:(CGFloat)size;
+ (void)logFontFamily;
@end

NS_ASSUME_NONNULL_END
