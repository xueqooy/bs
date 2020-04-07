//
//  UILabel+Utils.h
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/16.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Utils)
- (CGFloat)getTextWidthForFontSize:(CGFloat)size height:(CGFloat)height;

+ (UILabel *)createLabelWithDefaultText:(NSString *)text
                          numberOfLines:(NSInteger)nof
                              textColor:(UIColor *)textColor
                                   font:(UIFont *)font;
-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;
- (void)setHtmlText:(NSString *)text lineSpacing:(CGFloat)lineSpacing ;
@end

NS_ASSUME_NONNULL_END
