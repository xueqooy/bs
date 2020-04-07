//
//  TCDeviceLoginAlertView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/25.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDeviceLoginAlertView.h"
@interface TCDeviceLoginAlertView ()
@property (weak, nonatomic) IBOutlet UIButton *accountLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *deviceLoginButton;
@end
@implementation TCDeviceLoginAlertView
- (IBAction)actionForButton:(UIButton *)sender {
    if (sender == _accountLoginButton) {
        if (_accountLoginHandler) _accountLoginHandler();
    } else {
        if (_deviceLoginHandler) _deviceLoginHandler();
    }
}

- (UIView *)layoutContainer {
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, STWidth(320), STWidth(280))];
    container.layer.masksToBounds = YES;
    [container setBackgroundColor:[UIColor whiteColor]];
    container.layer.cornerRadius = 4;
    
    UIView *view = [NSBundle.mainBundle loadNibNamed:@"TCDeviceLoginAlertView" owner:self options:nil].firstObject;
    _accountLoginButton.backgroundColor = UIColor.fe_mainColor;

    [container addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    return container;
}



@end
