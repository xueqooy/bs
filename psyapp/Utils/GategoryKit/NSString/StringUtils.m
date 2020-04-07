//
//  StringUtils.m
//  smartapp
//
//  Created by lafang on 2018/9/4.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "StringUtils.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImageView+WebCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "FEBaseViewController.h"

@implementation StringUtils

//富文本字符串生产label展示的富文本
+ (NSMutableAttributedString *)setHtmlStr:(NSString *)html {
    
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]} range:NSMakeRange(0, attr.string.length)];
    
    [attr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attr.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if ([value isKindOfClass:[NSTextAttachment class]]) {
            NSTextAttachment * attachment = value;
            CGFloat width = attachment.bounds.size.width;
            CGFloat height = attachment.bounds.size.height;
            CGFloat w = mScreenWidth-20;
            CGFloat h = w * height/width;
            attachment.bounds = CGRectMake(0, 0, w, h);
        }
        
    }];
    
    return attr;
    
}

//富文本字符串生产label展示的富文本  可修改字体大小
+ (NSMutableAttributedString *)setHtmlStr:(NSString *)html font:(CGFloat)font{
    
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} range:NSMakeRange(0, attr.string.length)];
    
    [attr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attr.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if ([value isKindOfClass:[NSTextAttachment class]]) {
            NSTextAttachment * attachment = value;
            CGFloat width = attachment.bounds.size.width;
            CGFloat height = attachment.bounds.size.height;
            CGFloat w = mScreenWidth-20;
            CGFloat h = w * height/width;
            attachment.bounds = CGRectMake(0, 0, w, h);
        }
        
    }];
    
    return attr;
    
}

+ (NSMutableAttributedString *)setHtmlStrCenter:(NSString *)html font:(CGFloat)font{
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} range:NSMakeRange(0, attr.string.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];//富文本居中
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.string.length)];
    
    [attr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attr.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if ([value isKindOfClass:[NSTextAttachment class]]) {
            NSTextAttachment * attachment = value;
            CGFloat width = attachment.bounds.size.width;
            CGFloat height = attachment.bounds.size.height;
            CGFloat w = mScreenWidth-20;
            CGFloat h = w * height/width;
            attachment.bounds = CGRectMake(0, 0, w, h);
        }
        
    }];
    
    return attr;
}

+ (NSMutableAttributedString *)setupAttributedString:(NSString *)text {
    
    NSMutableDictionary *attrsDic = [NSMutableDictionary dictionary];

    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.paragraphSpacing = 10;
    
    attrsDic[NSParagraphStyleAttributeName] = paragraphStyle;
    
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:attrsDic range:NSMakeRange(0, attr.string.length)];
    
    [attr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attr.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if ([value isKindOfClass:[NSTextAttachment class]]) {
            NSTextAttachment * attachment = value;
            CGFloat width = attachment.bounds.size.width;
            CGFloat height = attachment.bounds.size.height;
            CGFloat w = mScreenWidth-20;
            CGFloat h = w * height/width;
            if(width>w){
                attachment.bounds = CGRectMake(0, 0, w, h);
            }else{
//                attachment.bounds = CGRectMake((w-width)/2, 0, width, height);//设置X偏移位置无效
                attachment.bounds = CGRectMake(0, 0, width, height);
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setAlignment:NSTextAlignmentCenter];//富文本居中
                [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
            }
            
        }
        
    }];
    
    return attr;
    
}

+ (NSMutableAttributedString *)setupAttributedString:(NSString *)text font:(CGFloat)font weight:(UIFontWeight)weight {
    NSMutableDictionary *attrsDic = [NSMutableDictionary dictionary];
        //文字背景色
    //    attrsDic[NSBackgroundColorAttributeName] = [UIColor redColor];
        //段落样式
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //行间距
        paragraphStyle.lineSpacing = 6;
        paragraphStyle.paragraphSpacing = 10;
        
        attrsDic[NSParagraphStyleAttributeName] = paragraphStyle;
        //文字颜色
    //    attrsDic[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"666666"];
        
        attrsDic[NSFontAttributeName] = [UIFont systemFontOfSize:font weight:weight];
        
        NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
        [attr addAttributes:attrsDic range:NSMakeRange(0, attr.string.length)];
        
        [attr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attr.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            
            if ([value isKindOfClass:[NSTextAttachment class]]) {
                NSTextAttachment * attachment = value;
                CGFloat width = attachment.bounds.size.width;
                CGFloat height = attachment.bounds.size.height;
                CGFloat w = mScreenWidth-20;
                CGFloat h = w * height/width;
                if(width>w){
                    attachment.bounds = CGRectMake(0, 0, w, h);
                }else{
                    attachment.bounds = CGRectMake((w-width)/2, 0, w, h);
                }
                
            }
            
        }];
        
        return attr;
}

+ (NSMutableAttributedString *)setupAttributedString:(NSString *)text font:(CGFloat)font {
    
    return [self setupAttributedString:text font:font weight:UIFontWeightRegular];
    
}

+ (NSMutableAttributedString *)setupAttributedString:(NSString *)text font:(CGFloat)font lineSpacing:(NSInteger)lineSpacing paragraphSpacing:(NSInteger)paragraphSpacing{
    
    NSMutableDictionary *attrsDic = [NSMutableDictionary dictionary];
    //文字背景色
    //    attrsDic[NSBackgroundColorAttributeName] = [UIColor redColor];
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.paragraphSpacing = paragraphSpacing;
    
    attrsDic[NSParagraphStyleAttributeName] = paragraphStyle;
    //文字颜色
    attrsDic[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"999999"];
    
    attrsDic[NSFontAttributeName] = [UIFont systemFontOfSize:font];
    

    
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:attrsDic range:NSMakeRange(0, attr.string.length)];
    
    [attr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attr.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if ([value isKindOfClass:[NSTextAttachment class]]) {
            NSTextAttachment * attachment = value;
            CGFloat width = attachment.bounds.size.width;
            CGFloat height = attachment.bounds.size.height;
            CGFloat w = mScreenWidth-20;
            CGFloat h = w * height/width;
            if(width>w){
                attachment.bounds = CGRectMake(0, 0, w, h);
            }else{
                attachment.bounds = CGRectMake((w-width)/2, 0, w, h);
            }
            
        }
        
    }];
    
    return attr;
    
}



/**
 设置固定行间距文本
 
 @param lineSpace 行间距
 @param text 文本内容
 @param label 要设置的label
 */
+ (void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}


//计算label展示文本需要的精确高度
+ (CGSize) addHeightBySize:(UILabel *) label width:(CGFloat)width{
    CGSize size= [label sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    return size;
}


//MD5加密字符串
+ (NSString *) md5:(NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(BOOL)isEmptyStr:(NSString *)str{
    if(str && ![str isEqualToString:@""]){
        return NO;
    }
    
    return YES;
}



+(UILabel *)createLabel:(NSString *)text color:(NSString *)color font:(CGFloat)font{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor colorWithHexString:color];
    label.font = [UIFont systemFontOfSize:font];
    
    return label;
}

+(UIButton *)createButton:(NSString *)text color:(NSString *)color font:(CGFloat)font{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    
    return btn;
}


+ (CGFloat)heightForAttributedString:(NSAttributedString *)string onWidth:(CGFloat)width {
    CGFloat height = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size.height;
    return height;
}
@end
