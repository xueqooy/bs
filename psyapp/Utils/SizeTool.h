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
#define STEdgeInsets(t, l, b, r)  [SizeTool insetsWithTop:t left:l bottom:b right:r]
#define STEdgeInsetsAll(x)  [SizeTool insetsWithTop:x left:x bottom:x right:x]
#define STEdgeInsetsVertical(x)  [SizeTool insetsWithTop:x left:0 bottom:x right:0]
#define STEdgeInsetsHorizontal(x)  [SizeTool insetsWithTop:0 left:x bottom:0 right:x]

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
+ (UIEdgeInsets)insetsWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

+ (UIFont *)fontBold:(CGFloat)size;
+ (UIFont *)fontRegular:(CGFloat)size;
+ (UIFont *)font:(CGFloat)size;
+ (void)logFontFamily;
@end

NS_ASSUME_NONNULL_END
