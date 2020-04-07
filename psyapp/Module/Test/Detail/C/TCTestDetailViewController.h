//
//  TCTestDetailViewController.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/1.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseViewController.h"


@interface TCTestDetailViewController : FEBaseViewController
//从课程文章的测评进入的初始化方法(测评无需购买)
- (instancetype)initWithDimensionId:(NSString *)dimensionId childExamId:(NSString *)childExamId;

//发现页轮番图、商品列表
- (instancetype)initWithDimensionId:(NSString *)dimensionId;
@end

