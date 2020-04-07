//
//  ReportArticleView.h
//  smartapp
//
//  Created by lafang on 2018/10/22.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEUIComponent.h"

typedef void(^ReportArticleResult)(NSInteger index);

#define RA_HEIGHT 75

@interface FEReportRecommendedArticleView : FEUIComponent

- (instancetype)initWithImageNamed:(NSString *)imageName title:(NSString *)title readCount:(NSString *)count contentType:(NSNumber *)type;

@property (nonatomic,copy) ReportArticleResult reportIndex;

@end
