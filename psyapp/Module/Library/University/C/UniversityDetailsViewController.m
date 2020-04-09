//
//  UniversityDetailsViewController.m
//  smartapp
//  大学详情
//  Created by lafang on 2019/3/5.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UniversityDetailsViewController.h"
#import "EdgeLabel.h"
#import "CareerService.h"
#import "UniversitySituationModel.h"
#import "UniversitySituationViewController.h"
#import "RecruitStudentsViewController.h"
#import "UniversityProfessionalViewController.h"
#import "GraduationInfoViewController.h"
#import "FESwitch.h"
#import "UILabel+FEChain.h"
@interface UniversityDetailsViewController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UIImageView *iconImage;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *tagsView;
@property(nonatomic,strong) UILabel *attributeLabel;

@property(nonatomic,strong) UIButton *rightBtn;

@property(nonatomic,strong) UniversitySituationModel *universitySituationModel;

@end

@implementation UniversityDetailsViewController {
    FESwitch *aSwitch;
    AVObject *followData;
    BOOL _isFollow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
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
    @weakObj(self);
    aSwitch.switchHandler = ^(BOOL on) {
        [selfweak clickRightBarButtonItem];
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aSwitch];
}


-(void)setupView{
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, mScreenWidth, 100)];
    [self.headerView addSubview:self.headView];
    
    self.iconImage = [[UIImageView alloc] init];
    [self.headView addSubview:self.iconImage];
//    self.iconImage.image = [UIImage imageNamed:@"fire_login_head_other"];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.universityModel.logoUrl] placeholderImage:[UIImage imageNamed:@"fire_login_head_other"] options:0 progress:nil completed:nil];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.equalTo(self.headView).offset(10);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.headView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.right.equalTo(self.headView).offset(-10);
        make.top.equalTo(self.headView).offset(15);
    }];
    self.titleLabel.text = self.universityModel.cnName;
    self.titleLabel.textColor = UIColor.fe_titleTextColorLighten;
//    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    
    self.tagsView = [[UIView alloc] init];
    [self.headView addSubview:self.tagsView];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.right.equalTo(self.headView).offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    [self addTagsView];
    
    self.attributeLabel = [[UILabel alloc] init];
    [self.headView addSubview:self.attributeLabel];
    [self.attributeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.right.equalTo(self.headView).offset(-10);
        make.top.equalTo(self.tagsView.mas_bottom).offset(10);
    }];
    self.attributeLabel.textColor = UIColor.fe_mainTextColor;
    self.attributeLabel.font = [UIFont systemFontOfSize:14];
    
    UniversityBasicInfoModel *baseInfo = self.universityModel.basicInfo;
    
    NSString *baseInfoStr = @"";
    NSString *pub = @"公立";
    if(baseInfo.publicOrPrivate){
        if([baseInfo.publicOrPrivate isEqualToString:@"public"]){
            pub = @"公立";
        }else{
            pub = @"私立";
        }
        baseInfoStr = [baseInfoStr stringByAppendingString:pub];
    }
    
    if(baseInfo.instituteType){
        if(![baseInfoStr isEqualToString:@""]){
            baseInfoStr = [baseInfoStr stringByAppendingString:@"|"];
        }
        baseInfoStr = [baseInfoStr stringByAppendingString:baseInfo.instituteType];
    }
    
    if(baseInfo.chinaBelongTo){
        if(![baseInfoStr isEqualToString:@""]){
            baseInfoStr = [baseInfoStr stringByAppendingString:@"|"];
        }
        baseInfoStr = [baseInfoStr stringByAppendingString:baseInfo.chinaBelongTo];
    }
    
    self.attributeLabel.text = baseInfoStr;
    
    
}

-(void)updateHeadData{
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.universityModel.logoUrl] placeholderImage:[UIImage imageNamed:@"fire_login_head_other"] options:0 progress:nil completed:nil];
    self.titleLabel.text = self.universityModel.cnName;
    
    UniversityBasicInfoModel *baseInfo = self.universityModel.basicInfo;
    
    NSString *baseInfoStr = @"";
    NSString *pub = @"公立";
    if(baseInfo.publicOrPrivate){
        if([baseInfo.publicOrPrivate isEqualToString:@"public"]){
            pub = @"公立";
        }else{
            pub = @"私立";
        }
        baseInfoStr = [baseInfoStr stringByAppendingString:pub];
    }
    
    if(baseInfo.instituteType){
        if(![baseInfoStr isEqualToString:@""]){
            baseInfoStr = [baseInfoStr stringByAppendingString:@"|"];
        }
        baseInfoStr = [baseInfoStr stringByAppendingString:baseInfo.instituteType];
    }
    
    if(baseInfo.chinaBelongTo){
        if(![baseInfoStr isEqualToString:@""]){
            baseInfoStr = [baseInfoStr stringByAppendingString:@"|"];
        }
        baseInfoStr = [baseInfoStr stringByAppendingString:baseInfo.chinaBelongTo];
    }
    
    self.attributeLabel.text = baseInfoStr;
}

-(void)clickRightBarButtonItem{
    if (BSUser.currentUser == nil) {
        [UCManager showLoginAlertIfVisitorPatternWithMessage:@"需要登录"];
    }

    NSMutableArray *universities = ((NSArray *)[self->followData objectForKey:@"universities"]).mutableCopy;
    void (^block)(void) = ^{
        [self->followData setObject:universities forKey:@"universities"];
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
        for (NSDictionary *universityDic in universities) {
            if ([universityDic[@"universityId"] isEqualToString:self.universityModel.universityId]) {
                [universities removeObject:universityDic];
                block();
                return;
            }
        }
    } else {
        AVQuery *universityQuery = [AVQuery queryWithClassName:@"UniversityLib"];
        [universityQuery whereKey:@"universityId" equalTo:self.universityModel.universityId];
        [universityQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (objects.firstObject) {
                AVObject *university = objects.firstObject;
                NSMutableDictionary *dictionary = university.dictionaryForObject.mutableCopy;
                [dictionary removeObjectForKey:@"objectId"];
                [dictionary removeObjectForKey:@"__type"];
                [dictionary removeObjectForKey:@"className"];
                [universities addObject:dictionary];
                block();
                return ;
            } else {
                [QSToast toast:self.view message:@"学校不存在"];
            }
        }];
    }
    
    
}

-(void)addTagsView{
    
    NSMutableArray<NSString *> *arrTags = [[NSMutableArray alloc] init];
    if(self.universityModel.basicInfo.instituteQuality.count>0){
        [arrTags addObjectsFromArray:self.universityModel.basicInfo.instituteQuality];
    }
    
    if([self.universityModel.chinaDegree isEqualToString:@"专科"]){
        [arrTags addObject:self.universityModel.chinaDegree];
    }
    NSMutableArray<EdgeLabel *> *labels = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<arrTags.count; i++) {
        
        EdgeLabel *label = [[EdgeLabel alloc] init];
        [self.tagsView addSubview:label];
        [labels addObject:label];
        label.text = arrTags[i];
        label.textColor = UIColor.fe_mainTextColor;
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = mHexColor(@"F7F7F7");
        
        if(i==0){
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.tagsView);
                make.bottom.equalTo(self.tagsView);
            }];
        }else{
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(labels[i-1].mas_right).offset(5);
                make.bottom.equalTo(self.tagsView);
            }];
        }
        
        
    }
}

-(void)updateFolowStatus{
    if(_isFollow){
        [aSwitch setOn:YES hasHandler:NO];
    }else{
        [aSwitch setOn:NO hasHandler:NO];
    }
}

-(void)loadData{
    __weak typeof(self)weakSelf = self;
    [QSLoadingView show];
    [CareerService getUniversitysituation:self.universityModel.universityId success:^(id data) {
        if(data){
            if ([NSString isEmptyString:weakSelf.universityModel.logoUrl] || [NSString isEmptyString:weakSelf.universityModel.cnName]) {
                [CareerService getUniversityInfo:weakSelf.universityModel.universityId success:^(id data) {
                    [QSLoadingView dismiss];
                    weakSelf.universityModel = [MTLJSONAdapter modelOfClass:[UniversityModel class] fromJSONDictionary:data error:nil];
                     [weakSelf updateHeadData];
                } failure:^(NSError *error) {
                    [QSLoadingView dismiss];
                }];
            }
            [QSLoadingView dismiss];
            UniversitySituationModel *dataModel = [MTLJSONAdapter modelOfClass:UniversitySituationModel.class fromJSONDictionary:data error:nil];
            if(dataModel){
                weakSelf.universitySituationModel = dataModel;
                weakSelf.universitySituationModel.universityModel = weakSelf.universityModel;
                
                UniversitySituationViewController *vc = (UniversitySituationViewController *)weakSelf.controllersM[0];
                if(!vc.universitySituationModel){
                    [vc updateModel:weakSelf.universitySituationModel];
                }
            }
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
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
            NSArray *universities;
            if ([self->followData objectForKey:@"universities"]) {
                universities = [self->followData objectForKey:@"universities"];
                for (NSDictionary *universityDic in universities) {
                    if ([universityDic[@"universityId"] isEqualToString:self.universityModel.universityId]) {
                        self->_isFollow = YES;
                        [self updateFolowStatus];
                        return ;
                    }
                }
            } else {
                universities = @[];
                [self->followData setObject:universities forKey:@"universities"];
                self->_isFollow = NO;
                [self updateFolowStatus];
                return ;
            }
        }];
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
    UniversityDetailsViewController *vc = [UniversityDetailsViewController pageViewControllerWithControllers:[self getArrayVCs]
                                                                                                          titles:[self getArrayTitles]
                                                                                                          config:config];
    vc.dataSource = vc;
    vc.delegate = vc;
    
    vc.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 100)];
  
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    return vc;
}

+ (NSArray *)getArrayVCs {
    UniversitySituationViewController *firstVC = [[UniversitySituationViewController alloc] init];
    
    RecruitStudentsViewController *secondVC = [[RecruitStudentsViewController alloc] init];
    
    UniversityProfessionalViewController *thirdVC = [[UniversityProfessionalViewController alloc] init];
    
    GraduationInfoViewController *fourVC = [[GraduationInfoViewController alloc] init];
    
    return @[firstVC, secondVC, thirdVC, fourVC];
}

+ (NSArray *)getArrayTitles {
    return @[@"概况", @"录取招生", @"专业" ,@"毕业信息"];
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    
    if(index ==0){
        UniversitySituationViewController *vc = (UniversitySituationViewController *)pageViewController.controllersM[index];
        if(!vc.universitySituationModel){
            [vc updateModel:self.universitySituationModel];
        }
        return [vc tableView];
    }else if(index == 1){
        RecruitStudentsViewController *vc = (RecruitStudentsViewController *)pageViewController.controllersM[index];
        if(!vc.universitySituationModel){
            [vc updateModel:self.universitySituationModel];
        }
        return [vc tableView];
    }else if(index == 2){
        UniversityProfessionalViewController *vc = (UniversityProfessionalViewController *)pageViewController.controllersM[index];
        if(!vc.universitySituationModel){
            [vc updateModel:self.universitySituationModel];
        }
        return [vc tableView];
    }else{
        GraduationInfoViewController *vc = (GraduationInfoViewController *)pageViewController.controllersM[index];
        if(!vc.universitySituationModel){
            [vc updateModel:self.universitySituationModel];
        }
        return [vc tableView];
    }
    
    
}

#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
}


@end
