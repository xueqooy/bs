//
//  ArticleRootModel.h
//  smartapp
//
//  Created by lafang on 2018/8/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "ArticleModel.h"

@interface ArticleRootModel : FEBaseModel

@property(nonatomic,assign) NSInteger total;

@property(nonatomic,strong) NSArray <ArticleModel *>*items;

@end
