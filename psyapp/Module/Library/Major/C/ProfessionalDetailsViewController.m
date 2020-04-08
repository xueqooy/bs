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
        if ((on !=  [weakSelf.professionalDetailRootModel.isFollow boolValue]) ) {
            [QSLoadingView show];
            [CareerService careerFollow:weakSelf.professionalDetailRootModel.majorCode type:@"1" isFollow:([weakSelf.professionalDetailRootModel.isFollow integerValue]==0 ? @1: @0) tag:weakSelf.professionalDetailRootModel.majorName success:^(id data) {
                [QSLoadingView dismiss];
                if([data[@"is_follow"] integerValue] == 1){
                    [QSToast toast:weakSelf.view message:@"关注成功"];
                    weakSelf.professionalDetailRootModel.isFollow = @1;
                }else{
                    [QSToast toast:weakSelf.view message:@"已取消关注"];
                    weakSelf.professionalDetailRootModel.isFollow = @0;
                }
                [weakSelf updateFolowStatus];
            } failure:^(NSError *error) {
                [QSLoadingView dismiss];
                [HttpErrorManager showErorInfo:error showView:weakSelf.view];
            }];
        }
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aSwitch];
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
    
//    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//    self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"ff8b00"];
//    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [self.rightBtn setTitle:@"关注"forState:UIControlStateNormal];
//    self.rightBtn.layer.masksToBounds = YES;
//    self.rightBtn.layer.cornerRadius = 5;
//    [self.rightBtn addTarget:self action:@selector(clickRightBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
//    [self.headView addSubview:self.rightBtn];
//    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.headView).offset(mScreenWidth-20-64);
//        make.centerY.equalTo(self.nameLable);
//        make.size.mas_equalTo(CGSizeMake(64, 30));
//    }];
    
    if(!self.emptyView){
        self.emptyView = [[EmptyErrorView alloc] initWithType:1 fatherView:self.view ];
        self.emptyView.backgroundColor = UIColor.fe_backgroundColor;
    }
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];

}

//-(void)clickRightBarButtonItem{
//    //关注
//    if(self.professionalDetailRootModel){
//        [QSLoadingView show];
//        [CareerService careerFollow:self.professionalDetailRootModel.majorCode type:@"1" isFollow:([self.professionalDetailRootModel.isFollow integerValue]==0 ? @1: @0) tag:self.professionalDetailRootModel.majorName success:^(id data) {
//
//            [QSLoadingView dismiss];
//            if([data[@"is_follow"] integerValue] == 1){
//                [QSToast toast:self.view message:@"关注成功"];
//                self.professionalDetailRootModel.isFollow = @1;
//            }else{
//                [QSToast toast:self.view message:@"已取消关注"];
//                self.professionalDetailRootModel.isFollow = @0;
//            }
//            [self updateFolowStatus];
//        } failure:^(NSError *error) {
//            [QSLoadingView dismiss];
//            [HttpErrorManager showErorInfo:error showView:self.view];
//        }];
//    }
//}

-(void)updateFolowStatus{
    if([self.professionalDetailRootModel.isFollow integerValue] == 1){
        [aSwitch setOn:YES hasHandler:NO];
       // [self.rightBtn setTitle:@"取消关注"forState:UIControlStateNormal];
    }else{
        [aSwitch setOn:NO hasHandler:NO];
       // [self.rightBtn setTitle:@"关注"forState:UIControlStateNormal];
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
                [self updateFolowStatus];
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
}

-(void)updateData{

    self.nameLable.text = self.professionalDetailRootModel.majorName;

    self.degreeLable.text = [NSString stringWithFormat:@"授予学位：%@",(self.professionalDetailRootModel.degree ? self.professionalDetailRootModel.degree : @"--")];

    self.learnYearLable.text = [NSString stringWithFormat:@"学制：%@年",[self.professionalDetailRootModel.learnYear stringValue]];

    self.subjectLable.text = [NSString stringWithFormat:@"所属学科：%@",self.professionalDetailRootModel.subject];

    self.categoryLable.text = [NSString stringWithFormat:@"门类：%@",self.professionalDetailRootModel.category];
}

@end
