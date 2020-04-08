//
//  ProfessionalIntroducesModel.h
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessionalIntroducesModel : FEBaseModel

//"title":"string",           //标题
//"content":"string"          //内容

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *content;

@end

NS_ASSUME_NONNULL_END
