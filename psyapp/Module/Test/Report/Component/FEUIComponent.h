//
//  FEUIComponent.h
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEUIComponent : UIView
- (void)build;
- (void)setBackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;
@property (nonatomic, assign, setter = setEmpty:) BOOL isEmpty;
@end

@interface FEUIComponent (EmptyInstance)
+ (instancetype)emptyInstance;
@end

@interface FEUIComponent(Contraint)
- (void)updateContraintsForComponent:(FEUIComponent *)component;
- (void)removeAllContraints; // 移除相对于父视图以及所有子视图相对于自身的所有约束
- (void)removeContraintsInSuper;
@end
NS_ASSUME_NONNULL_END
