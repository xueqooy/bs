//
//  TCMyOrderViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCMyOrderViewController.h"
#import "TCMyOrderListViewController.h"

#import "SegmentView.h"

@interface TCMyOrderViewController ()
@property (nonatomic, strong) SegmentView *segmentView;
@end

@implementation TCMyOrderViewController
- (void)loadView {
    [super loadView];
    self.view.backgroundColor = UIColor.fe_backgroundColor;

    _segmentView = [SegmentView new];
    _segmentView.frame = self.view.bounds;
    _segmentView.header.moveLineHidden = YES;
    _segmentView.header.itemSpacing = 0;
    _segmentView.header.itemWidth = mScreenWidth / 2;
    _segmentView.header.titleFont = STFontBold(16);
    _segmentView.header.selectedTitleFont = STFontBold(16);
    [self.view addSubview:_segmentView];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarShadowHidden = NO;
    
    self.title = @"我的订单";
    
    TCMyOrderListViewController *testOrderViewController = [[TCMyOrderListViewController alloc] initWithOrderType:TCMyOrderTypeTest];
    TCMyOrderListViewController *emoneyOrderViewController = [[TCMyOrderListViewController alloc] initWithOrderType:TCMyOrderTypeEmoney];

    [_segmentView setViewControllers:@[ testOrderViewController, emoneyOrderViewController] parentViewController:self titles:@[@"测评", @"充值"]];
    
   
}



@end
