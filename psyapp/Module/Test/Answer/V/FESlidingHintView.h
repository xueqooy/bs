//
//  FESlidingHintView.h
//  smartapp
//
//  Created by mac on 2019/10/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FESlidingHintView : UIView

+ (void)showNext;
+ (void)showPrevious;

+ (void)showNextWithHint:(NSString *)hint;
+ (void)showPreviousWithHint:(NSString *)hint;

+ (void)show;
+ (void)hide;
@end

NS_ASSUME_NONNULL_END
