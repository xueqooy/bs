//
//  UIViewController+LookinDebug.m
//  CheersgeniePlus
//
//  Created by mac on 2020/4/3.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "UIViewController+LookinDebug.h"


@implementation UIViewController (LookinDebug)
+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtendImplementationOfVoidMethodWithSingleArgument(self.class, @selector(viewDidAppear:), BOOL, ^(UIViewController *selfObject, BOOL animated){
            [selfObject becomeFirstResponder];
        });

        ExtendImplementationOfVoidMethodWithSingleArgument(self.class, @selector(viewDidAppear:), BOOL, ^(UIViewController *selfObject, BOOL animated){
            [selfObject resignFirstResponder];
        });
    });
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {

    if (motion == UIEventSubtypeMotionShake) {
        QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:@"摇什么摇" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
        alert.alertTitleAttributes = @{
            NSFontAttributeName : STFontBold(16),
            NSForegroundColorAttributeName : UIColor.fe_mainColor,
        };

        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"导出" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
        }];

        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"2D" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
        }];

        QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"3D" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
        }];

        QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {

        }];

        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [alert addAction:action4];

        [alert showWithAnimated:YES];
    }
}
@end
