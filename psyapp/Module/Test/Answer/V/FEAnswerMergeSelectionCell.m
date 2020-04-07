//
//  FEAnswerMergeSelectionCell.m
//  smartapp
//
//  Created by mac on 2019/11/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEAnswerMergeSelectionCell.h"
#import "FECourseSurplusView.h"

@implementation FEAnswerMergeSelectionCell {
    UILabel *_subjectLabel;
    UIView *_buttonsContainer;
    NSMutableArray <UIButton *>*_optionButtons;
    UILabel *_leftOptionLabel;
    UILabel *_rightOptionLabel;
    
    CGFloat _buttonWidth;
    CGFloat _animatedDelay;
    NSInteger _currentChoosedIndex;
    NSString *_answerText;
    FECourseSurplusView *_optionHintView;
    NSArray <NSString *> *_options;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex options:(nonnull NSArray<NSString *> *)options subject:(nonnull NSString *)subject {
    _options = options;
    _answerText = @"";
    _currentChoosedIndex = 0;
    _currentChoosedIndex = selectedIndex;
    _buttonWidth = (345 - (_options.count - 1) * 8.33) / _options.count;
    _animatedDelay = 0.25 / _options.count;
    
    [self setupSubviews];

    
    _subjectLabel.text = subject;
    
    _leftOptionLabel.text = options[0];
    _rightOptionLabel.text = options[options.count - 1];

    
    for (UIButton *button in _optionButtons) {
        NSInteger idx = [_optionButtons indexOfObject:button];
        if (_currentChoosedIndex >= idx) {
            [self setAlphaForButton:button atIndex:idx];
        } else {
            button.backgroundColor = UIColor.fe_buttonBackgroundColorActive;
            button.alpha = 1.0;
        }
    }

    [self addOptionToIndex:_currentChoosedIndex withAnimation:NO];
    [self showOptionHintViewWithIndex:_currentChoosedIndex withAnimation:NO];
}



- (void)callBack {
    if (_answeredHandler) {
        
        _answeredHandler(_currentChoosedIndex, _answerText);
    }
}

- (void)panAction:(UIPanGestureRecognizer *)gr {
    CGPoint touchPoint = [gr locationInView:_buttonsContainer];
    NSInteger touchIdx = [self getIndexOfOptionsForLocation:touchPoint];
    
    [self updateOptionFromIndex:_currentChoosedIndex toIndex:touchIdx WithAnimation:YES];
    
    _currentChoosedIndex = touchIdx;
  

    if(gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled){
        if (_currentChoosedIndex >= 0 && _currentChoosedIndex < _optionButtons.count) {
            [self showOptionHintViewWithIndex:_currentChoosedIndex withAnimation:YES];
            [self callBack];
        }
    }
    
}



- (NSInteger)getIndexOfOptionsForLocation:(CGPoint)loc {
    __block NSInteger foundIdx = _currentChoosedIndex;
    [_optionButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *option = obj;
        if (CGRectContainsPoint(option.frame, loc)) {
            foundIdx = idx;
            *stop = YES;
        }
    }];
    return foundIdx;
}

- (void)chooseOptionAction:(UIButton *)sender {
    NSInteger idx = [_optionButtons indexOfObject:sender];
   
 
    [self updateOptionFromIndex:_currentChoosedIndex toIndex:idx WithAnimation:YES];
    
    _currentChoosedIndex = [_optionButtons indexOfObject:sender];
    [self showOptionHintViewWithIndex:_currentChoosedIndex withAnimation:YES];
    

    [self callBack];
    
}

- (void)updateOptionFromIndex:(NSInteger)fromIdx toIndex:(NSInteger)toIdx WithAnimation:(BOOL)animated{
    if (toIdx == fromIdx) {return;}
    
    if (toIdx > fromIdx) {
        [self addOptionToIndex:toIdx withAnimation:animated];
    } else {
        [self reduceStarsFromIndex:fromIdx toIndex:toIdx withAnimation: animated];
    }
}

- (UIButton *)getButtonWithIndex:(NSInteger)idx {
    if (idx < 0 || idx >= _options.count) {return nil;}
    UIButton *btn = [_optionButtons objectAtIndex:idx];
    return btn;
}

- (void)showOptionHintViewWithIndex:(NSInteger)idx withAnimation:(BOOL)animated{
    if (idx != 0 && idx != _options.count - 1 && idx != -1) {
        _optionHintView.titleLabel.text = _options[idx];
        _optionHintView.frame = CGRectMake(STWidth(_buttonWidth + 8.13 + (_buttonWidth - 60)/2) + (idx - 1) * STWidth(_buttonWidth + 8.13), 0, STWidth(60), STWidth(27.24));
        _optionHintView.hidden = NO;
        if (animated == NO) {return;}
        _optionHintView.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.15 animations:^{
            _optionHintView.transform = CGAffineTransformIdentity;
        }];
    } else {
        _optionHintView.hidden = YES;
    }
}

- (void)setAlphaForButton:(UIButton *)button atIndex:(NSInteger)idx {
    CGFloat alphaMutiplier = 1.0 / _options.count;
    button.alpha = (idx + 1) * alphaMutiplier;
}

- (void)addOptionToIndex:(NSInteger)toIdx withAnimation:(BOOL)animated {
    
    NSInteger tmp = toIdx;
    if (animated) {
        CAKeyframeAnimation *scaleAni = [CAKeyframeAnimation animation];
        scaleAni.duration = 0.07;
        scaleAni.keyPath = @"transform.scale";
        scaleAni.values = @[@0.85, @0.9, @0.95, @1, @1.05, @1.1, @1.05, @1];
        int loop = 0;
        for (; tmp > -1; tmp --) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(loop * _animatedDelay * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                UIButton *button = [self getButtonWithIndex:tmp];
                [self setAlphaForButton:button atIndex:tmp];
                [button setBackgroundColor:UIColor.fe_mainColor];
                [button.layer addAnimation:scaleAni forKey:nil];
            });
            loop += 1;
        }
    } else {
        for (; tmp > -1; tmp --) {
            UIButton *button = [self getButtonWithIndex:tmp];
            // [button setImage:_choosedStarImage forState:UIControlStateNormal];
            [button setBackgroundColor:UIColor.fe_mainColor];
        }
    }

}

- (void)reduceStarsFromIndex:(NSInteger)fromIdx toIndex:(NSInteger)toIdx withAnimation:(BOOL)animated {
   
    
    NSInteger tmp = fromIdx;
    if (animated) {
        CAKeyframeAnimation *scaleAni = [CAKeyframeAnimation animation];
        scaleAni.duration = 0.07;
        scaleAni.keyPath = @"transform.scale";
        scaleAni.values = @[@0.85, @0.9, @0.95, @1, @1.05, @1.1, @1.05, @1];
        int loop = 0;
        for (;tmp > toIdx; tmp --) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(loop * _animatedDelay * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                UIButton *button = [self getButtonWithIndex:tmp];
                button.alpha = 1.0;
                [button setBackgroundColor:UIColor.fe_buttonBackgroundColorActive];

                [button.layer addAnimation:scaleAni forKey:nil];
            });
            loop += 1;
        }
    } else {
        for (;tmp > toIdx; tmp --) {
            UIButton *button = [self getButtonWithIndex:tmp];
            [button setBackgroundColor:UIColor.fe_buttonBackgroundColorActive];
        }
    }

}




- (void)setupSubviews {
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    if (_buttonsContainer) {
        return;
    }
    
    UIView *container = [UIView new];
    [self.contentView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, STWidth(15), 0, STWidth(15)));
    }];
    
    _subjectLabel = [UILabel new];
    _subjectLabel.textColor = UIColor.fe_titleTextColorLighten;
    _subjectLabel.font = STFontBold(18);
    [container addSubview:_subjectLabel];
    [_subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.offset(5);
    }];
    
    _buttonsContainer = [UIView new];
    [container addSubview:_buttonsContainer];
    [_buttonsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(_subjectLabel.mas_bottom);
        make.height.mas_equalTo(STWidth(35));
    }];
     UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    panGR.delegate = self;
    [_buttonsContainer addGestureRecognizer:panGR];
    
    _optionButtons = @[].mutableCopy;
    
    for (int i = 0; i < _options.count; i++) {
        UIButton *optionButton = [UIButton new];
        optionButton.backgroundColor = UIColor.fe_buttonBackgroundColorActive;
        [optionButton addTarget:self action:@selector(chooseOptionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonsContainer addSubview:optionButton];
        [optionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(STSize(_buttonWidth, 24));
            make.left.offset(i * (STWidth(_buttonWidth) + STWidth(8.33)));
            make.centerY.offset(0);
        }];
        [_optionButtons addObject:optionButton];
        
    }
    
    
    _leftOptionLabel = [UILabel new];
    _leftOptionLabel.text = @"完全不正确";
    _leftOptionLabel.textColor = UIColor.fe_unselectedTextColor;
    _leftOptionLabel.font = STFontRegular(11);
    [container addSubview:_leftOptionLabel];
    [_leftOptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(_buttonsContainer.mas_bottom);
    }];
    
    _rightOptionLabel = [UILabel new];
    _rightOptionLabel.text = @"完全正确";
    _rightOptionLabel.textColor = UIColor.fe_unselectedTextColor;
    _rightOptionLabel.font = STFontRegular(11);
    [container addSubview:_rightOptionLabel];
    [_rightOptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.equalTo(_buttonsContainer.mas_bottom);

    }];
    
    _optionHintView = [[FECourseSurplusView alloc] initWithFrame:CGRectMake(STWidth(0), STWidth(0), STWidth(60), STHeight(26))];
    _optionHintView.titleLabel.frame = CGRectMake(0, STWidth(0.5), STWidth(60), STWidth(22));
    _optionHintView.titleLabel.textColor = UIColor.fe_titleTextColorLighten;
    _optionHintView.titleLabel.font = STFontRegular(11);
    _optionHintView.borderWidth = STWidth(0.5);
    _optionHintView.borderColor = UIColor.fe_mainColor;
    _optionHintView.fillColor = UIColor.fe_contentBackgroundColor;
    _optionHintView.arrowWidth = STWidth(10);
    _optionHintView.hidden = YES;

    [container addSubview:_optionHintView];
}


@end
