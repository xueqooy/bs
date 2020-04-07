//
//  PICommonInfo.h
//  smartapp
//
//  Created by mac on 2019/11/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#ifndef PICommonInfo_h
#define PICommonInfo_h

#define PIGuardianFather @"爸爸"
#define PIGuardianMother @"妈妈"
#define PIGuardianGrandFather @"爷爷/外公"
#define PIGuardianGrandMother @"奶奶/外婆"
#define PIGuardianOther @"其他监护人"

#define PILittle1 @"小班"
#define PILittle2 @"中班"
#define PILittle3 @"大班"

#define PIMiddle1 @"一年级"
#define PIMiddle2 @"二年级"
#define PIMiddle3 @"三年级"
#define PIMiddle4 @"四年级"
#define PIMiddle5 @"五年级"
#define PIMiddle6 @"六年级"
#define PIMiddle7 @"七年级"
#define PIMiddle8 @"八年级"
#define PIMiddle9 @"九年级"
#define PIMiddle10 @"高一"
#define PIMiddle11 @"高二"
#define PIMiddle12 @"高三"

#define PIStageNameKindergarten @"幼儿园" //学前 
#define PIStageNamePrimary @"小学"
#define PIStageNameMiddle @"初中"
#define PIStageNameHigh @"高中"

typedef NS_OPTIONS(NSUInteger, TCPeriodStage) {
    TCPeriodStageNone = 0,
    TCPeriodStageKindergarten = 1,
    TCPeriodStagePrimary13 = 2,
    TCPeriodStagePrimary46 = 3,
    TCPeriodStageMiddle = 4,
    TCPeriodStageHigh = 5
};
//#define PeriodIntFromString(periodString) \
//({ \
//NSUInteger periodInt;\
//if ([periodString isEqualToString: PIStageNameHigh]) {\
//    periodInt = TCPeriodStageHigh;\
//} else if ([periodString isEqualToString: PIStageNameMiddle]) {\
//    periodInt = TCPeriodStageMiddle;\
//} else if ([periodString isEqualToString: PIStageNamePrimary]) {\
//    periodInt = TCPeriodStagePrimary;\
//} else if ([periodString isEqualToString: PIStageNameKindergarten]) {\
//    periodInt = TCPeriodStageKindergarten;\
//} else {\
//   periodInt = TCPeriodStageNone;\
//}\
//periodInt;\
//})\
//
//#define PeriodStringFromInt(periodInt) \
//({ \
//NSString *periodString;\
//if (periodInt == TCPeriodStageHigh) {\
//    periodString = PIStageNameHigh;\
//} else if (periodInt == TCPeriodStageMiddle) {\
//    periodString = PIStageNameMiddle;\
//} else if (periodInt == TCPeriodStagePrimary) {\
//    periodString = PIStageNamePrimary;\
//} else if (periodInt == TCPeriodStageKindergarten) {\
//    periodString = PIStageNameKindergarten;\
//}\
//periodString;\
//})\

#endif /* PICommonInfo_h */
