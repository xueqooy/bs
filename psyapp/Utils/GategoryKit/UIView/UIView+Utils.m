//
//  UIView+CodeFragments.m
//  CodeFragment
//
//  Created by jinyu on 15/2/4.
//  Copyright (c) 2015年 jinyu. All rights reserved.
//

#import "UIView+Utils.h"
#import <objc/runtime.h>

static char kDTActionHandlerTapBlockKey;
static char kDTActionHandlerTapGestureKey;
static char kDTActionHandlerLongPressBlockKey;
static char kDTActionHandlerLongPressGestureKey;

@implementation UIView (Utils)


+ (void)shakeView:(UIView*)viewToShake {
    // 偏移值
    CGFloat t = 3.0;
    // 左摇
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    // 右晃
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    // 执行动画 重复动画且执行动画回路
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        // 设置重复次数 repeatCount为float
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
        
    } completion:^(BOOL finished){
        if(finished){
            // 从视图当前状态回到初始状态
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

#pragma mark - frame
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)top {
    return self.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left {
    return self.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right {
    return self.left + self.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.top + self.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    
    frame.size.height = height;
    self.frame = frame;
}


- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark - bounds

- (CGSize)boundsSize {
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)size {
    CGRect bounds = self.bounds;
    
    bounds.size = size;
    self.bounds = bounds;
}

- (CGFloat)boundsWidth {
    return self.boundsSize.width;
}

- (void)setBoundsWidth:(CGFloat)width {
    CGRect bounds = self.bounds;
    
    bounds.size.width = width;
    self.bounds = bounds;
}

- (CGFloat)boundsHeight {
    return self.boundsSize.height;
}

- (void)setBoundsHeight:(CGFloat)height {
    CGRect bounds = self.bounds;
    
    bounds.size.height = height;
    self.bounds = bounds;
}

#pragma mark - content getters

- (CGRect)contentBounds {
    return CGRectMake(0.0f, 0.0f, self.boundsWidth, self.boundsHeight);
}

- (CGPoint)contentCenter {
    return CGPointMake(self.boundsWidth / 2.0f, self.boundsHeight / 2.0f);
}

#pragma mark - gesture
- (void)addTapGestureWithBlock:(void (^)(void))block {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void (^ action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        
        if (action) {
            action();
        }
    }
}

- (void)addLongPressGestureWithBlock:(void (^)(void))block {
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerLongPressGestureKey);
    
    if (!gesture) {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        void (^ action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerLongPressBlockKey);
        
        if (action) {
            action();
        }
    }
}

#pragma mark - corner&shadow

-(void)setCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor{
    
    if (borderColor) {self.layer.borderColor=borderColor.CGColor;}
    if (borderWidth) {self.layer.borderWidth=borderWidth;}
    if (cornerRadius) {self.layer.cornerRadius=cornerRadius;}
    self.layer.masksToBounds=YES;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth=borderWidth;
}
-(void)setBorderColor:(UIColor*)borderColor{
    self.layer.borderColor=borderColor.CGColor;
}
-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius=cornerRadius;
    self.layer.masksToBounds=YES;
}
-(void)setCornerRound{
    self.layer.cornerRadius=self.width/2;
    self.layer.masksToBounds=YES;
}


- (void)util_setRadius:(float)radius forCorners:(UIRectCorner)corners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


- (void)setShadowWithColor:(ShadowColor)shadowColor cornerRadius:(float)radius
{
    if (radius > 0) {
        self.layer.cornerRadius = radius;
    }
    self.layer.masksToBounds = YES;             // 和下面一句的顺序不能错
    self.clipsToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 1); // 阴影的偏移 （扩散大于偏移就能达到四个边都有阴影）
    self.layer.shadowRadius = 1;                // 阴影的扩散程度
    if (shadowColor == ShadowColorBlack) { // 深色阴影
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 1;           // 阴影的透明度
    } else {                                // 浅色阴影
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOpacity = 0.7;           // 阴影的透明度
    }
}

- (UIImage *)snapsHotView {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,YES,[UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
