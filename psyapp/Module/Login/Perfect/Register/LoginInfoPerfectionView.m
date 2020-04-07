//
//  LoginInfoPerfectionView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/12.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "LoginInfoPerfectionView.h"
#import "PIClassMiddleTableViewCell.h"
#import "LoginCommon.h"
@interface LoginInfoPerfectionView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) NSObject *observer;

@end
@implementation LoginInfoPerfectionView
- (instancetype)init {
    self = [super init];
    self.backgroundColor = UIColor.fe_backgroundColor;
    [self setupSubviews];
    [self initInfoPerfectionObserver];
    return self;
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self.observer];
}

- (void)reloadData {
    [_tableView reloadData];
}

- (void)initInfoPerfectionObserver {
    @weakObj(self);
    _observer = [NSNotificationCenter.defaultCenter addObserverForName:nc_login_info_perfect object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        selfweak.userInfo = note.object;
        [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionPerfectUserinfo)];
    }];
}


- (void)setupSubviews {
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    _tableView.allowsSelection = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return STWidth(360);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIClassMiddleTableViewCell *cell = [[PIClassMiddleTableViewCell alloc] initWithFrame:CGRectZero];
    [cell setExistingNickname:_existingNickname];
    _existingNickname = nil;
    return cell;
}
@end
