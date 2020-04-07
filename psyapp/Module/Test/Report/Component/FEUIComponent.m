//
//  FEUIComponent.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEUIComponent.h"

@implementation FEUIComponent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setEmpty:NO];
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius {
    self.backgroundColor = backgroundColor;
    self.layer.cornerRadius = cornerRadius;
}

- (void)build {
}

- (void)setEmpty:(BOOL)isEmpty {
    if (_isEmpty == isEmpty) {
        return;
    }
    _isEmpty = isEmpty;
    if ([self.superview isKindOfClass:[FEUIComponent class]]) {
        [((FEUIComponent *)self.superview) updateContraintsForComponent:self];
    }
}


@end

@implementation FEUIComponent (EmptyInstance)
+ (instancetype)emptyInstance {
    static FEUIComponent *sharedEmptyInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEmptyInstance = [FEUIComponent new];
        [sharedEmptyInstance setEmpty:YES];
    });
    return sharedEmptyInstance;
}
@end

@implementation FEUIComponent (Contraint)

- (void)updateContraintsForComponent:(FEUIComponent *)component {
}

- (void)removeAllContraints {
    [self removeConstraints:self.constraints];
    [self removeContraintsInSuper];
}

- (void)removeContraintsInSuper {
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if ([constraint.firstItem isEqual:self]) {
            [self.superview removeConstraint:constraint];
        }
    }
}

@end
