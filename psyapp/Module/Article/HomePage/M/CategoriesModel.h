//
//  CategoriesModel.h
//  smartapp
//
//  Created by lafang on 2018/8/23.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

@interface CategoriesModel : FEBaseModel

@property(nonatomic,strong)NSString *categoriesId;
@property(nonatomic,strong)NSString *name;

//弃用
@property(nonatomic,strong)NSString *backgroundImg;
@property(nonatomic,strong)NSString *backgroundColor;
@property(nonatomic,strong)NSString *icon;

@end
