//
//  FEReportMoreButton.h
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEUIComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEReportMoreButton : FEUIComponent
@property (nonatomic, copy) void (^buttonClickHandler)(void);
- (instancetype)initWithButtonTitle:(NSString *)buttonTitle;
@end

NS_ASSUME_NONNULL_END
