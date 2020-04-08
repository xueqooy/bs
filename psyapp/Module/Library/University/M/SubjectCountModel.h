//
//  SubjectCountModel.h
//  smartapp
//  专业观察表-学科统计使用
//  Created by lafang on 2019/3/28.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubjectCountModel : FEBaseModel

@property(nonatomic,strong)NSString *subjectName;
@property(nonatomic,assign)NSInteger countNum;

@end

NS_ASSUME_NONNULL_END
