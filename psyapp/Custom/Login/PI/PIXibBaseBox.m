//
//  FESubxibBaseView.m
//  smartapp
//
//  Created by mac on 2019/10/31.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PIXibBaseBox.h"

@implementation PIXibBaseBox

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil].firstObject;
        view.frame = self.bounds;
        [self addSubview:view];
    }
    return self;
}
@end
