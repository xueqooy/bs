//
//  PAPeriodStageSelectionView.m
//  psyapp
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "PAPeriodStageSelectionView.h"

@implementation PAPeriodStageSelectionView {
    NSArray <UIButton *>*_buttons;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    _selectedIndex = -1;
    _buttonHeight = STWidth(60);
    return self;
}

- (void)setStageNames:(NSArray<NSString *> *)stageNames {
    _stageNames = stageNames;
    _buttons = nil;
    
    NSMutableArray *temp = @[].mutableCopy;
    for (NSString *name in _stageNames) {
        UIButton *button = [self generateButtonWithName:name];
        [temp addObject:button];
    }
    _buttons = temp.copy;
    [self layoutButtons];
    [self updateSelected:0];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex || _selectedIndex < 0 || _selectedIndex >= _buttons.count) return;
    
    [self updateSelected:selectedIndex];
}

- (void)setButtonHeight:(CGFloat)buttonHeight {
    _buttonHeight = buttonHeight;
    [self layoutButtons];
}

- (void)layoutButtons {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < _buttons.count; i ++) {
        UIButton *button  = _buttons[i];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.mas_equalTo(_buttonHeight);
            make.top.offset(i * _buttonHeight);
        }];
    }
}

- (void)updateSelected:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) return;
    if (selectedIndex < 0 || selectedIndex >= _buttons.count) return;
    if (_selectedIndex >= 0 && _selectedIndex < _buttons.count) {
        [self setButton:_buttons[_selectedIndex] selected:NO];
    }
    [self setButton:_buttons[selectedIndex] selected:YES];
    _selectedIndex = selectedIndex;
    
}

- (void)setButton:(UIButton *)button selected:(BOOL)selected {
    UIView *selectedFlagView = [button viewWithTag:1999];
    selectedFlagView.hidden = !selected;
    button.backgroundColor = selected? UIColor.fe_backgroundColor : UIColor.fe_contentBackgroundColor;
}

- (QMUIButton *)generateButtonWithName:(NSString *)name {
    QMUIButton *button = QMUIButton.new;
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:UIColor.fe_mainTextColor forState:UIControlStateNormal];
    button.titleLabel.font = STFontRegular(14);
    
    UIView *selectedFlagView = UIView.new;
    selectedFlagView.hidden = YES;
    selectedFlagView.backgroundColor = UIColor.fe_mainColor;
    selectedFlagView.tag = 1999;
    [button addSubview:selectedFlagView];
    [selectedFlagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(STWidth(4), STWidth(16)));
        make.left.centerY.offset(0);
    }];
    
    [button addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)actionForButton:(UIButton *)sender {
    NSInteger idx = [_buttons indexOfObject:sender];
    if (idx == _selectedIndex) return;
    [self updateSelected:idx];
    if (_onSelect) _onSelect(idx);
}
@end
