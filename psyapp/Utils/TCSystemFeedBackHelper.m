//
//  TCSystemFeedBackHelper.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/23.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCSystemFeedbackHelper.h"

@implementation TCSystemFeedbackHelper
+ (void)sound1519 {
    AudioServicesPlaySystemSound(1519);
}

+ (void)sound1520 {
    AudioServicesPlaySystemSound(1520);
}

+ (void)sound1521 {
    AudioServicesPlaySystemSound(1521);
}

+ (void)impactSoft {
    if (@available(iOS 13.0, *)) {
        [self impactFeedbackGeneratorWithStyle:UIImpactFeedbackStyleSoft];
    }
}

+ (void)impactRigid {
    if (@available(iOS 13.0, *)) {
        [self impactFeedbackGeneratorWithStyle:UIImpactFeedbackStyleRigid];
    }
}

+ (void)impactLight {
    [self impactFeedbackGeneratorWithStyle:UIImpactFeedbackStyleLight];
}

+ (void)impactMedium {
    [self impactFeedbackGeneratorWithStyle:UIImpactFeedbackStyleMedium];
}

+ (void)impactHeavy {
    [self impactFeedbackGeneratorWithStyle:UIImpactFeedbackStyleHeavy];
}

+ (void)impactFeedbackGeneratorWithStyle:(UIImpactFeedbackStyle)style {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
        [generator impactOccurred];
    }
}
@end
