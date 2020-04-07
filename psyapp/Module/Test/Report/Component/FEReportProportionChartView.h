//
//  FEReportProportionChartView.h
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEUIComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEReportProportionChartView : FEUIComponent
- (instancetype)initWithLeftName:(NSString *)leftName leftPercent:(CGFloat)leftPercent rightName:(NSString *)rightName rightPercent:(CGFloat)rightPercent;
@end

NS_ASSUME_NONNULL_END
