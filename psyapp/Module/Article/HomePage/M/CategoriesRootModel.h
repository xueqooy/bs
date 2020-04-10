//
//  CategoriesRootModel.h
//  smartapp
//
//  Created by lafang on 2018/8/23.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

@interface CategoriesRootModel : FEBaseModel

@property(nonatomic,assign) NSInteger total;

@property(nonatomic,strong) NSArray *items;

@end
