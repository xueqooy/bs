//
//  FEPicturedAlertView.h
//  smartapp
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseAlertView.h"


typedef void(^AlertResult)(NSInteger index);

@interface FEPicturedAlertView : FEBaseAlertView

@property (nonatomic,copy) AlertResult resultIndex;

- (instancetype)initWithTitle:(NSString *)title leftText:(NSString *)leftText rightText:(NSString *)rightText picture:(UIImage *)picture;


@end

