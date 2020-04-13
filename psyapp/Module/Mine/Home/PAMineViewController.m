//
//  PAMineViewController.m
//  smartapp
//
//  Created by lafang on 2018/8/17.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "PAMineViewController.h"
#import "FEChildInfoViewController.h"
#import "TCMyOrderViewController.h"
#import "TCMyAccountViewController.h"
#import "FELoginViewController.h"
#import "FEChangePasswordViewController.h"
#import "QSWebViewBaseController.h"
#import "FEMyFollowsViewController.h"
#import "FEMyCollectViewController.h"

#import "FEMineTableViewCell.h"
#import "FECheckUpdateTableViewCell.h"
#import "TCImageHeaderScrollingAnimator.h"
#import "UIImage+Category.h"
#import "FECommonAlertView.h"

#import "TCAutoLoginManager.h"
#import "TCMyAccountDataManager.h"
#import "UserService.h"

@interface PAMineViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) TCImageHeaderScrollingAnimator *headerScrollingAnimator;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UILabel *nickNameLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) QMUIGhostButton *editInfoButton;

@property (nonatomic,strong)NSArray *imageNameArray;
@property (nonatomic,strong)NSArray *textArray;


@property (nonatomic, assign) CGFloat emoneyBalance;
@end


#define RowFollow 0
#define RowCollect 1

#define RowPassword 0
#define RowService 1
#define RowSecret 2
#define RowVersion 3


@implementation PAMineViewController
- (instancetype)init {
    self = [super init];
    _emoneyBalance = -1;
    return self;
}

- (void)loadView {
    [super loadView];
    [self setupSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.fe_backgroundColor;
    self.fd_prefersNavigationBarHidden = YES;
    [self initDataSource];
    [self registerInfoChangeNotificaton];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self updateViewData];
}




- (void)registerInfoChangeNotificaton {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewData) name:FEChildInfoViewControllerInfoDidChangedNotification object:nil];
}

-(void)initDataSource{
    self.imageNameArray = @[@[@"mine_account", @"mine_order"], @[@"mine_password", @"mine_about", @"mine_service", @"mine_secret", @"mine_version"]];
    self.textArray = @[@[@"我的关注",@"我的收藏"], @[@"修改密码", @"服务协议", @"隐私政策", @"检查更新"]];
}

-(void)setupSubviews{
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = UIColor.fe_backgroundColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[FEMineTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FEMineTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:@"FECheckUpdateTableViewCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"FECheckUpdateTableViewCell"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIView *bottomView = UIView.new;
    bottomView.frame = CGRectMake(0, 0, mScreenWidth, STWidth(60) + mBottomSafeHeight);
    _bottomButton = UIButton.new;
    _bottomButton.backgroundColor = UIColor.whiteColor;
    [_bottomButton setTitleColor:mHexColor(@"#FC674F") forState:UIControlStateNormal];
    _bottomButton.titleLabel.font = STFontRegular(16);
    [_bottomButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_bottomButton];
    [_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.mas_equalTo(STWidth(60));
    }];
    _tableView.tableFooterView = bottomView;
    
    _headerScrollingAnimator = TCImageHeaderScrollingAnimator.new;
    _headerScrollingAnimator.size = CGSizeMake(mScreenWidth, STWidth(100) + mStatusBarHeight);
    _headerScrollingAnimator.scrollView = _tableView;
    
    UIView *headerView = _headerScrollingAnimator.container;
    UIImage *gradientImage = [UIImage gradientImageWithWithColors:@[UIColor.fe_mainColor, mHexColor(@"#9EBAFF")] locations:@[@0, @1] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) size:CGSizeMake(mScreenWidth, STWidth(137) + mStatusBarHeight)];
    _headerScrollingAnimator.image = gradientImage;
    
    _avatarImageView = UIImageView.new;
    _avatarImageView.layer.cornerRadius = STWidth(30);
    _avatarImageView.layer.borderColor = UIColor.whiteColor.CGColor;
    _avatarImageView.layer.borderWidth = 1.5;
    _avatarImageView.clipsToBounds = YES;
    [headerView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(60, 60));
        make.left.offset(STWidth(15));
        make.bottom.offset(STWidth(-22));
    }];
    
    _nickNameLabel = [UILabel.alloc qmui_initWithFont:STFont(STWidth(24)) textColor:UIColor.whiteColor];
    [headerView addSubview:_nickNameLabel];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(STWidth(22));
        make.top.equalTo(_avatarImageView);
    }];
    
    _nameLabel = [UILabel.alloc qmui_initWithFont:STFont(14) textColor:UIColor.whiteColor];
    [headerView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(STWidth(22));
        make.bottom.equalTo(_avatarImageView);
    }];
    
    _editInfoButton = [[QMUIGhostButton alloc] initWithGhostColor:UIColor.whiteColor];
    [_editInfoButton setTitle:@"编辑资料" forState:UIControlStateNormal];
    _editInfoButton.titleLabel.font = STFontRegular(12);
    [_editInfoButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_editInfoButton];
    [_editInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatarImageView);
        make.right.offset(STWidth(-15));
        make.size.mas_equalTo(STSize(80, 25));
    }];
    
 
}



-(void)updateViewData{
    BOOL isVistorPattern = UCManager.sharedInstance.isVisitorPattern;
    BOOL didFormalAccountLogin = UCManager.sharedInstance.didFormalAccountLogin;
    
    _nickNameLabel.text = isVistorPattern? @"游客，您好" : BSUser.currentUser.nickname;
    
    if (isVistorPattern) {
        _nameLabel.text = @"登录注册体验更多功能";
    } else {
        NSMutableString *name = @"".mutableCopy;
        if (didFormalAccountLogin) {
            if (![NSString isEmptyString:BSUser.currentUser.realName]) {
                [name appendString:BSUser.currentUser.realName];
            }
                        
            if (![NSString isEmptyString:BSUser.currentUser.gradeName]) {
                [name appendFormat:@" | %@", BSUser.currentUser.gradeName];
            }
        }
        _nameLabel.text = name;
    }
  
    NSNumber *gender = BSUser.currentUser.gender;
    BOOL isBoy = [gender isEqualToNumber:@1] ;

    NSString *avatarURLString = BSUser.currentUser.avatar.url;;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarURLString] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_header_%@", isBoy?@"boy":@"girl"]]];
    [_bottomButton setTitle:didFormalAccountLogin? @"退出登录": @"去登录" forState:UIControlStateNormal];
    
}

- (void)actionForButton:(UIButton *)sender {
    if (sender == _editInfoButton) {
        FEChildInfoViewController *infoViewController = FEChildInfoViewController.new;
        [self.navigationController pushViewController:infoViewController animated:YES];
    } else {
        [self showLoginOutAlert];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _textArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionData = self.textArray[section];
    return sectionData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return STWidth(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1&& indexPath.row == RowPassword) {
        if (UCManager.sharedInstance.didFormalAccountLogin == NO) {
            return 0;
        }
    }
    return STWidth(60);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = UIView.new;
    return  view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = UIView.new;
    view.backgroundColor = UIColor.fe_backgroundColor;
    return  view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 1 && indexPath.row == RowVersion) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FECheckUpdateTableViewCell class]) forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FEMineTableViewCell class]) forIndexPath:indexPath];
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == RowVersion) {
        FECheckUpdateTableViewCell *_cell = (FECheckUpdateTableViewCell *)cell;
        NSString *currentVersionName = mAppVersion;
        BOOL hasNewVersion = [[NSUserDefaults standardUserDefaults] boolForKey:@"has_new_version"];
        if (currentVersionName && currentVersionName.length > 2) {
            NSString *firstChar = [currentVersionName substringToIndex:1];
            if (![firstChar isNumber]) {
                [_cell setVersionCode:[currentVersionName substringFromIndex:1]];
            } else {
                [_cell setVersionCode:currentVersionName];
            }
        } else {
            [_cell setVersionCode:@""];
        }

       [_cell hasNewVersionTip:hasNewVersion];
        
    } else {
        
        FEMineTableViewCell *_cell = (FEMineTableViewCell *)cell;
        _cell.imageName = self.imageNameArray[indexPath.section][indexPath.row];
        _cell.text = self.textArray[indexPath.section][indexPath.row];
        _cell.rightText = @"";
        if(indexPath.section == 0){
            if (indexPath.row == RowCollect) {
                _cell.bottonLine.hidden = YES;
            } else if (indexPath.row == RowFollow) {
            }
        }else{
            if (indexPath.row == RowPassword) {
                if (UCManager.sharedInstance.didFormalAccountLogin == NO) {
                    _cell.hidden = YES;
                } else {
                    _cell.hidden = NO;
                }
            }
        }
        _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController;
    if(indexPath.section == 0){
        if (indexPath.row == RowFollow) {
            viewController =  [[FEMyFollowsViewController alloc] initWithNibName:@"FEMyFollowsViewController" bundle:nil];;
        } else if (indexPath.row == RowCollect) {
            viewController = [[FEMyCollectViewController alloc] init];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == RowPassword) {
            viewController = FEChangePasswordViewController.new;
        } else if (indexPath.row == RowService) {
            QSWebViewBaseController *vc = [[QSWebViewBaseController alloc] init];
//            vc.url = WEB_SERVICE_AGREEMENT;
            vc.filePathURL = [NSBundle.mainBundle URLForResource:@"service-agreement" withExtension:@"html"];
            vc.shouldDisableLongPressAction = YES;
            vc.shouldDisableZoom = YES;
            vc.navigationItem.title = @"服务协议";
            viewController = vc;
        } else if (indexPath.row == RowSecret) {
            QSWebViewBaseController *vc = [[QSWebViewBaseController alloc] init];
            vc.filePathURL = [NSBundle.mainBundle URLForResource:@"secret-policy" withExtension:@"html"];
            vc.shouldDisableLongPressAction = YES;
            vc.shouldDisableZoom = YES;
            vc.navigationItem.title = @"隐私政策";
            viewController = vc;
        } else if (indexPath.row == RowVersion) {
            [[AppSettingsManager sharedInstance] checkUpdateForVersion];

        }
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

-(void)showLoginOutAlert{
    if (UCManager.sharedInstance.didFormalAccountLogin == NO) {
        [TCUserDataRestter reset1];
        [NSNotificationCenter.defaultCenter postNotificationName:nc_window_root_switch object:WINDOW_ROOT_LOGIN];
        return;
    }
    FECommonAlertView *exitAlert = [[FECommonAlertView alloc] initWithTitle:@"确定要退出吗？" leftText:@"取消" rightText:@"确定" icon:nil];
    exitAlert.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [BSUser logOut];
            [NSNotificationCenter.defaultCenter postNotificationName:nc_window_root_switch object:WINDOW_ROOT_MAIN];
        }
    };
    [exitAlert showCustomAlertView];
}
@end
