//
//  UITextView+FEScreenAdapter.m
//  smartapp
//
//  Created by mac on 2019/9/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UITextView+FEScreenAdapter.h"
#import "NSObject+Utils.h"
#import "SizeTool.h"

@implementation UITextView (FEScreenAdapter)
+ (void)load {
    [self swizzleMethod:@selector(awakeFromNib) swizzledSelector:@selector(fe_awakeFromNib)];
}

- (void)fe_awakeFromNib {
    [self fe_awakeFromNib];
    self.font = [UIFont fontWithDescriptor:self.font .fontDescriptor size:STWidth(self.font.pointSize)];
}
@end
