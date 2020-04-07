//
//  UILabel+FEScreenAdapter.m
//  smartapp
//
//  Created by mac on 2019/9/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UILabel+FEScreenAdapter.h"
#import "NSObject+Utils.h"
#import "SizeTool.h"
static char *originalFontSizeEnableKey = "originalFontSizeEnableKey";

@implementation UILabel (FEScreenAdapter)
+ (void)load {
    [self swizzleMethod:@selector(awakeFromNib) swizzledSelector:@selector(fe_awakeFromNib)];
}

- (void)fe_awakeFromNib {
    [self fe_awakeFromNib];
    if (NO == self.originalFontSizeEnable) {
        self.font = [UIFont fontWithDescriptor:self.font.fontDescriptor size:STWidth(self.font.pointSize)];
    }
}

- (BOOL)originalFontSizeEnable {
    NSNumber *obj = objc_getAssociatedObject(self, originalFontSizeEnableKey);
    return obj.boolValue;
}

- (void)setOriginalFontSizeEnable:(BOOL)originalFontSizeEnable {
    NSNumber *obj = @(originalFontSizeEnable);
    objc_setAssociatedObject(self, originalFontSizeEnableKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
@end
