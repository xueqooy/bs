//
//  UIButton+LeeHitRect.m
//  FlyClip
//
//  Created by zhangmingwei on 2017/11/8.
//  Copyright © 2017年 tongboshu. All rights reserved.
//

#import "UIButton+Utils.h"
#import <objc/runtime.h>

static const char * kHitEdgeInsets = "hitEdgeInsets";
static const char * kHitScale      = "hitScale";
static const char * kHitWidthScale      = "hitWidthScale";
static const char * kHitHeightScale      = "hitHeightScale";

@implementation UIButton (Utils)

#pragma mark - runtime set&get
#pragma mark - set Method
-(void)setHitEdgeInsets:(UIEdgeInsets)hitEdgeInsets{
    NSValue *value = [NSValue value:&hitEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self,kHitEdgeInsets, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setHitScale:(CGFloat)hitScale{
    CGFloat width = self.bounds.size.width * hitScale;
    CGFloat height = self.bounds.size.height * hitScale;
    self.hitEdgeInsets = UIEdgeInsetsMake(-height, -width,-height, -width);
    objc_setAssociatedObject(self, kHitScale, @(hitScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)setHitWidthScale:(CGFloat)hitWidthScale{
    CGFloat width = self.bounds.size.width * hitWidthScale;
    CGFloat height = self.bounds.size.height ;
    self.hitEdgeInsets = UIEdgeInsetsMake(-height, -width,-height, -width);
    objc_setAssociatedObject(self, kHitWidthScale, @(hitWidthScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



-(void)setHitHeightScale:(CGFloat)hitHeightScale{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height * hitHeightScale ;
    self.hitEdgeInsets = UIEdgeInsetsMake(-height, -width,-height, -width);
    objc_setAssociatedObject(self, kHitHeightScale, @(hitHeightScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - get Method
-(UIEdgeInsets)hitEdgeInsets{
    NSValue *value = objc_getAssociatedObject(self, kHitEdgeInsets);
    UIEdgeInsets edgeInsets;
    [value getValue:&edgeInsets];
    return value ? edgeInsets:UIEdgeInsetsZero;
}

-(CGFloat)hitScale{
    return [objc_getAssociatedObject(self, kHitScale) floatValue];
}

-(CGFloat)hitWidthScale{
    return [objc_getAssociatedObject(self, kHitWidthScale) floatValue];
}

-(CGFloat)hitHeightScale{
    return [objc_getAssociatedObject(self, kHitHeightScale) floatValue];
}



#pragma mark - override super method
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    //如果 button 边界值无变化  失效 隐藏 或者透明 直接返回
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden || self.alpha == 0 ) {
        return [super pointInside:point withEvent:event];
    }else{
        CGRect relativeFrame = self.bounds;
        CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitEdgeInsets);
        return CGRectContainsPoint(hitFrame, point);
    }
}

/**
 *  获取常用的 UIButton
 *
 *  @param title      按钮文字
 *  @param titleColor 文字颜色
 *  @param font       字体
 *
 *  @return UIButton
 */
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 避免按钮图片拉伸
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    // 去掉按钮按下变灰的效果
    [button setAdjustsImageWhenHighlighted:NO];
    [button setBackgroundColor:[UIColor clearColor]];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        //        [button setTitle:title forState:UIControlStateHighlighted];
    }
    if (!titleColor) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (font) {
        button.titleLabel.font = font;
    } else {
        button.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return button;
}


/**
 *  获取带 image/title 的按钮 (左右排列)
 *
 *  @param image      image
 *  @param title      title
 *  @param titleColor 字体颜色
 *  @param font       font
 *  @param spacing    image和title的间隔
 *  @param type       排列方式
 *
 *  @return UIButton
 */
+ (UIButton *)buttonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font layoutType:(ButtonLayoutType)type spacing:(float)spacing
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    button.titleLabel.backgroundColor = button.backgroundColor;
    button.imageView.backgroundColor = button.backgroundColor;
    
    if (font) {
        button.titleLabel.font = font;
    }
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        float imageWidth = image.size.width;
        float titleWidth = 0;
        if (title && ![title isEqualToString:@""]) {
            NSDictionary *attrs = @{NSFontAttributeName:button.titleLabel.font};
            titleWidth = [[button currentTitle]sizeWithAttributes:attrs].width;
        }
        if (type == 0) {      // 图片左 整体居中
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -spacing/2.0f, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, spacing/2.0f, 0, 0)];
        }else if (type == 1){ // 图片左 整体居左
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, spacing, 0, 0)];
        }else if (type == 2){ // 图片左 整体居右
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, spacing)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }else if (type == 3){ // 图片右 整体居中
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.imageEdgeInsets = UIEdgeInsetsMake(0,titleWidth + spacing, 0, -(titleWidth + spacing));
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing), 0, imageWidth + spacing);
        }else if (type == 4){ // 图片右 整体居左
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.imageEdgeInsets = UIEdgeInsetsMake(0,titleWidth + spacing, 0, -(titleWidth + spacing));
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing), 0, imageWidth + spacing);
        }else if (type == 5){ // 图片右 整体居右
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            button.imageEdgeInsets = UIEdgeInsetsMake(0,titleWidth + spacing, 0, -(titleWidth + spacing));
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing), 0, imageWidth + spacing);
        }
    }
    return button;
}
+(UIButton *)buttonWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor font:(UIFont *)font radius:(CGFloat)radius title:(NSString *)title {
    UIButton *btn = [UIButton new];
    [btn setFrame:frame];
    [btn setBackgroundColor:bgColor];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.layer.cornerRadius = radius;
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

- (void)setBackgroundNormalColor:(UIColor *)normal andHighlightedColor:(UIColor *)highlighted {
    
    CGRect rect = self.bounds;
    //防止初始化之前没有设置frame或者使用自动布局而导致无背景图片
    if (!self.frame.size.width || !self.frame.size.height) {
        rect = CGRectMake(0, 0, 10, 10);
    }
    if (normal) {
        UIImage *normalColorImg = [self getColorImgWithColor:normal andRect:rect];
        [self setBackgroundImage:normalColorImg forState:UIControlStateNormal];
    }
    if (highlighted) {
        UIImage *highlightedColorImg =[self getColorImgWithColor:highlighted  andRect:rect];
        [self setBackgroundImage:highlightedColorImg forState:UIControlStateHighlighted];
    }
    self.layer.masksToBounds = YES;
    
}
- (UIImage *)getColorImgWithColor:(UIColor *)color andRect:(CGRect)rect {
    UIImage *img;
    CGSize size = rect.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
