//
//  FEReportItemDescView.h
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEUIComponent.h"


@interface FEReportItemDescView : FEUIComponent
- (instancetype)initWithItemDesc:(NSString *)itemDesc score:(NSString *)score maxScore:(NSString *)maxScore scoreDesc:(NSString *)scoreDesc appraisal:(NSString *)appraisal suggest:(NSString *)suggest;
@end


