//
//  ProfessionalDetailsViewController.m
//  smartapp
//  专业详情
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalDetailsViewController.h"
#import "CareerService.h"
#import "ProfessionalDetailRootModel.h"
#import "ProfessionalBaseInfoViewController.h"
#import "ProfessionalOpenUniversityViewController.h"
#import "EmploymentProspectsViewController.h"
#import "UILabel+FEChain.h"
#import "CareerService.h"
#import "FESwitch.h"

@interface ProfessionalDetailsViewController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UILabel *degreeLable;//学位
@property(nonatomic,strong)UILabel *learnYearLable;//学制
@property(nonatomic,strong)UILabel *subjectLable;//所属学科
@property(nonatomic,strong)UILabel *categoryLable;//门类

@property(nonatomic,strong) UIButton *rightBtn;

@property(nonatomic,strong) EmptyErrorView *emptyView;

//@property (nonatomic,strong) STSegmentView *exampleSegmentView;
//@property (nonatomic,strong) UIScrollView *bottomScrollView;

@property(nonatomic,strong)ProfessionalDetailRootModel *professionalDetailRootModel;

@end

@implementation ProfessionalDetailsViewController {
    FESwitch *aSwitch;
    AVObject *followData;
    BOOL _isFollow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    [self addNavigationSwitch];
    
    [self loadData];
}


- (void)addNavigationSwitch {
    aSwitch = [[FESwitch alloc] initWithFrame:CGRectMake(0, 0, [SizeTool width:40], [SizeTool height:22])];
    aSwitch.onTintColor = mHexColor(@"fc674f");
    aSwitch.attachView = ({
        UILabel *label = [UILabel create:^(UILabel *  label) {
            label.textIs(@"关注")
            .textColorIs(mHexColor(@"303132"))
            .fontIs([SizeTool font:11])
            .frameIs(CGRectMake(0, 0, [SizeTool width:30], [SizeTool height:22]));
        } addTo:nil];
        label;
    });
    
    
    __weak typeof(self) weakSelf = self;
    aSwitch.switchHandler = ^(BOOL on) {
        [weakSelf clickRightBarButtonItem];
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aSwitch];
}

-(void)clickRightBarButtonItem{
    if (BSUser.currentUser == nil) {
        [UCManager showLoginAlertIfVisitorPatternWithMessage:@"需要登录"];
    }

    NSMutableArray *majors = ((NSArray *)[self->followData objectForKey:@"majors"]).mutableCopy;
    void (^block)(void) = ^{
        [self->followData setObject:majors forKey:@"majors"];
        [self->followData saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                if (self->_isFollow) {
                    [QSToast toast:self.view message:@"取消关注"];
                    self->_isFollow = NO;
                } else {
                    [QSToast toast:self.view message:@"关注成功"];
                    self->_isFollow = YES;
                }
                [self updateFolowStatus];
            }
        }];
    };
    
    if (_isFollow) {
        for (NSDictionary *majorDic in majors) {
            if ([majorDic[@"majorCode"] isEqualToString:self.majorCode]) {
                [majors removeObject:majorDic];
                block();
                return;
            }
        }
    } else {
        NSDictionary *majorDic = @{
            @"majorCode" : self.majorCode,
            @"majorName" : self.professionalDetailRootModel.majorName?  self.professionalDetailRootModel.majorName : @""
        };
        [majors addObject:majorDic];
        block();
        return;
    }
    
    
}

#pragma mark - Public Function

+ (instancetype)suspendTopPausePageVC {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.headerViewCouldScale = YES;
    //    configration.headerViewScaleMode = YNPageHeaderViewScaleModeCenter;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = true;
    configration.showBottomLine = YES;
    configration.lineColor = UIColor.fe_textColorHighlighted;
    configration.bottomLineBgColor = [UIColor whiteColor];
    configration.normalItemColor = UIColor.fe_titleTextColorLighten;
    configration.selectedItemColor = UIColor.fe_textColorHighlighted;
    configration.itemFont = [UIFont systemFontOfSize:16];
    configration.selectedItemFont = [UIFont systemFontOfSize:16];
    return [self suspendCenterPageVCWithConfig:configration];
}

+ (instancetype)suspendCenterPageVCWithConfig:(YNPageConfigration *)config {
    ProfessionalDetailsViewController *vc = [ProfessionalDetailsViewController pageViewControllerWithControllers:[self getArrayVCs]
                                                                                  titles:[self getArrayTitles]
                                                                                  config:config];
    vc.dataSource = vc;
    vc.delegate = vc;

    vc.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, mScreenWidth, 90)];
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    return vc;
}

+ (NSArray *)getArrayVCs {
    ProfessionalBaseInfoViewController *firstVC = [[ProfessionalBaseInfoViewController alloc] init];
    
    ProfessionalOpenUniversityViewController *secondVC = [[ProfessionalOpenUniversityViewController alloc] init];
    
    EmploymentProspectsViewController *thirdVC = [[EmploymentProspectsViewController alloc] init];
    
    return @[firstVC, secondVC, thirdVC];
}

+ (NSArray *)getArrayTitles {
    return @[@"基本信息", @"开设院校", @"就业前景"];
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    
    if(index ==0){
        ProfessionalBaseInfoViewController *vc = (ProfessionalBaseInfoViewController *)pageViewController.controllersM[index];
        if(!vc.professionalDetailRootModel){
            [vc updateModel:self.professionalDetailRootModel];
        }
        return [vc tableView];
    }else if(index == 1){
        ProfessionalOpenUniversityViewController *vc = (ProfessionalOpenUniversityViewController *)pageViewController.controllersM[index];
        if(!vc.professionalDetailRootModel){
            [vc updateModel:self.professionalDetailRootModel];
        }
        return [vc tableView];
    }else{
        EmploymentProspectsViewController *vc = (EmploymentProspectsViewController *)pageViewController.controllersM[index];
        if(!vc.professionalDetailRootModel){
            [vc updateModel:self.professionalDetailRootModel];
        }
        return [vc tableView];
    }

}

#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
}




-(void)setupView{

    self.headView = [[UIView alloc] init];
    [self.headerView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(90);
    }];
    [self.headerView layoutIfNeeded];

    self.nameLable = [[UILabel alloc] init];
    self.nameLable.text = @"物理学";
    self.nameLable.textColor = UIColor.fe_titleTextColorLighten;
//    self.nameLable.font = [UIFont systemFontOfSize:16];
    [self.nameLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self.headView addSubview:self.nameLable];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(20);
        make.right.equalTo(self.headView).offset(-20);
        make.top.equalTo(self.headView).offset(10);
    }];

    self.degreeLable = [[UILabel alloc] init];
    self.degreeLable.text = @"授予学位";
    self.degreeLable.textColor = UIColor.fe_mainTextColor;
    self.degreeLable.font = [UIFont systemFontOfSize:14];
    [self.headView addSubview:self.degreeLable];
    [self.degreeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(20);
        make.top.equalTo(self.nameLable.mas_bottom).offset(10);
    }];

    self.learnYearLable = [[UILabel alloc] init];
    self.learnYearLable.text = @"学制";
    self.learnYearLable.textColor = UIColor.fe_mainTextColor;
    self.learnYearLable.font = [UIFont systemFontOfSize:14];
    [self.headView addSubview:self.learnYearLable];
    [self.learnYearLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(200);
        make.right.equalTo(self.headView).offset(-20);
        make.centerY.equalTo(self.degreeLable);
    }];

    self.subjectLable = [[UILabel alloc] init];
    self.subjectLable.text = @"所属学科";
    self.subjectLable.textColor = UIColor.fe_mainTextColor;
    self.subjectLable.font = [UIFont systemFontOfSize:14];
    [self.headView addSubview:self.subjectLable];
    [self.subjectLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(20);
        make.top.equalTo(self.degreeLable.mas_bottom).offset(10);
    }];

    self.categoryLable = [[UILabel alloc] init];
    self.categoryLable.text = @"门类";
    self.categoryLable.textColor = UIColor.fe_mainTextColor;
    self.categoryLable.font = [UIFont systemFontOfSize:14];
    [self.headView addSubview:self.categoryLable];
    [self.categoryLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(200);
        make.right.equalTo(self.headView).offset(-20);
        make.centerY.equalTo(self.subjectLable);
    }];

    
    if(!self.emptyView){
        self.emptyView = [[EmptyErrorView alloc] initWithType:1 fatherView:self.view insets:UIEdgeInsetsZero];
        self.emptyView.backgroundColor = UIColor.fe_backgroundColor;
    }
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];

}

-(void)updateFolowStatus{
    if(_isFollow){
        [aSwitch setOn:YES hasHandler:NO];
    }else{
        [aSwitch setOn:NO hasHandler:NO];
    }
}

-(void)loadData{
    __weak typeof(self) weakSelf = self;
    [QSLoadingView show];
    [CareerService getProfessionalDetail:self.majorCode success:^(id data) {
        [self.emptyView hiddenEmptyView];
        [QSLoadingView dismiss];
        
        if(data){
            ProfessionalDetailRootModel *dataModel = [MTLJSONAdapter modelOfClass:ProfessionalDetailRootModel.class fromJSONDictionary:data error:nil];
            if(dataModel){
                self.professionalDetailRootModel = dataModel;
                [self updateData];
                
                ProfessionalBaseInfoViewController *vc = (ProfessionalBaseInfoViewController *)self.controllersM[0];
                if(!vc.professionalDetailRootModel){
                    [vc updateModel:self.professionalDetailRootModel];
                }
            }else{
                [self.emptyView showEmptyView];
                [self.emptyView setErrorType:FEErrorType_NoNet];
                [self.emptyView setTitleText:@"暂无数据"];
                [self.emptyView hiddenRefreshBtn:NO];
                self.emptyView.refreshIndex = ^(NSInteger index) {
                    [weakSelf loadData];
                };
            }
            
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:self.view];
        [self.emptyView showEmptyView];
        [self.emptyView setErrorType:FEErrorType_NoNet];
        [self.emptyView hiddenRefreshBtn:NO];
        self.emptyView.refreshIndex = ^(NSInteger index) {
            [weakSelf loadData];
        };
    }];
    
    [self loadFollowData];
}


- (void)loadFollowData {
    BSUser *currentUser = BSUser.currentUser;
    if (currentUser) {
        AVQuery *query = [AVQuery queryWithClassName:@"LibFollow"];
        [query whereKey:@"userId" equalTo:currentUser.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (objects.firstObject) {
                self->followData = objects.firstObject;
            } else {
                self->followData = [AVObject objectWithClassName:@"LibFollow"];
                [self->followData setObject:currentUser.objectId forKey:@"userId"];
            }
            NSArray *majors;
            if ([self->followData objectForKey:@"majors"]) {
                majors = [self->followData objectForKey:@"majors"];
                for (NSDictionary *majorDic in majors) {
                    if ([majorDic[@"majorCode"] isEqualToString:self.majorCode]) {
                        self->_isFollow = YES;
                        [self updateFolowStatus];
                        return ;
                    }
                }
            } else {
                majors = @[];
                [self->followData setObject:majors forKey:@"majors"];
                self->_isFollow = NO;
                [self updateFolowStatus];
                return ;
            }
        }];
    }
}

-(void)updateData{

    self.nameLable.text = self.professionalDetailRootModel.majorName;

    self.degreeLable.text = [NSString stringWithFormat:@"授予学位：%@",(self.professionalDetailRootModel.degree ? self.professionalDetailRootModel.degree : @"--")];

    self.learnYearLable.text = [NSString stringWithFormat:@"学制：%@年",[self.professionalDetailRootModel.learnYear stringValue]];

    self.subjectLable.text = [NSString stringWithFormat:@"所属学科：%@",self.professionalDetailRootModel.subject];

    self.categoryLable.text = [NSString stringWithFormat:@"门类：%@",self.professionalDetailRootModel.category];
}

@end
