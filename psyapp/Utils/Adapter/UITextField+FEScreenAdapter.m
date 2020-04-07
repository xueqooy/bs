//
//  UITextField+FEScreenAdapter.m
//  smartapp
//
//  Created by mac on 2019/9/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UITextField+FEScreenAdapter.h"
#import "NSObject+Utils.h"
#import "SizeTool.h"

@implementation UITextField (FEScreenAdapter)
+ (void)load {
    [self swizzleMethod:@selector(awakeFromNib) swizzledSelector:@selector(fe_awakeFromNib)];
}

- (void)fe_awakeFromNib {
    [self fe_awakeFromNib];
    self.font = [UIFont fontWithDescriptor:self.font .fontDescriptor size:STWidth(self.font.pointSize)];
}
@end
