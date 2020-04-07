//
//  CareerSubItemsModel.h
//  smartapp
//
//  Created by lafang on 2019/3/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CareerSubItemsModel : FEBaseModel

//"item_name":"string",       //项目名称
//"item_id":"string",         //项目ID
//"result":"string",          //测评结果
//"score":50.5,               //测评得分（原始分或者T分数）
//"rank":90,                  //超过%90的用户
//"description":"string"      //项目描述

@property(nonatomic,strong)NSString *itemName;
@property(nonatomic,strong)NSString *itemId;
@property(nonatomic,strong)NSString *result;
@property(nonatomic,strong)NSNumber *score;
@property(nonatomic,strong)NSNumber *rank;
@property(nonatomic,strong)NSString *pDescription;
@property(nonatomic,strong)NSString *appraisal;

@property (nonatomic, assign) NSNumber *isBadTendency;
@property (nonatomic, assign) NSNumber *maxScore;
@property (nonatomic, assign) NSNumber *minScore;
@property (nonatomic, copy) NSString *trend;
@property (nonatomic, copy) NSString *suggest;




@property(nonatomic,assign)BOOL isShow;//子项desc内容是否展开



@end

NS_ASSUME_NONNULL_END
