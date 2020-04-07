//
//  UILabel+Utils.m
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/16.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "UILabel+Utils.h"

@implementation UILabel (Utils)
- (CGFloat)getTextWidthForFontSize:(CGFloat)size height:(CGFloat)height{
    
    CGRect textRect = [self.text boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil];
    CGFloat width = textRect.size.width;
    return width;
}

+ (UILabel *)createLabelWithDefaultText:(NSString *)text
                          numberOfLines:(NSInteger)nof
                              textColor:(UIColor *)textColor
                                   font:(UIFont *)font {
    UILabel *aLabel = [UILabel new];
    aLabel.text = text;
    aLabel.numberOfLines = nof;
    aLabel.textColor = textColor;
    aLabel.font = font;
    return aLabel;
}

-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (!text || lineSpacing < 0.01) {
        self.text = text;
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];        //设置行间距
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
}

- (void)setHtmlText:(NSString *)text lineSpacing:(CGFloat)lineSpacing {
    if  ([NSString isEmptyString:text]) return;
    if (lineSpacing < 0.01) return;
    UIFont *font = self.font;
    UIColor *textColor = self.textColor;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];

    NSMutableDictionary *attrsDic = [NSMutableDictionary dictionary];
    attrsDic[NSParagraphStyleAttributeName] = paragraphStyle;
    attrsDic[NSForegroundColorAttributeName] = textColor;
    attrsDic[NSFontAttributeName] = font;
    [attrStr addAttributes:attrsDic range:NSMakeRange(0, attrStr.string.length)];

    self.attributedText = attrStr;
}



//NSMutableDictionary *attrsDic = [NSMutableDictionary dictionary];
//   //文字背景色
//   //    attrsDic[NSBackgroundColorAttributeName] = [UIColor redColor];
//   //段落样式
//   NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//   //行间距
//   paragraphStyle.lineSpacing = lineSpacing;
//   paragraphStyle.paragraphSpacing = paragraphSpacing;
//
//   attrsDic[NSParagraphStyleAttributeName] = paragraphStyle;
//   //文字颜色
//   attrsDic[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"999999"];
//
//   attrsDic[NSFontAttributeName] = [UIFont systemFontOfSize:font];
//
//
//
//   NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//
//   NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
//   [attr addAttributes:attrsDic range:NSMakeRange(0, attr.string.length)
@end
