//
//  FEChartViewManager.h
//  smartapp
//
//  Created by lafang on 2018/9/4.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAChartKit.h"
#import "ChartDatasModel.h"
#import "ChartItemsModel.h"
#import "ChartDatasDynamicModel.h"
#import "UniversityGraduationSettledModel.h"
#import "StudentDataModel.h"
#import "StudentRatioModel.h"
#import "CareerChartDataModel.h"
#import "SubjectCountModel.h"


#define COMMON_CHART_HEIGHT ([[UIScreen mainScreen] bounds].size.height)*2/5

@interface FEChartViewManager : NSObject

+ (AAChartView *) addChartViewByType:(UIView *)addView reportData:(ChartDatasModel*) reportData;

+ (AAChartView *) addChartViewDynaByType:(UIView *)addView reportData:(ChartDatasDynamicModel*) reportData;//雷达图

+ (AAChartView *) addChartViewByGraduation:(UIView *)addView reportData:(NSArray<UniversityGraduationSettledModel *> *) items;//学校毕业信息就业率图表

+ (AAChartView *) addChartViewBySubject:(UIView *)addView reportData:(NSArray<SubjectCountModel *> *) items;//选科统计


+ (AAChartView *) addChartViewPieByType:(UIView *)addView studentDataModel:(StudentDataModel*) studentDataModel;//高校详情在校生数据-扇形图

+(AAChartView *)addChartViewCareerByType:(UIView *)addView reportData:(CareerChartDataModel *)reportData;

@end
