//
//  FEReportForbidAlerView.h
//  smartapp
//
//  Created by mac on 2019/11/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseAlertView.h"



@interface FEReportForbidAlerView : FEBaseAlertView
- (void)showWithTitle:(NSString *)title content:(NSString *)content ;
- (void)showWithTitle:(NSString *)title content:(NSString *)content buttonClickedExeHandler:(void(^)(void))handler ;

@end


