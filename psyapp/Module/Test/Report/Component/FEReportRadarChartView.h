//
//  FEReportRadarChartView.h
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEUIComponent.h"
#import "CareerChartDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FEReportRadarChartView : FEUIComponent
- (instancetype)initWithChartData:(CareerChartDataModel *)chartData size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
