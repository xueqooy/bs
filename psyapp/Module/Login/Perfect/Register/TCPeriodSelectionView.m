//
//  TCPeriodSelectionView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/16.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCPeriodSelectionView.h"
#import "TCCommonButton.h"

@interface TCPeriodSelectionView () 
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (nonatomic, strong) NSMutableArray <UIButton *>*buttons;

@end
//@property (nonatomic, copy) void(^pi_selectedHandler)(NSString *content);
//- (void)pi_showSelector;
@implementation TCPeriodSelectionView
@synthesize pi_selectedHandler = _pi_sellectedHandler;
@synthesize pi_hiddenHandler = _pi_hiddenHandler;

- (void)pi_showSelector {
    [self showWithAnimated:YES];
}

- (instancetype)initWithOptions:(NSArray<NSString *> *)options selectedIndex:(NSInteger)idx{
    self = [super init];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    _options = options;
    _selectedIndex = idx;

    return self;
}

- (void)didInitialize {
    _titleLabel.textColor = UIColor.fe_titleTextColorLighten;
    _explainLabel.textColor = UIColor.fe_auxiliaryTextColor;
    _buttons = @[].mutableCopy;
    @weakObj(self);
    [_options enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TCCommonButton *button = TCCommonButton.new;
        [button addTarget:selfweak action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.adjustCornerRound = YES;
        [button setTitle:selfweak.options[idx] forState:UIControlStateNormal];
        [button setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];
        button.titleLabel.font = STFontRegular(16);
        button.layer.borderWidth = 1;
        [selfweak setButton:button selected:selfweak.selectedIndex == idx];
        [selfweak.stackView addArrangedSubview:button];
        [_buttons addObject:button];
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        [self hideWithAnimated:YES completion:nil];
        return;
    };
    [self setButton:_buttons[_selectedIndex] selected:NO];
    _selectedIndex = selectedIndex;
    UIButton *selectedButton = _buttons[_selectedIndex];
    [self setButton:selectedButton selected:YES];
    if (_onSelected) {
        [self hideWithAnimated:YES completion:nil];
        _onSelected(selectedButton.titleLabel.text, _selectedIndex);
    }
    
    if (_pi_sellectedHandler) {
        _pi_sellectedHandler(selectedButton.titleLabel.text);
    }

}

- (void)setButton:(UIButton *)button selected:(BOOL)selected {
    button.layer.borderColor = selected? UIColor.fe_mainColor.CGColor: UIColor.fe_separatorColor.CGColor;
    button.backgroundColor = selected? [UIColor.fe_mainColor colorWithAlphaComponent:0.05] : UIColor.clearColor;
}
- (void)buttonAction:(UIButton *)sender {
    NSInteger selectedIndex = [_buttons indexOfObject:sender];
    self.selectedIndex = selectedIndex;
}

- (UIView *)layoutContainer {
    UIView *view = [NSBundle.mainBundle loadNibNamed:@"TCPeriodSelectionView" owner:self options:nil].firstObject;
    [self didInitialize];
    view.layer.cornerRadius = STWidth(16);
    view.alpha = 1.0;
    CGFloat height = STWidth(123) + _options.count * STWidth(48) + (_options.count - 1) * STWidth(10);
    view.frame = CGRectMake(0, 0, STWidth(285), height);
    return view;
}

- (void)hideWithAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [super hideWithAnimated:animated completion:completion];
    if (_pi_hiddenHandler) _pi_hiddenHandler();
}
@end
