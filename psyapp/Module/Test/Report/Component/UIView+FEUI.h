//
//  UIView+FEUI.h
//  smartapp
//
//  Created by mac on 2019/12/16.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FEUIContainer;
NS_ASSUME_NONNULL_BEGIN

@interface UIView (FEUI)
- (void)feui_addRootContainer:(FEUIContainer *)container padding:(UIEdgeInsets)padding;
@end

NS_ASSUME_NONNULL_END
