//
//  FEAppTestGlobalMacros.h
//  smartapp
//
//  Created by mac on 2019/12/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#ifndef TCAppTestGlobalMacros_h
#define TCAppTestGlobalMacros_h

//发布设置为1
#define APP_RELEASE  1
//开发/生产环境                                                                      //不变     //开发环境下按需修改
#define APPTEST_ENVIRONMENT_DEVELOP_ENABLE                              (APP_RELEASE? 0 :         1)
//测评快速答题
#define APPTEST_EVALUATION_REPORT_QUICK_ANSWER_ENABLE                   (APP_RELEASE? 0 :         1)
//appdelegate中的vc测试
#define APPTEST_VC_TEST_ENABLE                                          (APP_RELEASE? 0 :         0)





//友盟统计
#define APPTEST_UM_STATISTIC_ENABLE   !APPTEST_ENVIRONMENT_DEVELOP_ENABLE

#endif /* FEAppTestGlobalMacros_h */
