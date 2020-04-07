//
//  FECommonButton.m
//  smartapp
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "TCCommonButton.h"
#import "FastClickUtils.h"
@interface TCCommonButton() <CAAnimationDelegate>
@end
@implementation TCCommonButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.fe_mainColor;
        self.titleLabel.font = STFontBold(16);
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return self;
}

- (BOOL)isTouchInside {
    if (_avoidsFastClickDisabled) return YES;
    if ([FastClickUtils isFastClickForObj:self]) {
        return NO;
    };

    return YES;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        self.transform = CGAffineTransformMakeScale(0.98, 0.98);
        self.alpha = 0.9f;
        
    } else {
        [UIView animateWithDuration:0.02 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1.f;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (self.adjustCornerRound) {
        self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    }
}

- (void)setAdjustCornerRound:(BOOL)adjustCornerRound {
    _adjustCornerRound = adjustCornerRound;
    [self setNeedsLayout];
}
@end
