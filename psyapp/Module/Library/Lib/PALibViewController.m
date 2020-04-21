//
//  PALibViewController.m
//  psyapp
//
//  Created by mac on 2020/4/8.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "PALibViewController.h"
#import "TCSearchMainViewController.h"
#import "UniversityListViewController.h"
#import "ProfessionalViewController.h"
#import "FEOccupationLibViewController.h"
#import "TCLibSearchMainViewController.h"
#import "FEMyFollowsViewController.h"
#import "CareerService.h"
#import "TCImageHeaderScrollingAnimator.h"
#import "BSLibCell.h"
#import "UIImage+Category.h"
#import "TCSearchAppearanceButton.h"
#import "ProfessionalOccupationsModel.h"
#import "PATestCategoryManager.h"
#import "OccupationDetailsViewController.h"
#import "ProfessionalDetailsViewController.h"
#import "FECommentViewController.h"

@interface PALibViewController () <UIScrollViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) QMUIButton *topRightButton;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) TCSearchAppearanceButton *searchButton;
@property (nonatomic, strong) QMUIGridView *gridView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *errorView;

@end

@implementation PALibViewController {
    NSArray <AVObject *>*_basicInfos;
    
    BOOL _dataLoaded;
}
- (void)loadView {
    [super loadView];
    CGFloat headerHeight = STWidth(60);
    UIView *topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, headerHeight)];
    topBackgroundView.backgroundColor = UIColor.fe_mainColor;
    [self.view addSubview:topBackgroundView];
    UIView *bottomBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight, mScreenHeight,  mScreenHeight - headerHeight)];
    bottomBackgroundView.backgroundColor = UIColor.fe_contentBackgroundColor;
    [self.view addSubview:bottomBackgroundView];
    
    _scrollView = UIScrollView.new;
    _scrollView.backgroundColor = UIColor.fe_backgroundColor;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    _headerView = UIImageView.new;
    _headerView.frame = CGRectMake(0, 0, mScreenWidth, headerHeight);
    _headerView.userInteractionEnabled = YES;
    UIImage *gradientImage = [UIImage gradientImageWithWithColors:@[UIColor.fe_mainColor, UIColor.fe_backgroundColor] locations:@[@0, @1] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) size:CGSizeMake(mScreenWidth, headerHeight)];
    _headerView.image = gradientImage;
   
    [_scrollView addSubview:_headerView];
    [_scrollView sendSubviewToBack:_headerView];
 
    _searchButton = TCSearchAppearanceButton.new;
    _searchButton.frame = CGRectZero;
    _searchButton.placeholder = @"搜学校/专业/职业";
    _searchButton.layer.cornerRadius = STWidth(20);
    [_searchButton addTarget:self action:@selector(gotoSeachPage) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_searchButton];
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(345, 40));
        make.centerX.offset(0);
        make.bottom.offset(-STWidth(10));
    }];

    UIView *view = UIView.new;
    view.frame = CGRectMake(0, 0 , 29, 29);
    _topRightButton = QMUIButton.new;
    [_topRightButton setImage:[UIImage imageNamed:@"tucao"] forState:UIControlStateNormal];
    [_topRightButton setTitleColor:UIColor.fe_mainColor forState:UIControlStateNormal];
    [_topRightButton addTarget:self action:@selector(gotoComment) forControlEvents:UIControlEventTouchUpInside];
    _topRightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _topRightButton.frame = CGRectMake(0, 0 , 29, 29);
    [view addSubview:_topRightButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];

    
    UIView *gridViewBackgroundView = UIView.new;
    gridViewBackgroundView.backgroundColor = UIColor.fe_backgroundColor;
    [_scrollView addSubview:gridViewBackgroundView];
    [gridViewBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerHeight);
        make.left.right.bottom.offset(0);
    }];
    CGFloat itemHeight = STWidth(160);
    CGFloat verticalSpacing = STWidth(20);
    _gridView = [[QMUIGridView alloc] initWithColumn:1 rowHeight:itemHeight];
    _gridView.separatorWidth = verticalSpacing;
    _gridView.separatorColor = UIColor.clearColor;
    [gridViewBackgroundView addSubview:_gridView];
    [_gridView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.size.mas_equalTo(CGSizeMake(mScreenWidth - STWidth(30), itemHeight * 3 + verticalSpacing * 2));
        make.edges.mas_equalTo(UIEdgeInsetsMake(STWidth(20), STWidth(15), STWidth(20), STWidth(15)));
    }];
}


static NSString *const kLibCommentTargetId = @"lib_comment_target_id";
- (void)gotoComment {
    FECommentViewController *commentViewController = [[FECommentViewController alloc] initWithContentId:kLibCommentTargetId type:FECommentTypeArticle];
    commentViewController.title = @"我要吐槽";
    [self.navigationController pushViewController:commentViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLeftTitle:@"信息库"];
    self.navigationBarShadowHidden = YES;
    [self loadData];
}


- (void)loadData {
    AVQuery *query = [AVQuery queryWithClassName:@"LibBaseInfo"];
    [query whereKey:@"name" containedIn:@[@"学校库", @"专业库", @"职业库"]];
    [query orderByAscending:@"order"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self->_basicInfos = objects;
        [self updateGridView];
    }];
}


- (void)updateGridView {
    if (_basicInfos.count < 3) return;
    for (int i = 0; i < 3; i ++) {
        AVObject *basicInfo = _basicInfos[i];
        NSString *name = [basicInfo objectForKey:@"name"];
        AVFile *iconFile = [basicInfo objectForKey:@"icon"];
        NSURL *icon = [NSURL URLWithString:iconFile.url];
        NSInteger includedCount = [[basicInfo objectForKey:@"includedCount"] integerValue];
        NSDateFormatter *fomatter = NSDateFormatter.new;
        fomatter.dateFormat = @"yyyy-MM-dd";
        NSString *updatedAt = [fomatter stringFromDate:basicInfo.updatedAt];
        NSArray *tags = [basicInfo objectForKey:@"tags"];
        BSLibCell *cell = BSLibCell.new;
        cell.cellType = i;
        cell.name = name;
        cell.iconImageURL = icon;
        cell.includedCount = includedCount;
        cell.updateAt = updatedAt;
        cell.hotTag = i != 0;
        cell.tags = tags;
        @weakObj(self);
        cell.onTap = ^{
            [selfweak gotoListPageWithCategoryName:name withTag:nil];
        };
        cell.onTag = ^(NSString * _Nonnull tag) {
            [selfweak gotoListPageWithCategoryName:name withTag:tag];
        };
        [_gridView addSubview:cell];
    }
}

//- (void)actionForTopButton:(UIButton *)sender {
//    if (sender == _topRightButton) {
//        FEMyFollowsViewController *followsViewController =  [[FEMyFollowsViewController alloc] initWithNibName:@"FEMyFollowsViewController" bundle:nil];
//        [self.navigationController pushViewController:followsViewController animated:YES];
//    }
//}



- (void)gotoListPageWithCategoryName:(NSString *)categoryName withTag:(NSString *)tag {
    if ([categoryName isEqualToString:@"学校库"]) {
       UniversityListViewController *vc = UniversityListViewController.new;
        vc.rankName = tag;
       [self.navigationController pushViewController:vc animated:YES];
   } else if ([categoryName isEqualToString:@"专业库"]) {
       if ([NSString isEmptyString:tag]) {
           ProfessionalViewController *vc = ProfessionalViewController.new;
           [self.navigationController pushViewController:vc animated:YES];
       } else {
           [self gotoMajorDetailPageWithName:tag];
       }
       
   } else if ([categoryName isEqualToString:@"职业库"]) {
       if ([NSString isEmptyString:tag]) {
           FEOccupationLibViewController *vc = FEOccupationLibViewController.new;
           [self.navigationController pushViewController:vc animated:YES];
       } else {
           [self gotoOccupationDetailPageWithName:tag];
       }
   }
}

- (void)gotoOccupationDetailPageWithName:(NSString *)name {
    void (^notFoundHandler)(void) =^{
        FEOccupationLibViewController *vc = FEOccupationLibViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    };
    NSString *key = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   [CareerService getOccupationsByCategory:@"" areaId:@"" occupationName:key page:1 size:1 success:^(id data) {
       [QSLoadingView dismiss];
       if(data){
           NSArray<ProfessionalOccupationsModel *> *dataModels = [MTLJSONAdapter modelsOfClass:ProfessionalOccupationsModel.class fromJSONArray:data[@"items"] error:nil];
           if(dataModels.count > 0){
               ProfessionalOccupationsModel *model  =dataModels.firstObject;
               OccupationDetailsViewController *vc = [[OccupationDetailsViewController alloc] init];
               vc.occupationId = [NSString stringWithFormat:@"%@", model.occupationId];
               [self.navigationController pushViewController:vc animated:YES];
           } else {
               notFoundHandler();
           }
       }
   } failure:^(NSError *error) {
       notFoundHandler();
   }];
}

- (void)gotoMajorDetailPageWithName:(NSString *)name {
    void (^notFoundHandler)(void) =^{
        ProfessionalViewController *vc = ProfessionalViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    };
    AVQuery *query = [AVQuery queryWithClassName:@"MajorLib"];
    [query whereKey:@"majorName" containsString:name];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            notFoundHandler();
        } else {
            NSString *majorCode = [object objectForKey:@"majorCode"];
            ProfessionalDetailsViewController *vc = [ProfessionalDetailsViewController suspendTopPausePageVC] ;
            vc.majorCode = majorCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = _scrollView.contentOffset.y;
    if (contentOffsetY < 0) {
        _headerView.frame = CGRectMake(0, contentOffsetY, mScreenWidth, STWidth(60) - contentOffsetY);

    } else {
        _headerView.frame = CGRectMake(0, 0, mScreenWidth, STWidth(60));
    }
}


- (void)gotoSeachPage{
    TCLibSearchMainViewController *searchViewController = TCLibSearchMainViewController.new;
    [searchViewController present];
}
@end

