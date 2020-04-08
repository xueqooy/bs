//
//  ReportResultsModel.h
//  smartapp
//
//  Created by lafang on 2018/9/4.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "FactorResultModel.h"

@interface ReportResultsModel : FEBaseModel

@property(nonatomic,strong) NSString *header;
@property(nonatomic,strong) NSString *relationId;
@property(nonatomic,strong) NSString *result;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *color;
@property(nonatomic,strong) NSString *descriptionChart;
@property(nonatomic,strong) NSArray *factorResult;

@end
