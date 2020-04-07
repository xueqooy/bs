//
//  FEReportRadarChartView.m
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportRadarChartView.h"
#import "AAChartKit.h"

@implementation FEReportRadarChartView {
    CareerChartDataModel *_chartData;
    
    CGSize _size;
}
- (instancetype)initWithChartData:(CareerChartDataModel *)chartData size:(CGSize)size{
    self = [super init];
    _chartData = chartData;
    _size = size;
    [self build];
    return self;
}
- (void)build {
    //过滤数据
    NSMutableArray <CareerChartDataItemModel *> *filteredData = @[].mutableCopy;
    for (CareerChartDataItemModel *item in _chartData.items) {
        if (item.chartDatas.count > 0) {
            [filteredData addObject:item];
        }
    }
    
     BOOL isDarkMode = [[FEThemeManager currentTheme].themeName isEqualToString:FEThemeConfigureDarkIdentifier];
    
    NSMutableArray<NSMutableArray *> *dataPoints = [[NSMutableArray<NSMutableArray *> alloc] init];//点集合
    NSMutableArray *chartCategories = [[NSMutableArray alloc] init];
    NSMutableArray *arraySeries = [[NSMutableArray alloc] init];
    NSMutableArray *dataLineColor = [[NSMutableArray alloc] init];
    [dataLineColor addObject:@"#f9751c"];
    [dataLineColor addObject:@"#FFB245"];
    for(int i=0;i < filteredData.count;i++){
        NSMutableArray * array = [[NSMutableArray alloc] init];
        NSArray<CareerChartDataChildModel *> *itemDatas = filteredData[i].chartDatas;
        for(int j=0;j<itemDatas.count;j++){
            CareerChartDataChildModel *itemData = itemDatas[j];
            double x = [itemData.score doubleValue];
            [array addObject:[NSNumber numberWithDouble:x]];
            [chartCategories addObject:(itemData.itemName ? itemData.itemName : @"")];
        }
        [dataPoints addObject:array];
        
        [arraySeries addObject:AAObject(AASeriesElement)
         .nameSet(filteredData[i].compareName)
         .dataSet(array)
        ];
    }
    
    AAChartType chartType = AAChartTypeArea;
    
    AAChartModel *chartModel = AAObject(AAChartModel)
    .chartTypeSet(chartType)
    .animationDurationSet(@25)
    .titleSet(@"")
    .subtitleSet(@"")
    .yAxisLineWidthSet(@0)
    .colorsThemeSet(dataLineColor)
    .yAxisTitleSet(@"")//设置 Y 轴标题
    .tooltipValueSuffixSet(@"")//设置浮动提示框单位后缀
    .backgroundColorSet(isDarkMode ? @"#1a1513" : @"#ffffff")
    .seriesSet(arraySeries)
    .legendEnabledSet(NO)
    .gradientColorEnabledSet(YES)
    .xAxisLabelsFontColorSet(isDarkMode? @"#ffffff99" : @"#303133")
    .xAxisLabelsFontSizeSet(@9)
    .xAxisLabelsFontWeightSet(@"bold")
    .polarSet(YES)
    .symbolSet(AAChartSymbolTypeCircle)
    .xAxisLabelsEnabledSet(YES)
    .categoriesSet(chartCategories)
    .symbolStyleSet(AAChartSymbolStyleTypeBorderBlank)
    .xAxisCrosshairWidthSet(@1)
    .xAxisCrosshairColorSet(isDarkMode? @"#99542a":@"#FFB245")
    .xAxisCrosshairDashStyleTypeSet(AALineDashSyleTypeLongDashDotDot)
    .yAxisGridLineWidthSet(@1)
    .xAxisGridLineWidthSet(@1)

    ;
    
    AAOptions *chartOptions = [AAOptionsConstructor configureChartOptionsWithAAChartModel:chartModel];
    chartOptions.xAxis.lineWidth = @0;
    chartOptions.yAxis.gridLineInterpolation = AAYAxisGridLineInterpolationPolygon;
    
    AAChartView *chartView = [AAChartView new];
    chartView.frame = CGRectMake(0, 0, _size.width, _size.height);
    chartView.scrollEnabled = NO;
    chartView.isClearBackgroundColor = YES;
    [chartView aa_drawChartWithOptions:chartOptions];
    [self addSubview:chartView];
    [chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_size);
        make.centerX.offset(0);
        make.top.bottom.offset(0);
    }];
}

- (void)rebuild {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self build];
}

- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    [self rebuild];
}

@end
