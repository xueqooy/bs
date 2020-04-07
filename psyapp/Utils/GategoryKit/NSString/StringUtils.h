//
//  StringUtils.h
//  smartapp
//
//  Created by lafang on 2018/9/4.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StringUtils : NSObject

+ (NSMutableAttributedString *)setHtmlStr:(NSString *)html;

+ (NSMutableAttributedString *)setHtmlStr:(NSString *)html font:(CGFloat)font;

+ (NSMutableAttributedString *)setHtmlStrCenter:(NSString *)html font:(CGFloat)font;

+ (NSMutableAttributedString *)setupAttributedString:(NSString *)text;

+ (NSMutableAttributedString *)setupAttributedString:(NSString *)text font:(CGFloat)font;

+ (NSMutableAttributedString *)setupAttributedString:(NSString *)text font:(CGFloat)font weight:(UIFontWeight)weight;

+ (NSMutableAttributedString *)setupAttributedString:(NSString *)text font:(CGFloat)font lineSpacing:(NSInteger)lineSpacing paragraphSpacing:(NSInteger)paragraphSpacing;

+ (void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label;

+ (CGSize) addHeightBySize:(UILabel *) label width:(CGFloat)width;

+ (NSString *) md5:(NSString *) str;

+(BOOL)isEmptyStr:(NSString *)str;

+(UILabel *)createLabel:(NSString *)text color:(NSString *)color font:(CGFloat)font;

+(UIButton *)createButton:(NSString *)text color:(NSString *)color font:(CGFloat)font;


+ (CGFloat)heightForAttributedString:(NSAttributedString *)string onWidth:(CGFloat)width;
@end
