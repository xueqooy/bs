//
//  FEBaseViewController.m
//  smartapp
//
//  Created by lafang on 2018/8/17.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"


//#import <UMMobClick/MobClick.h>


@interface FEBaseViewController () <UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIButton *spButton;
@property (nonatomic, weak) UIScrollView *gotoTopScrollView;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, copy) void(^doubleClickHandler)(void) ;
@end

@implementation FEBaseViewController

- (instancetype)init {
    self = [super init];
    _navigationBarShadowHidden = NO;
    return self;
}

- (void)loadView {
    [super loadView];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.fe_backgroundColor;
    if ([self.navigationController isKindOfClass:[FENavigationViewController class]]) {
           self.fe_navigaitionViewController = (FENavigationViewController *)self.navigationController;
       }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.fd_prefersNavigationBarHidden == NO) {
        [self setNavigationBarImage: UIImage.fe_normalNavigationBarBackgroundImage];
        [self initBarShadow];
        if ([self.navigationController isKindOfClass:[FENavigationViewController class]]) {
            self.fe_navigaitionViewController = (FENavigationViewController *)self.navigationController;
        }
    }
}


- (void)dealloc {
    NSLog(@"%@ Released", NSStringFromClass(self.class) );
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 进入页面
    
    NSString *title = self.navigationItem.title;
    if(!title || [title isEqualToString:@""]){
        title = @"FEBaseViewController";
    }
//    [MobClick beginLogPageView:title];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 离开页面

    NSString *title = self.navigationItem.title;
    if(!title || [title isEqualToString:@""]){
        title = @"FEBaseViewController";
    }
//    [MobClick endLogPageView:title];
}


- (void)initBarShadow {
    if (_navigationBarShadowHidden) {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    } else {
        UIImage *shadowImage = [UIImage imageWithColor:[UIColor.fe_separatorColor colorWithAlphaComponent:0.5] size:CGSizeMake(mScreenWidth, 0.5)];
        [self.navigationController.navigationBar setShadowImage:shadowImage];
    }
}

- (void)setNavigationBarShadowHidden:(BOOL)hidden {
    if (_navigationBarShadowHidden == hidden) return;
    _navigationBarShadowHidden = hidden;
    if (_navigationBarShadowHidden) {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    } else {
        UIImage *shadowImage = [UIImage imageWithColor:UIColor.fe_separatorColor size:CGSizeMake(mScreenWidth, 0.5)];
        [self.navigationController.navigationBar setShadowImage:shadowImage];
    }
}

- (void)showLeftTitle:(NSString *)title {
    UILabel *leftTitleLabel = [UILabel createLabelWithDefaultText:title numberOfLines:1 textColor:UIColor.fe_contentBackgroundColor font:mFontBold(24)];
    
    [leftTitleLabel sizeToFit];
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:leftTitleLabel];
    self.navigationItem.leftBarButtonItem = titleItem;
}

- (void)showBetaLeftTitle:(NSString *)title {
    UILabel *leftTitleLabel = [UILabel createLabelWithDefaultText:title numberOfLines:1 textColor:UIColor.fe_contentBackgroundColor font:mFontBold(24)];
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, 50, 44);
    UIView *whiteView = UIView.new;
    whiteView.backgroundColor = UIColor.whiteColor;
    whiteView.frame = CGRectMake(10, 14, 33, 16);
    [view addSubview:whiteView];
    UIImageView *beta = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beta"]];
    beta.frame = CGRectMake(0, 0, 50, 44);
    beta.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:beta];
    [leftTitleLabel sizeToFit];
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:leftTitleLabel];
        UIBarButtonItem *betaItem = [[UIBarButtonItem alloc] initWithCustomView:view];

    self.navigationItem.leftBarButtonItems = @[titleItem, betaItem];
}

- (void)setFullScreenPopGestureEnable:(BOOL)fullScreenPopGestureEnable{
    self.fd_interactivePopDisabled = !fullScreenPopGestureEnable;
}


-(void)setNavigationBarColor:(UIColor *)navigationBarColor{
    UIImage *colorImage = [UIImage qmui_imageWithColor:navigationBarColor];
    [self setNavigationBarImage:colorImage];
}

- (void)setNavigationBarImage:(UIImage *)navigationBarImage {
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
}

- (void)addDoubleClickGestureForNavigationBarWithHandler:(void (^)(void))handler andTitle:(NSString *)title{
    
    if (handler) {
        _doubleClickHandler = handler;
    } else {
        return;
    }
    
    UIView *gestureView = [UIView new];
    gestureView.frame = CGRectMake(0, 0, mScreenWidth - STWidth(90), 44);
    self.navigationItem.titleView = gestureView;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClickAction)];
    tapGR.numberOfTouchesRequired = 1;
    tapGR.numberOfTapsRequired = 2;
    
    [gestureView addGestureRecognizer:tapGR];
  
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = STFontBold(22);
    titleLabel.textColor = UIColor.fe_titleTextColor;
    titleLabel.text = title;
    
    [gestureView addSubview:titleLabel];
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(gestureView.center.x, gestureView.center.y - 2) ;
}

- (void)doubleClickAction {
    if (_doubleClickHandler) {
        _doubleClickHandler();
    }
}

- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    //模式切换，改变返回按钮图片
    if (self.navigationController) {
        UIBarButtonItem *buttonItem = self.navigationItem.leftBarButtonItem ;
        if (buttonItem) {
            [buttonItem setImage:UIImage.fe_navigationBarBackButtonImage];
        }
    }
    
}


@end
