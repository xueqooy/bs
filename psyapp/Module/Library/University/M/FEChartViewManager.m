//
//  FEChartViewManager.m
//  smartapp
//
//  Created by lafang on 2018/9/4.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEChartViewManager.h"

@implementation FEChartViewManager

+ (AAChartView *) addChartViewByType:(UIView *)addView reportData:(ChartDatasModel*) reportData{
    
    NSArray<ChartItemsModel *>* items = reportData.items;
    
    NSInteger type = [reportData.chartType integerValue];
    
    AAChartType chartType = [self getChartType:type];
    if(type == 2 && items.count<=2){
        chartType = AAChartTypeColumn;
    }
    
    AAChartView *aaChartView;
    
    CGFloat chartViewWidth  = addView.frame.size.width == 0 ?mScreenWidth-20 : addView.frame.size.width;
    CGFloat chartViewHeight = COMMON_CHART_HEIGHT;//addView.frame.size.height;
    aaChartView = [[AAChartView alloc]init];
    aaChartView.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    //    aaChartView.delegate = self;
    aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    [addView addSubview:aaChartView];
    
    NSMutableArray<NSMutableArray *> *dataPoints = [[NSMutableArray<NSMutableArray *> alloc] init];
    NSMutableArray *chartCategories = [[NSMutableArray alloc] init];
    
    NSInteger chartCount = 2;
    for(int i=0;i<2;i++){
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for(int j=0;j<items.count;j++){
            
            ChartItemsModel *item = items[j];
            if(i==0){
                double x = [item.childScore doubleValue];
                [array addObject:[NSNumber numberWithDouble:x]];
                [chartCategories addObject:(item.itemName ? item.itemName : @"")];
            }else{
                double x = [item.compareScore doubleValue];
                //对比数据为0，不显示对比图
                if(x == 0){
                    chartCount = 1;
                    break;
                }
                [array addObject:[NSNumber numberWithDouble:x]];
            }
            
        }
        [dataPoints addObject:array];
    }
    
    NSArray * arra;
    NSArray *dataLineColor;
    
    if(chartCount == 2){
        arra = [[NSArray alloc] initWithObjects:AAObject(AASeriesElement)
                .nameSet(@"我")
                .dataSet(dataPoints[0]),
                AAObject(AASeriesElement)
                .nameSet(@"全国")
                .dataSet(dataPoints[1]),nil];
        
        dataLineColor = [[NSArray alloc] initWithObjects:@"#25c5c6",@"#b6a3df", nil];
    }else{
        arra = [[NSArray alloc] initWithObjects:AAObject(AASeriesElement)
                .nameSet(@"我")
                .dataSet(dataPoints[0]),nil];
        
        dataLineColor = [[NSArray alloc] initWithObjects:@"#25c5c6", nil];
    }
    
    
    
    //设置 AAChartView 的背景色是否为透明
    aaChartView.isClearBackgroundColor = YES;
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(chartType)//图表类型
    .animationDurationSet(@50)
//    .animationTypeSet(0)
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    .yAxisLineWidthSet(@1)//Y轴轴线线宽为0即是隐藏Y轴轴线
    .colorsThemeSet(dataLineColor)//设置主体颜色数组
    .yAxisTitleSet(@"")//设置 Y 轴标题
    .tooltipValueSuffixSet(@"")//设置浮动提示框单位后缀
    .backgroundColorSet(@"#ffffff")
    .seriesSet(arra);
    
    aaChartModel.symbol = AAChartSymbolTypeCircle;
    aaChartModel.xAxisLabelsEnabled = YES;//是否显示x轴标签
    aaChartModel.categories = chartCategories;//@[@"1",@"2",@"3",@"4",@"5"];//x轴标签
    aaChartModel.symbolStyle = AAChartSymbolStyleTypeBorderBlank;//设置折线连接点样式为:边缘白色
    aaChartModel.xAxisCrosshairWidth = @1;//Zero width to disable crosshair by default
    aaChartModel.xAxisCrosshairColor = @"#778899";//浅石板灰准星线
    aaChartModel.xAxisCrosshairDashStyleType = AALineDashSyleTypeLongDashDotDot;
    
    /*配置 Y 轴标注线,解开注释,即可查看添加标注线之后的图表效果(NOTE:必须设置 Y 轴可见)*/
    //        [self configureTheYAxisPlotLineForAAChartView];
    
    
    if(chartType == AAChartTypeArea){
        //雷达图
        aaChartModel.polarSet(true)
        //        .gradientColorEnabledSet(true)//填充颜色
        .yAxisGridLineWidthSet(@1)//y轴横向分割线宽度为0(即是隐藏分割线)
        .xAxisGridLineWidthSet(@1);
        
        AAOptions *aaOptions = [AAOptionsConstructor configureChartOptionsWithAAChartModel:aaChartModel];
        aaOptions.xAxis.lineWidth = @0;
        aaOptions.yAxis.gridLineInterpolation = AAYAxisGridLineInterpolationPolygon;
        
        [aaChartView aa_drawChartWithOptions:aaOptions];
    }else{
        
        [aaChartView aa_drawChartWithChartModel:aaChartModel];
    }
    
    
    return aaChartView;
    
}


+(AAChartView *)addChartViewDynaByType:(UIView *)addView reportData:(ChartDatasDynamicModel *)reportData{
    NSArray<ChartItemsDynamicModel *> *itemsTotal = reportData.items;
    
    //过滤掉数组数据为0的data
    NSMutableArray<ChartItemsDynamicModel *> *items = [[NSMutableArray alloc] init];
    for(int h =0;h<itemsTotal.count;h++){
        ChartItemsDynamicModel *dm = itemsTotal[h];
        if(dm.chartDatas.count>0){
            [items addObject:itemsTotal[h]];
        }
    }
    
    
    NSInteger type = [reportData.chartType integerValue];
    
    AAChartType chartType = [self getChartType:type];
    if(type == 2 && items.count<=2){
        chartType = AAChartTypeColumn;
    }
    
    AAChartView *aaChartView;
    
    CGFloat chartViewWidth  = addView.frame.size.width == 0 ?mScreenWidth-20 : addView.frame.size.width;
    CGFloat chartViewHeight = COMMON_CHART_HEIGHT;//addView.frame.size.height;
    aaChartView = [[AAChartView alloc]init];
    aaChartView.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    //    aaChartView.delegate = self;
    aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    [addView addSubview:aaChartView];
    
    NSMutableArray<NSMutableArray *> *dataPoints = [[NSMutableArray<NSMutableArray *> alloc] init];//点集合
    NSMutableArray *chartCategories = [[NSMutableArray alloc] init];
    NSMutableArray *arraySeries = [[NSMutableArray alloc] init];
    NSMutableArray *dataLineColor = [[NSMutableArray alloc] init];
    
    for(int i=0;i<items.count;i++){
        NSMutableArray * array = [[NSMutableArray alloc] init];
        NSArray<ChartItemDataModel *> *itemDatas = items[i].chartDatas;
        for(int j=0;j<itemDatas.count;j++){
            ChartItemDataModel *itemData = itemDatas[j];
            double x = [itemData.score doubleValue];
            [array addObject:[NSNumber numberWithDouble:x]];
            [chartCategories addObject:(itemData.itemName ? itemData.itemName : @"")];
        }
        [dataPoints addObject:array];
        
        [arraySeries addObject:AAObject(AASeriesElement)
         .nameSet(items[i].compareName)
         .dataSet(array)];
        
        if(i==0){
            [dataLineColor addObject:@"#25c5c6"];
        }else if(i==1){
            [dataLineColor addObject:@"#b6a3df"];
        }else{
            [dataLineColor addObject:@"#ff8b00"];//暂时不超过三个对比
        }
    }
    
    //设置 AAChartView 的背景色是否为透明
    aaChartView.isClearBackgroundColor = YES;
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(chartType)//图表类型
    .animationDurationSet(@50)
    //    .animationTypeSet(0)
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    .yAxisLineWidthSet(@1)//Y轴轴线线宽为0即是隐藏Y轴轴线
    .colorsThemeSet(dataLineColor)//设置主体颜色数组
    .yAxisTitleSet(@"")//设置 Y 轴标题
    .tooltipValueSuffixSet(@"")//设置浮动提示框单位后缀
    .backgroundColorSet(@"#ffffff")
    .seriesSet(arraySeries);
    
    aaChartModel.symbol = AAChartSymbolTypeCircle;
    aaChartModel.xAxisLabelsEnabled = YES;//是否显示x轴标签
    aaChartModel.categories = chartCategories;//@[@"1",@"2",@"3",@"4",@"5"];//x轴标签
    aaChartModel.symbolStyle = AAChartSymbolStyleTypeBorderBlank;//设置折线连接点样式为:边缘白色
    aaChartModel.xAxisCrosshairWidth = @1;//Zero width to disable crosshair by default
    aaChartModel.xAxisCrosshairColor = @"#778899";//浅石板灰准星线
    aaChartModel.xAxisCrosshairDashStyleType = AALineDashSyleTypeLongDashDotDot;
    
    /*配置 Y 轴标注线,解开注释,即可查看添加标注线之后的图表效果(NOTE:必须设置 Y 轴可见)*/
    //        [self configureTheYAxisPlotLineForAAChartView];
    
    
    if(chartType == AAChartTypeArea){
        //雷达图
        aaChartModel.polarSet(true)
        //        .gradientColorEnabledSet(true)//填充颜色
        .yAxisGridLineWidthSet(@1)//y轴横向分割线宽度为0(即是隐藏分割线)
        .xAxisGridLineWidthSet(@1);
        
        AAOptions *aaOptions = [AAOptionsConstructor configureChartOptionsWithAAChartModel:aaChartModel];
        aaOptions.xAxis.lineWidth = @0;
        aaOptions.yAxis.gridLineInterpolation = AAYAxisGridLineInterpolationPolygon;
        
        [aaChartView aa_drawChartWithOptions:aaOptions];
    }else{
        
        [aaChartView aa_drawChartWithChartModel:aaChartModel];
    }
    
    return aaChartView;
}

+(AAChartView *)addChartViewCareerByType:(UIView *)addView reportData:(CareerChartDataModel *)reportData{
    
    NSArray<CareerChartDataItemModel *> *itemsTotal = reportData.items;
    
    //过滤掉数组数据为0的data
    NSMutableArray<CareerChartDataItemModel *> *items = [[NSMutableArray alloc] init];
    for(int h =0;h<itemsTotal.count;h++){
        CareerChartDataItemModel *dm = itemsTotal[h];
        if(dm.chartDatas.count>0){
            [items addObject:itemsTotal[h]];
        }
    }
    
    
    NSInteger type = [reportData.chartType integerValue];
    
    AAChartType chartType = [self getChartType:type];
    if(type == 2 && items[0].chartDatas.count<=2){
        chartType = AAChartTypeColumn;
    }
    
    AAChartView *aaChartView;
    
    CGFloat chartViewWidth  = addView.frame.size.width == 0 ?mScreenWidth-20 : addView.frame.size.width;
    CGFloat chartViewHeight = COMMON_CHART_HEIGHT;//addView.frame.size.height;
    aaChartView = [[AAChartView alloc]init];
    //aaChartView.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    //    aaChartView.delegate = self;
    aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    [addView addSubview:aaChartView];
    [aaChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([SizeTool sizeWithWidth:chartViewWidth height:chartViewHeight]);
        make.center.mas_equalTo(0);
    }];
    
    NSMutableArray<NSMutableArray *> *dataPoints = [[NSMutableArray<NSMutableArray *> alloc] init];//点集合
    NSMutableArray *chartCategories = [[NSMutableArray alloc] init];
    NSMutableArray *arraySeries = [[NSMutableArray alloc] init];
    NSMutableArray *dataLineColor = [[NSMutableArray alloc] init];
    [dataLineColor addObject:@"#f9751c"];
    [dataLineColor addObject:@"#FFB245"];
    for(int i=0;i<items.count;i++){
        NSMutableArray * array = [[NSMutableArray alloc] init];
        NSArray<CareerChartDataChildModel *> *itemDatas = items[i].chartDatas;
        for(int j=0;j<itemDatas.count;j++){
            CareerChartDataChildModel *itemData = itemDatas[j];
            double x = [itemData.score doubleValue];
            [array addObject:[NSNumber numberWithDouble:x]];
            [chartCategories addObject:(itemData.itemName ? itemData.itemName : @"")];
        }
        [dataPoints addObject:array];
        
        [arraySeries addObject:AAObject(AASeriesElement)
         .nameSet(items[i].compareName)
         .dataSet(array)];
        
      
    }
    
    //设置 AAChartView 的背景色是否为透明
    aaChartView.isClearBackgroundColor = YES;
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(chartType)//图表类型
    .animationDurationSet(@25)
    //    .animationTypeSet(0)
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    .yAxisLineWidthSet(@0)//Y轴轴线线宽为0即是隐藏Y轴轴线
    .colorsThemeSet(dataLineColor)//设置主体颜色数组
    .yAxisTitleSet(@"")//设置 Y 轴标题
    .tooltipValueSuffixSet(@"")//设置浮动提示框单位后缀
    .backgroundColorSet(@"#ffffff")
    .seriesSet(arraySeries)
    .legendEnabledSet(NO)
    .gradientColorEnabledSet(YES)
    .xAxisLabelsFontColorSet(@"#3c3f42")
    .xAxisLabelsFontSizeSet(@9)
    .xAxisLabelsFontWeightSet(@"bold")
   ;

    aaChartModel.symbol = AAChartSymbolTypeCircle;
    aaChartModel.xAxisLabelsEnabled = YES;//是否显示x轴标签
    aaChartModel.categories = chartCategories;//@[@"1",@"2",@"3",@"4",@"5"];//x轴标签
    aaChartModel.symbolStyle = AAChartSymbolStyleTypeBorderBlank;//设置折线连接点样式为:边缘白色
    aaChartModel.xAxisCrosshairWidth = @1;//Zero width to disable crosshair by default
    aaChartModel.xAxisCrosshairColor = @"#FFB245";//浅石板灰准星线
    aaChartModel.xAxisCrosshairDashStyleType = AALineDashSyleTypeLongDashDotDot;
    
    /*配置 Y 轴标注线,解开注释,即可查看添加标注线之后的图表效果(NOTE:必须设置 Y 轴可见)*/
    //        [self configureTheYAxisPlotLineForAAChartView];
    
    
    if(chartType == AAChartTypeArea){
        //雷达图
        aaChartModel.polarSet(true)
        //        .gradientColorEnabledSet(true)//填充颜色
        .yAxisGridLineWidthSet(@1)//y轴横向分割线宽度为0(即是隐藏分割线)
        .xAxisGridLineWidthSet(@1);
        
        AAOptions *aaOptions = [AAOptionsConstructor configureChartOptionsWithAAChartModel:aaChartModel];
        aaOptions.xAxis.lineWidth = @0;
        aaOptions.yAxis.gridLineInterpolation = AAYAxisGridLineInterpolationPolygon;
        
        [aaChartView aa_drawChartWithOptions:aaOptions];
    }else{
        
        [aaChartView aa_drawChartWithChartModel:aaChartModel];
    }
    aaChartView.transform = CGAffineTransformScale(aaChartView.transform, 0.9, 0.9);

    return aaChartView;
}


+ (AAChartView *) addChartViewByGraduation:(UIView *)addView reportData:(NSArray<UniversityGraduationSettledModel *> *) items{
    
    AAChartType chartType = [self getChartType:3];

    AAChartView *aaChartView;
    
    CGFloat chartViewWidth  = addView.frame.size.width == 0 ?mScreenWidth-20 : addView.frame.size.width;
    CGFloat chartViewHeight = COMMON_CHART_HEIGHT;//addView.frame.size.height;
    aaChartView = [[AAChartView alloc]init];
    aaChartView.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    //    aaChartView.delegate = self;
    aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    [addView addSubview:aaChartView];
    
    NSMutableArray<NSMutableArray *> *dataPoints = [[NSMutableArray<NSMutableArray *> alloc] init];
    NSMutableArray *chartCategories = [[NSMutableArray alloc] init];
    

    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(int j=0;j<items.count;j++){
        
        UniversityGraduationSettledModel *item = items[j];
        
        double x = [item.ratio doubleValue] *100;
        [array addObject:[NSNumber numberWithDouble:x]];
        [chartCategories addObject:(item.degree ? item.degree : @"")];
        
    }
    [dataPoints addObject:array];
    
    NSArray * arra;
    NSArray *dataLineColor;
    
    arra = [[NSArray alloc] initWithObjects:AAObject(AASeriesElement)
            .nameSet(@"就业率(%)")
            .dataSet(dataPoints[0]),nil];
    
    dataLineColor = [[NSArray alloc] initWithObjects:@"#25c5c6", nil];
    
    //设置 AAChartView 的背景色是否为透明
    aaChartView.isClearBackgroundColor = YES;
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(chartType)//图表类型
    .animationDurationSet(@50)
    //    .animationTypeSet(0)
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    .yAxisLineWidthSet(@1)//Y轴轴线线宽为0即是隐藏Y轴轴线
    .colorsThemeSet(dataLineColor)//设置主体颜色数组
    .yAxisTitleSet(@"")//设置 Y 轴标题
    .tooltipValueSuffixSet(@"")//设置浮动提示框单位后缀
    .backgroundColorSet(@"#ffffff")
    .yAxisMaxSet(@100)
    .seriesSet(arra);
    
    aaChartModel.symbol = AAChartSymbolTypeCircle;
    aaChartModel.xAxisLabelsEnabled = YES;//是否显示x轴标签
    aaChartModel.categories = chartCategories;//@[@"1",@"2",@"3",@"4",@"5"];//x轴标签
    aaChartModel.symbolStyle = AAChartSymbolStyleTypeBorderBlank;//设置折线连接点样式为:边缘白色
    aaChartModel.xAxisCrosshairWidth = @1;//Zero width to disable crosshair by default
    aaChartModel.xAxisCrosshairColor = @"#778899";//浅石板灰准星线
    aaChartModel.xAxisCrosshairDashStyleType = AALineDashSyleTypeLongDashDotDot;
    
    /*配置 Y 轴标注线,解开注释,即可查看添加标注线之后的图表效果(NOTE:必须设置 Y 轴可见)*/
    //        [self configureTheYAxisPlotLineForAAChartView];
    
    
    [aaChartView aa_drawChartWithChartModel:aaChartModel];
    
    
    return aaChartView;
    
}

//选科统计
+ (AAChartView *) addChartViewBySubject:(UIView *)addView reportData:(NSArray<SubjectCountModel *> *) items{
    
    AAChartType chartType = [self getChartType:3];
    
    AAChartView *aaChartView;
    
    CGFloat chartViewWidth  = addView.frame.size.width == 0 ?mScreenWidth-20 : addView.frame.size.width;
    CGFloat chartViewHeight = addView.frame.size.height;
    aaChartView = [[AAChartView alloc]init];
    aaChartView.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    //    aaChartView.delegate = self;
    aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    [addView addSubview:aaChartView];
    
    NSMutableArray<NSMutableArray *> *dataPoints = [[NSMutableArray<NSMutableArray *> alloc] init];
    NSMutableArray *chartCategories = [[NSMutableArray alloc] init];
    
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(int j=0;j<items.count;j++){
        
        SubjectCountModel *item = items[j];
        
        double x = item.countNum;
        [array addObject:[NSNumber numberWithDouble:x]];
        [chartCategories addObject:(item.subjectName ? item.subjectName : @"")];
        
    }
    [dataPoints addObject:array];
    
    NSArray * arra;
    NSArray *dataLineColor;
    
    arra = [[NSArray alloc] initWithObjects:AAObject(AASeriesElement)
            .nameSet(@"根据专业选科统计")
            .dataSet(dataPoints[0]),nil];
    
    dataLineColor = [[NSArray alloc] initWithObjects:@"#25c5c6", nil];
    
    //设置 AAChartView 的背景色是否为透明
    aaChartView.isClearBackgroundColor = YES;
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(chartType)//图表类型
    .animationDurationSet(@50)
    //    .animationTypeSet(0)
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    .yAxisLineWidthSet(@1)//Y轴轴线线宽为0即是隐藏Y轴轴线
    .colorsThemeSet(dataLineColor)//设置主体颜色数组
    .yAxisTitleSet(@"")//设置 Y 轴标题
    .tooltipValueSuffixSet(@"")//设置浮动提示框单位后缀
    .backgroundColorSet(@"#ffffff")
    .seriesSet(arra);
    
    aaChartModel.symbol = AAChartSymbolTypeCircle;
    aaChartModel.xAxisLabelsEnabled = YES;//是否显示x轴标签
    aaChartModel.categories = chartCategories;//@[@"1",@"2",@"3",@"4",@"5"];//x轴标签
    aaChartModel.symbolStyle = AAChartSymbolStyleTypeBorderBlank;//设置折线连接点样式为:边缘白色
    aaChartModel.xAxisCrosshairWidth = @1;//Zero width to disable crosshair by default
    aaChartModel.xAxisCrosshairColor = @"#778899";//浅石板灰准星线
    aaChartModel.xAxisCrosshairDashStyleType = AALineDashSyleTypeLongDashDotDot;
    
    /*配置 Y 轴标注线,解开注释,即可查看添加标注线之后的图表效果(NOTE:必须设置 Y 轴可见)*/
    //        [self configureTheYAxisPlotLineForAAChartView];
    
    [aaChartView aa_drawChartWithChartModel:aaChartModel];
    
    
    return aaChartView;
    
}



+ (AAChartView *) addChartViewPieByType:(UIView *)addView studentDataModel:(StudentDataModel*) studentDataModel{
    
//    "international_students": 2423,//国际学生人数
//    "undergraduate_students": 16285,//本科生数量
//    "postgraduates_students": 14728//研究生数量
    
    AAChartType chartType = AAChartTypePie;

    AAChartView *aaChartView;
    
    CGFloat chartViewWidth  = addView.frame.size.width == 0 ?mScreenWidth-20 : addView.frame.size.width;
    CGFloat chartViewHeight = 200;
    aaChartView = [[AAChartView alloc]init];
    aaChartView.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    //    aaChartView.delegate = self;
    aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    [addView addSubview:aaChartView];
    
    NSMutableArray<NSMutableArray *> *dataPoints = [[NSMutableArray<NSMutableArray *> alloc] init];//点集合
    NSMutableArray *chartCategories = [[NSMutableArray alloc] init];
    NSMutableArray *arraySeries = [[NSMutableArray alloc] init];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(int j=0;j<3;j++){
        if(j==0){
            double x = [studentDataModel.undergraduateStudents doubleValue];
            [array addObject:[NSNumber numberWithDouble:x]];
            [chartCategories addObject:(@"本科生")];
        }else if(j==1){
            double x = [studentDataModel.postgraduatesStudents doubleValue];
            [array addObject:[NSNumber numberWithDouble:x]];
            [chartCategories addObject:(@"研究生")];
        }else{
            double x = [studentDataModel.internationalStudents doubleValue];
            [array addObject:[NSNumber numberWithDouble:x]];
            [chartCategories addObject:(@"国际学生")];
        }
    }
    [dataPoints addObject:array];
    
    NSArray * arra;
    NSArray *dataLineColor;
    
    arra = [[NSArray alloc] initWithObjects:AAObject(AASeriesElement)
            .nameSet(@"在校生数据")
            .dataSet(dataPoints[0]),nil];
    
    dataLineColor = [[NSArray alloc] initWithObjects:@"#25c5c6", nil];
    
    //设置 AAChartView 的背景色是否为透明
    aaChartView.isClearBackgroundColor = YES;
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(chartType)//图表类型
    .animationDurationSet(@50)
    //    .animationTypeSet(0)
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    .yAxisLineWidthSet(@1)//Y轴轴线线宽为0即是隐藏Y轴轴线
    .colorsThemeSet(dataLineColor)//设置主体颜色数组
    .yAxisTitleSet(@"")//设置 Y 轴标题
    .tooltipValueSuffixSet(@"")//设置浮动提示框单位后缀
    .backgroundColorSet(@"#ffffff")
    .seriesSet(arraySeries);
    
    aaChartModel.symbol = AAChartSymbolTypeCircle;
    aaChartModel.xAxisLabelsEnabled = YES;//是否显示x轴标签
    aaChartModel.categories = chartCategories;//@[@"1",@"2",@"3",@"4",@"5"];//x轴标签
    aaChartModel.symbolStyle = AAChartSymbolStyleTypeBorderBlank;//设置折线连接点样式为:边缘白色
    aaChartModel.xAxisCrosshairWidth = @1;//Zero width to disable crosshair by default
    aaChartModel.xAxisCrosshairColor = @"#778899";//浅石板灰准星线
    aaChartModel.xAxisCrosshairDashStyleType = AALineDashSyleTypeLongDashDotDot;
    
    /*配置 Y 轴标注线,解开注释,即可查看添加标注线之后的图表效果(NOTE:必须设置 Y 轴可见)*/
    //        [self configureTheYAxisPlotLineForAAChartView];
    
    
    //饼图
    
    AAOptions *aaOptions = [AAOptionsConstructor configureChartOptionsWithAAChartModel:aaChartModel];
    aaOptions.xAxis.lineWidth = @0;
    aaOptions.yAxis.gridLineInterpolation = AAYAxisGridLineInterpolationPolygon;
    
    [aaChartView aa_drawChartWithOptions:aaOptions];

    return aaChartView;
}


/**
 * 获取图表类型，把后端数据类型对应到AAchartView的图表类型
 * 后端数据图表类型：1雷达图，2曲线图，3柱状图，4条状图
 */
+(AAChartType) getChartType:(NSInteger) type{
    AAChartType chartType;
    
    //AAChartTypeArea,AAChartTypeSpline,AAChartTypeColumn,AAChartTypeBar
    
    switch (type) {
        case 1:
            chartType = AAChartTypeArea;
            
            break;
        case 2:
            chartType = AAChartTypeSpline;
            
            break;
        case 3:
            chartType = AAChartTypeColumn;
            break;
        case 4:
            chartType = AAChartTypeBar;
            break;
            
        default:
            chartType = AAChartTypeSpline;
            break;
    }
    
    return chartType;
    
}

@end
