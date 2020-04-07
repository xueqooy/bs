//
//  FEProportionProgressBar.h
//  smartapp
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 xueqooy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEProportionProgressBar : UIView
@property(nonatomic, copy, readonly) NSString *leftTitle;
@property(nonatomic, copy, readonly) NSString *rightTitle;
@property(nonatomic, assign, readonly) CGFloat leftPercent;
@property(nonatomic, assign, readonly) CGFloat rightPercent;

- (void)setLeftTitle:(NSString *)leftTitle byPercent:(CGFloat)leftPercent andRightTitle:(NSString *)rightTitle byPercent:(CGFloat)rightPercent;
@end

