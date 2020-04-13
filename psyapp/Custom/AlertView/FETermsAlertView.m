//
//  FETermsAlertView.m
//  smartapp
//
//  Created by mac on 2019/12/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FETermsAlertView.h"
#import "FEReportForbidAlerView.h"
#import "QSWebViewBaseController.h"
#import "UIViewController+Additions.h"
@interface FETermsAlertView()
@property (weak, nonatomic) IBOutlet UIButton *serviceButton;
@property (weak, nonatomic) IBOutlet UIButton *secretButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (weak, nonatomic) IBOutlet UIButton *disagreeButton;
@end
@implementation FETermsAlertView


- (IBAction)buttonClickAction:(UIButton *)sender {
    if (sender == self.serviceButton) {
        [self pushToWebVCWithTitle:@"服务协议" url:[NSBundle.mainBundle URLForResource:@"service-agreement" withExtension:@"html"]];
    } else if (sender == self.secretButton) {
        
        [self pushToWebVCWithTitle:@"隐私政策" url:[NSBundle.mainBundle URLForResource:@"secret-policy" withExtension:@"html"]];

    } else if (sender == self.agreeButton) {
        @weakObj(self);
        [self hideWithAnimated:YES completion:
         ^{
            @strongObj(self);
            if (self.agreeHandler) {
                self.agreeHandler();
            }
        }];
    } else if (sender == self.disagreeButton){
        self.hidden = YES;
        FEReportForbidAlerView *disagreeAlertView = [[FEReportForbidAlerView alloc] init];
        disagreeAlertView.backgroundTapDisable = YES;
        disagreeAlertView.backgroundTapHideAnimationDisable = YES;
        [disagreeAlertView showWithTitle:@"隐私保护提示" content:@"您需同意《服务协议》和《隐私政策》，方可使用本软件" buttonClickedExeHandler:^{
            self.hidden = NO;
        }];
    }
}

- (void)pushToWebVCWithTitle:(NSString *)title url:(NSURL *)url {
    QSWebViewBaseController *vc = [[QSWebViewBaseController alloc] init];
    @weakObj(self);
    vc.handlerAfterPoping = ^{
        @strongObj(self);
        self.hidden = NO;
    };
    vc.filePathURL = url;
    vc.shouldDisableLongPressAction = YES;
    vc.shouldDisableZoom = YES;
    vc.navigationItem.title = title;
    self.hidden = YES;
    UINavigationController *currentNavigationController = [UIViewController getCurrentShowViewController].navigationController ;
    if (currentNavigationController == nil) {
        currentNavigationController = QMUIHelper.visibleViewController.navigationController;
    }
    [currentNavigationController pushViewController:vc animated:YES];
}

- (UIView *)layoutContainer {
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, STWidth(320), STWidth(300))];
    container.layer.masksToBounds = YES;
    [container setBackgroundColor:[UIColor whiteColor]];
    container.layer.cornerRadius = 4;
    
    UIView *view = [NSBundle.mainBundle loadNibNamed:@"FETermsAlertView" owner:self options:nil].firstObject;
    [container addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    return container;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
