//
//  TCLaunchPlaceholderViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCLaunchPlaceholderViewController.h"

@interface TCLaunchPlaceholderViewController ()

@end

@implementation TCLaunchPlaceholderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *launchScreenView = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil].firstObject;
    launchScreenView.frame = self.view.bounds;
    [self.view addSubview:launchScreenView];}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
