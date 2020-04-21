//
//  PAHomeViewController.m
//  psyapp
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "PAHomeViewController.h"
#import "PAMineViewController.h"
#import "PATestListViewController.h"
#import "TCTestListViewController.h"
#import "TCSearchMainViewController.h"
#import "TCDeviceLoginInfoPerfectionViewController.h"
#import "FEEvaluationReportViewController.h"
#import "UIImage+Category.h"
#import "TCImageHeaderScrollingAnimator.h"
#import "PAHomeGridViewCell.h"
#import "FEAnswerViewController.h"
#import "FECommonAlertView.h"
#import "FECommentViewController.h"

#import "PATestCategoryManager.h"
@interface PAHomeViewController () <UIScrollViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) QMUIButton *topLeftButton;
@property (nonatomic, strong) QMUIButton *topRightButton;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) QMUIGridView *gridView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *errorView;

@end

@implementation PAHomeViewController {
    NSArray *_categoryTitles;
    NSArray *_categoryCodes;
    NSArray *_categoryImageNames;
    NSArray *_categoryTintColors;
    NSArray *_completedStatus;
    BOOL _dataLoaded;
    
    AVObject *_obj;
}
- (void)loadView {
    [super loadView];

    CGFloat headerHeight = STWidth(60);
  
    _scrollView = UIScrollView.new;
    _scrollView.backgroundColor = UIColor.fe_backgroundColor;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(mScreenWidth, 100);
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
    
    _gridView = [[QMUIGridView alloc] initWithColumn:2 rowHeight:STWidth(165)];
    _gridView.separatorWidth = STWidth(15);
    _gridView.separatorColor = UIColor.clearColor;
    [_scrollView addSubview:_gridView];
    [_gridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(mScreenWidth - STWidth(30), STWidth(165) * 3 + STWidth(30)));
        make.top.offset(STWidth(40));
        make.centerX.offset(0);
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarShadowHidden = YES;
    self.searchBar.delegate = self;
    [self showBetaLeftTitle:@"测评"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initDataWithCompletion:^{
        [self updateGridView];
    }];
}

static NSString *const kLibCommentTargetId = @"test_comment_target_id";
- (void)gotoComment {
    FECommentViewController *commentViewController = [[FECommentViewController alloc] initWithContentId:kLibCommentTargetId type:FECommentTypeArticle];
    commentViewController.title = @"我要吐槽";
    [self.navigationController pushViewController:commentViewController animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}

- (void)initDataWithCompletion:(void(^)(void))completion {
    _categoryTitles = @[@"职业性格倾向", @"职业价值倾向", @"文科课程学习效能", @"理科课程学习效能", @"我的学业能力", @"我的职业兴趣"];
    _categoryCodes = @[@"zyxgqx", @"zyjzqx", @"wkxxxn", @"lkxxxn", @"xynl", @"zyxq"];
    _categoryImageNames = @[@"elective_test_xg", @"elective_test_jz", @"elective_test_wk", @"elective_test_lk", @"elective_test_xyxq", @"elective_test_zyxq"];
    _categoryTintColors = @[mHexColor(@"#A7855D"), mHexColor(@"#F58BD5"), mHexColor(@"#FBCC7B"), mHexColor(@"#5CB3E0"), mHexColor(@"#40DB77"), mHexColor(@"#716EFF")];
    if (BSUser.currentUser == nil) {
        _completedStatus = @[@0, @0, @0, @0, @0, @0];
        if (completion) completion();
        return;
    }
    
     AVQuery *reportQuery = [AVQuery queryWithClassName:@"TestUser"];
    [reportQuery whereKey:@"userId" equalTo:BSUser.currentUser.objectId];
    [reportQuery getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            self->_obj = object;
            NSMutableArray *temp = @[].mutableCopy;
            for (NSString *key in self->_categoryCodes) {
                [temp addObject:@([[object objectForKey:key] integerValue] != -1)];
            }
            self->_completedStatus = temp.copy;
            if (completion) completion();
        } else {
            object = [AVObject objectWithClassName:@"TestUser"];
            [object setObject:BSUser.currentUser.objectId forKey:@"userId"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [object fetch];
                    self->_obj = object;
                    self->_completedStatus = @[@0, @0, @0, @0, @0, @0];
                    if (completion) completion();
                } else {
                    [HttpErrorManager showErorInfo:error];
                }
            }];
        }
        
    }];
}


- (void)updateGridView {
    [_gridView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < _categoryTitles.count; i ++) {
        NSString *title = _categoryTitles[i];
        NSString *imageName = _categoryImageNames[i];
        PAHomeGridViewCell *cell = PAHomeGridViewCell.new;
        cell.title = title;
        cell.image = [UIImage imageNamed:imageName];
        cell.completed = [_completedStatus[i] boolValue];
        cell.tintColor = _categoryTintColors[i];
        cell.onTouch = ^{
            [self gotoListPageAtIndex:i];
        };
        cell.onButtonClick = ^{
            //已经完成
            if ([self->_completedStatus[i] boolValue]) {
                FECommonAlertView *alertView = [[FECommonAlertView alloc] initWithTitle:@"确定要重测吗" leftText:@"取消" rightText:@"确定" icon:nil];
                alertView.resultIndex = ^(NSInteger index) {
                    if (index == 2) {
                        [self->_obj setObject:@-1 forKey:self->_categoryCodes[i]];
                        [self->_obj saveInBackground];
                        [self gotoListPageAtIndex:i];
                    }
                };
                [alertView showCustomAlertView];
            } else {
                [self gotoListPageAtIndex:i];
            }
             
         };
        [_gridView addSubview:cell];
    }
}

- (void)actionForTopButton:(UIButton *)sender {
    if (sender == _topRightButton) {
        PAMineViewController *mineViewController = PAMineViewController.new;
        [self.navigationController pushViewController:mineViewController animated:YES];
    } else {
        TCTestListViewController *ownedViewController = TCTestListViewController.new;
        ownedViewController.isOwnedList = YES;
        [self.navigationController pushViewController:ownedViewController animated:YES];
    }
}


- (void)gotoListPageAtIndex:(NSInteger)idx  {
    if ([UCManager showLoginAlertIfVisitorPatternWithMessage:@"登录后才可访问"]) {
        return;
    }

    NSInteger level = [[_obj objectForKey:self->_categoryCodes[idx]] integerValue];
    if ( level != -1) {
        //去报告
        AVQuery *query = [AVQuery queryWithClassName:@"TestQuestion"];
        [query whereKey:@"name" equalTo:self->_categoryTitles[idx]];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
            if (object) {
                FEEvaluationReportViewController *vc = [[FEEvaluationReportViewController alloc] initWithAVObject:object level:level ];
                vc.isCreating = YES;
                vc.isCareerReport = YES;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        
    } else {
        //去答题
        AVQuery *query = [AVQuery queryWithClassName:@"TestQuestion"];
        [query whereKey:@"name" equalTo:self->_categoryTitles[idx]];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
            if (object) {
                FEAnswerViewController *answerVC = FEAnswerViewController.new;
                answerVC.avObject = object;
                [self.navigationController pushViewController:answerVC animated:YES];
            }
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = _scrollView.contentOffset.y;
    if (contentOffsetY < 0) {
        _headerView.frame = CGRectMake(0, contentOffsetY, mScreenWidth, STWidth(60) - contentOffsetY);

    } else {
        _headerView.frame = CGRectMake(0, 0, mScreenWidth, STWidth(60));
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    if ([NSString isEmptyString:searchBar.text.qmui_trim]) {
//        [QSToast toast:mKeyWindow message:@"搜索内容不能为空" offset:CGPointMake(0, - STWidth(50)) duration:1];
//        return;
//    };
//    TCSearchMainViewController *searchViewController = TCSearchMainViewController.new;
//    searchViewController.keyword = searchBar.text.qmui_trim;
//    [self.navigationController pushViewController:searchViewController animated:YES];
}
@end
