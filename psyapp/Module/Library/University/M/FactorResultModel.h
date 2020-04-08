//
//  FactorResultModel.h
//  smartapp
//
//  Created by lafang on 2018/11/4.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

@interface FactorResultModel : FEBaseModel

//"relation_id": "0f9aa158-ccd2-0c00-b590-8ba4f876c505",
//"relation_name": "积极的人际关系",
//"color": "#F56C6C",
//"title": "人际关系不济",
//"content": "

@property(nonatomic,strong) NSString *relationId;
@property(nonatomic,strong) NSString *relationName;
@property(nonatomic,strong) NSString *color;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *content;

@end
