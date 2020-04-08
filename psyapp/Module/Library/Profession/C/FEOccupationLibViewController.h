//
//  FEOccupationLibViewController.h
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN



@interface FEOccupationLibViewController : FEBaseViewController
//查询职业分类，传入的参数(报告详情页点击推荐职业，选科助手等)
//areaID应该没什么用处
@property (nonatomic, strong) NSString *areaID;
@property (nonatomic, strong) NSString *areaName;

@end

NS_ASSUME_NONNULL_END
