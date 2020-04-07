//
//  UILabel+FEChain.m
//  smartapp
//
//  Created by mac on 2019/8/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UILabel+FEChain.h"

@implementation UILabel (FEChain)
+ (UILabel *)create:(void (^)(UILabel * _Nonnull))block addTo:(UIView *)view {
    UILabel *label = [UILabel new];
    if (view != nil) {
        [view addSubview:label];
    }
    block(label);
    return label;
}
- (UILabel *(^)(NSString *))textIs {
    return ^(NSString *text) {
        self.text = text;
        return self;
    };
}
- (UILabel *(^)(CGRect))frameIs {
    return ^(CGRect frame) {
        self.frame = frame;
        return self;
    };
}
- (UILabel *(^)(UIColor *))textColorIs{
    return ^(UIColor *textColor) {
        self.textColor = textColor;
        return self;
    };
}
- (UILabel *(^)(UIColor *))backgroundColorIs{
    return ^(UIColor *backgroundColor) {
        self.layer.backgroundColor = backgroundColor.CGColor;
        return self;
    };
}
- (UILabel *(^)(NSTextAlignment))textAlignmentIs{
    return ^(NSTextAlignment textAlignment) {
        self.textAlignment = textAlignment;
        return self;
    };
}
- (UILabel *(^)(NSInteger))numberOfLinesIs{
    return ^(NSInteger numberOfLines) {
        self.numberOfLines = numberOfLines;
        return self;
    };
}
- (UILabel *(^)(UIFont *))fontIs{
    return ^(UIFont *font) {
        self.font = font;
        return self;
    };
}
- (UILabel *(^)(CGFloat cornerRadius))cornerRadiusIs{
    return ^(CGFloat cornerRadius) {
        self.layer.cornerRadius = cornerRadius;
        return self;
    };
}

-  (UILabel * (^)(NSAttributedString *))attributedTextIs{
    return ^(NSAttributedString * attributedText) {
        self.attributedText = attributedText;
        return self;
    };
}
@end
