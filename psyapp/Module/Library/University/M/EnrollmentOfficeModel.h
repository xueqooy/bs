//
//  EnrollmentOfficeModel.h
//  smartapp
//
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnrollmentOfficeModel : FEBaseModel

//"contact_info": "010-62751407",
//"address": "北京市海淀区颐和园路5号北京大学招生办公室",
//"website": "http://www.gotopku.cn"

@property(nonatomic,strong)NSString *contactInfo;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *website;

@end

NS_ASSUME_NONNULL_END
