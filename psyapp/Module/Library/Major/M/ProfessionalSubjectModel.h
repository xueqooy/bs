//
//  ProfessionalSubjectModel.h
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "ProfessionalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessionalSubjectModel : FEBaseModel

//"subject":"string", //所属学科
//"categorys":[

@property(nonatomic,strong)NSString *subject;
@property(nonatomic,strong)NSArray *categorys;

@property(nonatomic,assign)BOOL isShow;//是否展开子级列表


@end

NS_ASSUME_NONNULL_END
