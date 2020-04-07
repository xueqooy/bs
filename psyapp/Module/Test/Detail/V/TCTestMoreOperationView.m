//
//  TCCoursePurchaseBar.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/17.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestMoreOperationView.h"
#import "TCCommonButton.h"
#import "TCProductPriceView.h"
@interface TCTestMoreOperationView () 

@property (nonatomic, weak) UIButton *testHistoryButton;
@property (nonatomic, weak) UIButton *reTestButton;
@property (nonatomic, weak) UIButton *appraiseButton;

@end

NSString *const TCOperationTestHistory = @"TCOperationTestHistory";
NSString *const TCOperationReTest = @"TCOperationReTest";
NSString *const TCOperationTestAppraise = @"TCOperationTestAppraise";

NSTimeInterval const TCRetestRemainTimeUnknown = -999;

@implementation TCTestMoreOperationView {
    NSInteger _buildIndex;
    CGFloat _mainButtonWidth;
}

@synthesize height = _height;
@synthesize margins = _margins;
@synthesize hideBlock = _hideBlock;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    [self initializeUI];
    return self;
}

- (void)initializeUI {
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOpacity = 0.05;
    self.layer.shadowOffset = CGSizeMake(0, -STWidth(1));
    self.height = 0;
    self.margins = UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)setRetestEnabledRemainTime:(NSTimeInterval)time {
    if (time == 0 || (time < 0 && time != TCRetestRemainTimeUnknown)) {
        [_reTestButton setTitle:@"重测" forState:UIControlStateNormal];
        [_reTestButton setTitleColor:UIColor.fe_mainColor forState:UIControlStateNormal];
        _reTestButton.userInteractionEnabled = YES;
    } else if (time == TCRetestRemainTimeUnknown) {
        [_reTestButton setTitle:@"暂时无法重测" forState:UIControlStateNormal];
        [_reTestButton setTitleColor:UIColor.fe_unselectedTextColor forState:UIControlStateNormal];
        _reTestButton.userInteractionEnabled = NO;
    } else  {
        NSString *formatedTime;
        NSInteger days =  ceil(time / (24 * 3600.0));
        NSInteger hours = ceil(time / 3600.0);
        NSInteger minutes = ceil(time / 60.0);

        if (days >= 1) {
            formatedTime = [NSString stringWithFormat:@"%li天", (long)days];
        } else if (hours >= 1) {
            formatedTime = [NSString stringWithFormat:@"%li小时", (long)hours];
        } else if (minutes >= 1) {
            formatedTime = [NSString stringWithFormat:@"%li分钟", (long)minutes];
        } else {
            formatedTime = [NSString stringWithFormat:@"%li秒", (long)time];
        }
        
        [_reTestButton setTitle:[NSString stringWithFormat:@"%@后可重测", formatedTime] forState:UIControlStateNormal];
        [_reTestButton setTitleColor:UIColor.fe_unselectedTextColor forState:UIControlStateNormal];
        _reTestButton.userInteractionEnabled = NO;
        
        @weakObj(_reTestButton);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_reTestButtonweak setTitle:@"重测" forState:UIControlStateNormal];
            [_reTestButtonweak setTitleColor:UIColor.fe_mainColor forState:UIControlStateNormal];
            _reTestButtonweak.userInteractionEnabled = YES;
        });
    }
}

- (void)actionForButton:(UIButton *)sender {
    if (_onOperation == nil) return;
    self.hideBlock();
    if (sender == _reTestButton) {
        _onOperation(TCOperationReTest);
    } else if (sender == _testHistoryButton) {
        _onOperation(TCOperationTestHistory);
    } else if (sender == _appraiseButton) {
        _onOperation(TCOperationTestAppraise);
    }

}

- (void)setOperations:(NSArray<NSString *> *)operations {
    _operations = operations;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _buildIndex = 0;
    for (NSString *operationName in _operations) {
        [self buildOperationForName:operationName];
        _buildIndex ++;
    }
    self.height = _operations.count *STWidth(48);
}

- (void)buildOperationForName:(NSString *)operationName {
    if ([operationName isEqualToString:TCOperationTestAppraise]) {
        [self buildAppraiseButton];
    } else if ([operationName isEqualToString:TCOperationReTest]) {
        [self buildReTestButton];
    } else if ([operationName isEqualToString:TCOperationTestHistory]) {
        [self buildTestHistoryButton];
    } 
}

- (UIButton *)generateButton {
    TCCommonButton *button = TCCommonButton.new;
    button.backgroundColor = UIColor.fe_contentBackgroundColor;
    [button setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];
    button.titleLabel.font = STFontRegular(14);
    
    UIView *separator = UIView.new;
    separator.backgroundColor = UIColor.fe_separatorColor;
    [button addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.offset(STWidth(15));
        make.right.offset(STWidth(-15));
        make.bottom.offset(0);
    }];
    
    return button;
}

- (void)buildAppraiseButton {
    UIButton *button = self.generateButton;
    [button setTitle:@"评价" forState:UIControlStateNormal];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(_buildIndex * STWidth(48));
        make.height.mas_equalTo(STWidth(48));
    }];
    _appraiseButton = button;
    [_appraiseButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)buildTestHistoryButton {
    UIButton *button = self.generateButton;
    [button setTitle:@"测评历史" forState:UIControlStateNormal];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(_buildIndex * STWidth(48));
        make.height.mas_equalTo(STWidth(48));
    }];
    _testHistoryButton = button;
    [_testHistoryButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buildReTestButton {
    UIButton *button = self.generateButton;
    [button setTitle:@"重测" forState:UIControlStateNormal];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(_buildIndex * STWidth(48));
        make.height.mas_equalTo(STWidth(48));
    }];
    _reTestButton = button;
    [_reTestButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
}
@end
