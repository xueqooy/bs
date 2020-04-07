//
//  FEBaseViewController+CustomTitleTransition.h
//  smartapp
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEBaseViewController (CustomTitleTransition)
 
@property (nonatomic, strong) UILabel *customTitleLabel;
- (void)customTitleTransitionWithPercent:(CGFloat)percent;
- (UILabel *)defaultCustomTitleLabel;
@end

NS_ASSUME_NONNULL_END
