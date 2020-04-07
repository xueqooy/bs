//
//  TCVisitorInfoPerfectionViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/25.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDeviceLoginInfoPerfectionViewController.h"

#import "TCDeviceLoginInfoPerfectionTableViewCell.h"
#import "SharedLabelHeaderView.h"

#import "PresentVCAnimation.h"
#import "DismissVCAnimation.h"
#import "SwipeUpInteractiveTransition.h"
@interface TCDeviceLoginInfoPerfectionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SwipeUpInteractiveTransition *interactiveTransition;

@property (nonatomic, copy) void (^perfectionSuccessHandler)(void);
@end

@implementation TCDeviceLoginInfoPerfectionViewController

- (instancetype)init {
    self = [super init];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
}

+ (void)showWithPresentedViewController:(UIViewController *)viewController onPerfectionSuccess:(void (^)(void))perfectionSuccess {
    TCDeviceLoginInfoPerfectionViewController *selfObject = TCDeviceLoginInfoPerfectionViewController.new;
    selfObject.perfectionSuccessHandler = perfectionSuccess;
    [viewController presentViewController:selfObject animated:YES completion:^{
    }];
}

- (void)loadView {
    [super loadView];
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    _tableView.allowsSelection = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(mNavBarAndStatusBarHeight);
        make.left.right.bottom.offset(0);
    }];
    
    CGFloat headerHeight = [SizeTool originHeight:135] - mNavBarAndStatusBarHeight;
    SharedLabelHeaderView *headerView = [[SharedLabelHeaderView alloc] initWithHeadingText:@"完善信息" mainBodyText:@"我们会根据您的基本信息个性化生成报告"];
    headerView.frame = CGRectMake(0, 0, mScreenWidth, headerHeight);
    self.tableView.tableHeaderView = headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.fe_contentBackgroundColor;
}

- (void)perfectInfoWithModel:(PIModel *)model {
    //请求完善信息
    [UCManager perfectDeviceAccountInfoByGender:model.gender grade:model.grade onSuccess:^{
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.perfectionSuccessHandler) _perfectionSuccessHandler();
        }];
    } failure:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return STWidth(240);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCDeviceLoginInfoPerfectionTableViewCell *cell = [[TCDeviceLoginInfoPerfectionTableViewCell alloc] initWithFrame:CGRectZero];
    @weakObj(self);
    cell.onSubmit = ^(PIModel * _Nonnull model) {
        [selfweak perfectInfoWithModel:model];
    };
    return cell;
}


@end
