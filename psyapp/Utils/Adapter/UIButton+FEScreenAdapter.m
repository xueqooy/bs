//
//  UIButton+FEScreenAdapter.m
//  smartapp
//
//  Created by mac on 2019/9/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UIButton+FEScreenAdapter.h"
#import "NSObject+Utils.h"
#import "SizeTool.h"

@implementation UIButton (FEScreenAdapter)
+ (void)load {
    [self swizzleMethod:@selector(awakeFromNib) swizzledSelector:@selector(fe_awakeFromNib)];
}

- (void)fe_awakeFromNib {
    [self fe_awakeFromNib];
    self.titleLabel.font = [UIFont fontWithDescriptor:self.titleLabel.font.fontDescriptor size:STWidth(self.titleLabel.font.pointSize)];
}
@end
