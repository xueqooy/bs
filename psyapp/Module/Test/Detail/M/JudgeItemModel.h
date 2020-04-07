//
//  JudgeItemModel.h
//  smartapp
//
//  Created by lafang on 2019/4/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JudgeItemModel : FEBaseModel

//"id": 1,
//"evaluate_title_id": 1,//评价项ID
//"content": "很符合", //评价内容
//"value": 5,
//"is_evaluate": false //是否评价 true 选中

@property(nonatomic,strong)NSNumber *optionId;
@property(nonatomic,strong)NSNumber *evaluateTitleId;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSNumber *value;
@property(nonatomic,strong)NSNumber *isEvaluate;

@end

NS_ASSUME_NONNULL_END
