//
//  FEBaseViewController+CustomTitleTransition.m
//  smartapp
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "FEBaseViewController+CustomTitleTransition.h"
#import <QMUILab.h>
#import <QMUIRuntime.h>


@implementation FEBaseViewController (CustomTitleTransition)
QMUISynthesizeFloatProperty(customTitleTranstionPercent, setCustomTitleTranstionPercent)
QMUISynthesizeBOOLProperty(shouldHiddenBarShowdow, setShouldHiddenBarShowdow)
static char kAssociatedObjectKey_customTitleLabel;
- (void)setCustomTitleLabel:(id)customTitleLabel {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_customTitleLabel, customTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)customTitleLabel {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_customTitleLabel);
}


- (void)customTitleTransitionWithPercent:(CGFloat)percent {
    UIView *navigationBar = self.navigationController.navigationBar;
    
    if (!navigationBar) return;
    
    if (!self.customTitleLabel) return;
    
    if (![navigationBar.subviews containsObject:self.customTitleLabel]) return;
    
    if (self.customTitleTranstionPercent == percent) return;

    if (percent < 0) percent = 0.f;
    
    if (percent > 1) percent = 1.f;
    
    self.customTitleTranstionPercent = percent;
    
    [self _updateCustomTitleLabelWithPercent:percent];
    
}

- (void)_updateCustomTitleLabelWithPercent:(CGFloat)percent {
    if (!self.customTitleLabel) return;
    if (self.customTitleLabel.superview) {
        self.customTitleLabel.frame = CGRectMake(63, mNavBarHeight - 20.33 - 12 * percent, mScreenWidth - 2 * 63, 20.33);
//        [self.customTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.offset(- 12 * percent);//距离底部最大距离时12
//        }];
    } else {
        [self.navigationController.navigationBar addSubview:self.customTitleLabel];
        self.customTitleLabel.frame = CGRectMake(63, mNavBarHeight - 20.33 - 12 * percent, mScreenWidth - 2 * 63, 20.33);
//        [self.customTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.offset(0);
//            make.bottom.offset(- 12 * percent);
//            make.left.mas_greaterThanOrEqualTo(63);
//            make.right.mas_lessThanOrEqualTo(-15);
//        }];
    }
    
    
    self.customTitleLabel.alpha = percent;
    if (self.shouldHiddenBarShowdow == NO) {
        [self setNavigationBarShadowHidden:percent == 0];

    }
    
}

- (UILabel *)defaultCustomTitleLabel {
    UILabel *defaultCustomTitleLabel = [UILabel createLabelWithDefaultText:@"" numberOfLines:1 textColor:UIColor.whiteColor font:mFontBold(17)];
    defaultCustomTitleLabel.textAlignment = NSTextAlignmentCenter;
    return defaultCustomTitleLabel;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL extendMethod = @selector(init);
        SEL extendMethod1 = @selector(viewWillAppear:);
        SEL extendMethod2 = @selector(viewDidAppear:);
        SEL extendMethod3 = @selector(viewWillDisappear:);

        ExtendImplementationOfNonVoidMethodWithoutArguments([FEBaseViewController class], extendMethod, FEBaseViewController *, ^FEBaseViewController *(FEBaseViewController *selfObject, FEBaseViewController *returnValue){
            selfObject.customTitleTranstionPercent = 0;
            return returnValue;
        });
        
        ExtendImplementationOfVoidMethodWithSingleArgument([FEBaseViewController class], extendMethod1, BOOL, ^(FEBaseViewController *selfObject, BOOL animated) {
            UIView *navigationBar = selfObject.navigationController.navigationBar;
            selfObject.shouldHiddenBarShowdow = selfObject.navigationBarShadowHidden;
            if (selfObject.customTitleLabel && navigationBar && !navigationBar.hidden) {
                if (![navigationBar.subviews containsObject:selfObject.customTitleLabel]) {
                    selfObject.customTitleLabel.frame = CGRectMake(63, mNavBarHeight - 20.33, mScreenWidth - 63 * 2,  20.33);
                    [navigationBar addSubview:selfObject.customTitleLabel];
                    
//                    [selfObject.customTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.centerX.offset(0);
//                        make.bottom.offset(- 12 * selfObject.customTitleTranstionPercent);
//                        make.left.mas_greaterThanOrEqualTo(63);
//                        make.right.mas_lessThanOrEqualTo(-15);
//                    }];
                }
                //willAppear时隐藏，didAppear根据percent显示
                selfObject.customTitleLabel.alpha = 0;
                if (selfObject.shouldHiddenBarShowdow == NO) {
                    [selfObject setNavigationBarShadowHidden:YES];
                }
            }
        });
        
        ExtendImplementationOfVoidMethodWithSingleArgument([FEBaseViewController class], extendMethod2, BOOL, ^(FEBaseViewController *selfObject, BOOL animated) {
            UIView *navigationBar = selfObject.navigationController.navigationBar;
            if (selfObject.customTitleLabel && navigationBar && !navigationBar.hidden) {
                if (selfObject.customTitleTranstionPercent >= 0 && selfObject.customTitleTranstionPercent <= 1) {
                    //恢复界面disappear时的透明度
                    [UIView animateWithDuration:0.25 animations:^{
                        [selfObject _updateCustomTitleLabelWithPercent:selfObject.customTitleTranstionPercent];
//                        [navigationBar layoutIfNeeded];
                    }];
                }
            }
        });
        
        ExtendImplementationOfVoidMethodWithSingleArgument([FEBaseViewController class], extendMethod3, BOOL, ^(FEBaseViewController *selfObject, BOOL animated) {
            if (selfObject.customTitleLabel) {
                selfObject.customTitleLabel.alpha = 0;
                if (selfObject.shouldHiddenBarShowdow == NO)  {
                    [selfObject setNavigationBarShadowHidden:NO];
                }

                [selfObject.customTitleLabel removeFromSuperview];
            }
        });
    });
}
@end
