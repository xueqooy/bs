//
//  FEMyFollowsViewController.m
//  smartapp
//
//  Created by mac on 2019/9/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEMyFollowsViewController.h"
#import "FESchoolFollowsTableViewCell.h"
#import "FEOtherFollowsTableViewCell.h"
#import "FEMyFollowsDataManager.h"
#import "UniversityDetailsViewController.h"
#import "ProfessionalDetailsViewController.h"
#import "OccupationDetailsViewController.h"
@interface FEMyFollowsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *schoolButton;
@property (weak, nonatomic) IBOutlet UIButton *majorButton;
@property (weak, nonatomic) IBOutlet UIButton *occupationButton;
@property (weak, nonatomic) IBOutlet UIView *headerContainer;

@property (nonatomic, weak) FEMyFollowsDataManager *dataManager;

@property (nonatomic, assign) NSInteger currentSelectedButtonTag;


@end

@implementation FEMyFollowsViewController
- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)loadView {
    [super loadView];
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFollowingData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"数据加载中···" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
    //自动更改透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    _headerContainer.frame = CGRectMake(0, 0, mScreenWidth, STWidth(62));
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emptyViewInsets = UIEdgeInsetsMake(STWidth(60), 0, 0, 0);
    self.view.backgroundColor = UIColor.fe_contentBackgroundColor;
    self.navigationItem.title = @"我的关注";

    
    self.tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _headerContainer.backgroundColor = UIColor.fe_contentBackgroundColor;
    
    [self setSelected:YES forButton:_schoolButton];
    [self setSelected:NO forButton:_majorButton];
    [self setSelected:NO forButton:_occupationButton];
    

    
    [_tableView registerNib:[UINib nibWithNibName:@"FESchoolFollowsTableViewCell" bundle:nil] forCellReuseIdentifier:@"schoolCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"FEOtherFollowsTableViewCell" bundle:nil] forCellReuseIdentifier:@"otherCellID"];


    if (UCManager.sharedInstance.isVisitorPattern == NO) {
        _dataManager = [FEMyFollowsDataManager sharedManager];
    };
    
    _currentSelectedButtonTag = _schoolButton.tag;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (UCManager.sharedInstance.isVisitorPattern) {
        [self showEmptyViewInView:self.view type:FEErrorType_NoFollow];
        return;
    };
    [self loadFollowingData];
}

- (void)setSelected:(BOOL)selected forButton:(UIButton *)button {
    if (selected) {
        button.fe_adjustTitleColorAutomatically = NO;
        button.backgroundColor = [UIColor fe_dynamicColorWithDefault:mHexColor(@"fff3e6") darkColor:mHexColorA(@"ffffff", 0.45)];
        [button setTitleColor:[UIColor fe_dynamicColorWithDefault:mHexColor(@"ff983c") darkWithAlpha:FEThemeDarkCommonAlpha] forState:UIControlStateNormal];
    } else {
        button.fe_adjustTitleColorAutomatically = YES;
        button.backgroundColor = UIColor.fe_buttonBackgroundColorActive;
    }
}

- (IBAction)headerButtonClickAction:(UIButton *)sender {
    
    NSMutableArray *tempData;

    FEMyFollowsType type = 0;
    switch (sender.tag) {
        case 1001:
            tempData = _dataManager.schoolsData;
            type = FEMyFollowsTypeSchool;
            break;
        case 1002:
            tempData = _dataManager.majorsData;
            type = FEMyFollowsTypeMajor;
            break;
        case 1003:
            tempData = _dataManager.occupationsData;
            type = FEMyFollowsTypeOccupation;
            break;
    }
   
    
    UIButton *lastSeletedButton = [_headerContainer viewWithTag:_currentSelectedButtonTag];
    _currentSelectedButtonTag = sender.tag;
    
    lastSeletedButton.backgroundColor = sender.backgroundColor;
    [lastSeletedButton setTitleColor:sender.titleLabel.textColor forState:UIControlStateNormal];
    
    [self setSelected:NO forButton:lastSeletedButton];
    [self setSelected:YES forButton:sender];
    
    if ([_dataManager needLoadDataFor:type]) {
        [self loadFollowingData];
    } else {
        [_tableView reloadData];
    }

    if (tempData.count == 0) {
        [self showEmptyViewInView:self.view type:FEErrorType_NoFollow];
    } else {
        [self hideEmptyView];
    }
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_currentSelectedButtonTag) {
        case 1001:
            return _dataManager.schoolsData.count;
            break;
        case 1002:
            return _dataManager.majorsData.count;
            break;
        case 1003:
            return _dataManager.occupationsData.count;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentSelectedButtonTag == 1001) {
        return STWidth(75);
    } else {
        return STWidth(62);
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
 
    if (_currentSelectedButtonTag == 1001) {
        UniversityModel *universityModel = self.dataManager.schoolsData[indexPath.row];
        
        FESchoolFollowsTableViewCell *schoolCell = [tableView dequeueReusableCellWithIdentifier:@"schoolCellID"];
        NSMutableString *tags = @"".mutableCopy;
        if (universityModel.basicInfo) {
            if (![NSString isEmptyString:universityModel.basicInfo.chinaBelongTo]) {
                [tags appendString:universityModel.basicInfo.chinaBelongTo];
            }
            if (!universityModel.basicInfo.instituteQuality && universityModel.basicInfo.instituteQuality.count > 0) {
                for (NSString *tag in universityModel.basicInfo.instituteQuality) {
                    [tags appendString:tag];
                }
            }
            if (![NSString isEmptyString:universityModel.basicInfo.instituteType]) {
                [tags appendString:universityModel.basicInfo.instituteType];
            }
           
            if ([universityModel.basicInfo.publicOrPrivate isEqualToString:@"public"]) {
                [tags appendString:@"公立"];
            } else if ([universityModel.basicInfo.publicOrPrivate isEqualToString:@"private"]) {
                [tags appendString:@"私立"];
            }
           
        }
        
        [schoolCell updataWithName:universityModel.cnName logoURL:universityModel.logoUrl tags:tags];
        @weakObj(self);
        schoolCell.clickHandler = ^{
            @strongObj(self);
            [self removeFollowingForId:universityModel.universityId];
        };
        cell = schoolCell;
    } else { //专业和职业的cell
        FEOtherFollowsTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"otherCellID"];
        NSDictionary *dic;
        if (_currentSelectedButtonTag == 1002) {
            dic = self.dataManager.majorsData[indexPath.row];
            [otherCell updataWithName:dic[@"majorName"]];
        } else {
            dic = self.dataManager.occupationsData[indexPath.row];
            [otherCell updataWithName:dic[@"occupationName"]];
        }
        @weakObj(self);
        otherCell.clickHandler = ^{
            @strongObj(self);
            if (self->_currentSelectedButtonTag == 1002) {
                [self removeFollowingForId:dic[@"majorCode"]];
            } else {
                [self removeFollowingForId:dic[@"occupationId"]];
            }
        };
        cell = otherCell;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FEMyFollowsType type = _currentSelectedButtonTag % 1000 - 1;
    
    UIViewController *viewController;
    if (type == FEMyFollowsTypeSchool) {
        UniversityDetailsViewController *vc = [UniversityDetailsViewController suspendTopPausePageVC];
        vc.universityModel = self.dataManager.schoolsData[indexPath.row];
        viewController = vc;
     } else if (type == FEMyFollowsTypeMajor) {
        ProfessionalDetailsViewController *vc = [ProfessionalDetailsViewController suspendTopPausePageVC];
         NSDictionary *majorDic = self.dataManager.majorsData[indexPath.row];
         vc.majorCode = [majorDic objectForKey:@"majorCode"];
        viewController = vc;

     } else {
        OccupationDetailsViewController *vc = [[OccupationDetailsViewController alloc] init];
         NSDictionary *occupationDIc = self.dataManager.occupationsData[indexPath.row];
         vc.occupationId = occupationDIc[@"occupationId"];
         viewController = vc;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

#pragma mark - Request

- (void)loadFollowingData {
    
    FEMyFollowsType type = _currentSelectedButtonTag % 1000 - 1;

    @weakObj(self);
    [_dataManager loadFollowingDataForType:type WithSuccess: ^(BOOL empty){
        @strongObj(self);
        [self.tableView.mj_header endRefreshing];
        
        if (empty) {
            
            [self showEmptyViewInView:self.view type:FEErrorType_NoFollow];
            
            
        } else {
            [self hideEmptyView];
            [self.tableView reloadData];
        }
    } ifFailure:^{
        @strongObj(self);

        [self.tableView.mj_header endRefreshing];
        [self showEmptyViewForNoNetInView:self.view refreshHandler:^{
            [selfweak loadFollowingData];
        }];
      
    }];
}


- (void)removeFollowingForId:(NSString *)Id {
    [TCSystemFeedbackHelper impactLight];
    NSString *arrayKey;
    NSString *idKey;
    if (_currentSelectedButtonTag == 1001) {
        arrayKey = @"universities";
        idKey = @"universityId";
    } else if (_currentSelectedButtonTag == 1002) {
        arrayKey = @"majors";
        idKey = @"majorCode";
    } else {
        arrayKey = @"occupations";
        idKey = @"occupationId";
    }
    AVObject *followData = self.dataManager.followData;
    NSMutableArray *array = ((NSArray *)[followData objectForKey:arrayKey]).mutableCopy;

    void (^block)(void) = ^{
        [followData setObject:array forKey:arrayKey];
        [followData saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [QSToast toast:self.view message:@"取消关注"];
                [self loadFollowingData];
            }
        }];
    };
    
    for (NSDictionary *dic in array) {
        if ([dic[idKey] isEqualToString:Id]) {
            [array removeObject:dic];
            block();
            return;
        }
    }

}


@end
