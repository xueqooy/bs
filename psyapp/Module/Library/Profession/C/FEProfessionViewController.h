//
//  FEProfessionViewController.h
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEIndustryViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEProfessionViewController : FEIndustryViewController

//查询情况下调用， 需要明白的是 ,该查询不是指导航栏输入文本查询，而是从其他界面点击相应的Tag跳转至职业库
- (void)expandRowWithAreaID:(NSString *)areaID areaName:(NSString *)areaName;
@end

NS_ASSUME_NONNULL_END
