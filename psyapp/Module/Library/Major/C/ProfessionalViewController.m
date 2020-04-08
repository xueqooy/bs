//
//  ProfessionalViewController.m
//  smartapp
//  专业
//  Created by lafang on 2019/2/21.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalViewController.h"
#import "CareerService.h"
#import "STSegmentView.h"
#import "ProfessionalBenkeView.h"
#import "ProfessionalZhuankeView.h"

@interface ProfessionalViewController ()<UIScrollViewDelegate,STSegmentViewDelegate>

@property (nonatomic,strong) STSegmentView *exampleSegmentView;
@property (nonatomic,strong) UIScrollView *bottomScrollView;

@end

@implementation ProfessionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"专业";
    [self setupView];
//    [self loadData];
}

-(void)setupView{
    
    _exampleSegmentView = [[STSegmentView alloc] init];//WithFrame:CGRectMake(0, 120, self.view.bounds.size.width, 50)];
    [self.view addSubview:_exampleSegmentView];
    [self.exampleSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(0.5);
        make.height.mas_equalTo(50);
    }];
    [self.view layoutIfNeeded];
    _exampleSegmentView.delegate = self;
    _exampleSegmentView.titleArray = @[@"本科",@"专科"];
    _exampleSegmentView.titleSpacing = 20;
    _exampleSegmentView.labelFont = [UIFont boldSystemFontOfSize:16];
    _exampleSegmentView.bottomLabelTextColor = UIColor.fe_titleTextColorLighten;
    _exampleSegmentView.topLabelTextColor = UIColor.fe_textColorHighlighted;
    _exampleSegmentView.selectedBackgroundColor = [UIColor whiteColor];
    _exampleSegmentView.selectedBgViewCornerRadius = 20;
    _exampleSegmentView.sliderHeight = 1;
    _exampleSegmentView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _exampleSegmentView.sliderColor = UIColor.fe_textColorHighlighted;
    _exampleSegmentView.sliderTopMargin = 0;
    _exampleSegmentView.duration = 0.3;
    
    _bottomScrollView = [[UIScrollView alloc] init];
    _bottomScrollView.delegate = self;
    _bottomScrollView.contentSize = CGSizeMake(mScreenWidth * 2, 0);
    _bottomScrollView.pagingEnabled = YES;
    _bottomScrollView.scrollEnabled = NO;
    [self.view addSubview:_bottomScrollView];
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.exampleSegmentView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
    
    CGFloat yy = self.exampleSegmentView.frame.origin.y + self.exampleSegmentView.frame.size.height;
    CGFloat tableViewH = self.view.frame.size.height - yy;
    for (int i = 0; i < 2; i++) {
        UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(i * mScreenWidth, 0, mScreenWidth, tableViewH-(mIsiPhoneX ? 100 : 66))];
        [_bottomScrollView addSubview:vv];
        
        if(i == 0){
            ProfessionalBenkeView *professionalBenkeView = [[ProfessionalBenkeView alloc] initWithController:self];
            [vv addSubview:professionalBenkeView];
            [professionalBenkeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(vv);
            }];
        }else if(i == 1){
            ProfessionalZhuankeView *professionalZhuankeView = [[ProfessionalZhuankeView alloc] initWithController:self];
            [vv addSubview:professionalZhuankeView];
            [professionalZhuankeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(vv);
            }];
        }
    }
    
    
    _exampleSegmentView.outScrollView = _bottomScrollView;
}

- (void)buttonClick:(NSInteger)index {
    [_bottomScrollView setContentOffset:CGPointMake(self.view.frame.size.width * index, 0) animated:YES];
}

@end
