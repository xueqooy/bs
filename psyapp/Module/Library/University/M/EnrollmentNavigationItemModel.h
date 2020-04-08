//
//  EnrollmentNavigationItemModel.h
//  smartapp
//
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnrollmentNavigationItemModel : FEBaseModel

//"name": "北京大学2016年外语类专业保送生招生简章",
//"url": ""

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *url;

@property(nonatomic,strong)NSString *fatherName;

@end

NS_ASSUME_NONNULL_END
