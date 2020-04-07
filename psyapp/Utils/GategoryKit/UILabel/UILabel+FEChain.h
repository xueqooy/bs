//
//  UILabel+FEChain.h
//  smartapp
//
//  Created by mac on 2019/8/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UILabel (FEChain)
+ (UILabel *)create:(void (^)(UILabel *label))block addTo:(UIView *)view;
- (UILabel *(^)(NSString *))textIs;
- (UILabel *(^)(UIColor *))textColorIs;
- (UILabel *(^)(CGRect))frameIs;
- (UILabel *(^)(UIColor *))backgroundColorIs;
- (UILabel *(^)(NSTextAlignment))textAlignmentIs;
- (UILabel *(^)(NSInteger))numberOfLinesIs;
- (UILabel *(^)(UIFont *))fontIs;
- (UILabel *(^)(CGFloat cornerRadius))cornerRadiusIs;
- (UILabel *(^)(NSAttributedString *attributedText))attributedTextIs;
@end


