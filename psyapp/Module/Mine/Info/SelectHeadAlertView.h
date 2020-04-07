//
//  SelectHeadAlertView.h
//  smartapp
//
//  Created by lafang on 2018/10/20.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectHeadAlertResult)(NSInteger index);

@interface SelectHeadAlertView : UIView

@property (nonatomic,copy) SelectHeadAlertResult resultAlert;

-(void)showAlertView;

@end
