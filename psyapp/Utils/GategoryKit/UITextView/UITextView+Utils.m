//
//  UITextView+Utils.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/9.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "UITextView+Utils.h"

@implementation UITextView (Utils)
- (void)setHtmlText:(NSString *)text lineSpacing:(CGFloat)lineSpacing {
    if  ([NSString isEmptyString:text]) return;
    if (lineSpacing < 0.01) return;
    UIFont *font = self.font;
    UIColor *textColor = self.textColor;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
//    [paragraphStyle setLineBreakMode:self.bre];
    [paragraphStyle setAlignment:self.textAlignment];

    NSMutableDictionary *attrsDic = [NSMutableDictionary dictionary];
    attrsDic[NSParagraphStyleAttributeName] = paragraphStyle;
    attrsDic[NSForegroundColorAttributeName] = textColor;
    attrsDic[NSFontAttributeName] = font;
    [attrStr addAttributes:attrsDic range:NSMakeRange(0, attrStr.string.length)];

    self.attributedText = attrStr;
}
@end
