//
//  JudgeModel.h
//  smartapp
//
//  Created by lafang on 2019/4/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "JudgeItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JudgeModel : FEBaseModel

//"id": 1,
//"title": "请问该测评结果与您对自己的认识相符吗？", //评价标题
//"type": 0,
//"items": [{//评价选项

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSNumber *isEvaluate;
@property(nonatomic,strong)NSArray *items;

@end

NS_ASSUME_NONNULL_END
