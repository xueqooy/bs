//
//  FEEvaluationReportSelectionView.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEEvaluationReportSelectionView.h"
@interface FEEvaluationReportSelectionView ()
@property (nonatomic, copy) NSArray <NSString *> *itemNames;
@property (nonatomic, copy) NSMutableArray <UILabel *>*labelArray;
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
@property (nonatomic, weak) UILabel *selectedLabel;
@property (nonatomic, strong)  UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat spacing;
@end
@implementation FEEvaluationReportSelectionView

- (instancetype)initWithItemNames:(NSArray<NSString *> *)itemNames {
    self = [super init];
    _itemNames = itemNames;
    _selectedIndex = 0;
    _targetIndex = -1;
    [self buildUI];
    return self;
}

- (void)buildUI {
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    CGFloat contentWidth = 0;
    _spacing = STWidth(20);
    
    @weakObj(self);
    MASViewAttribute *lastViewAttribute = _scrollView.mas_left;
    _labelArray = @[].mutableCopy;
    for (NSInteger i = 0; i < _itemNames.count; i ++) {
        contentWidth += [_itemNames[i] getWidthForFont:STFontBold(24)] + _spacing;
        
        UILabel *label = [UILabel new];
        label.text = _itemNames[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColor.whiteColor;

        if (i == _selectedIndex) {
            label.font = STFontBold(24);
            label.alpha = 1.0;
            _selectedLabel = label;
        } else {
            label.font = STFontBold(18);
            label.alpha = 0.4;
        }
        
        [_scrollView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.equalTo(lastViewAttribute).offset(i == 0? STWidth(15): _spacing);
        }];
        
        lastViewAttribute = label.mas_right;
        
        [label addTapGestureWithBlock:^{
            selfweak.targetIndex = i;

            [selfweak updateSelectedIndex:i isTriggeredByTap:YES];

            if (selfweak.selectHandler) {
                selfweak.selectHandler(i);
            }
        }];
        [_labelArray addObject:label];
    }
    
    _scrollView.contentSize = CGSizeMake(contentWidth, STWidth(20));
}

- (void)updateSelectedIndex:(NSInteger)index isTriggeredByTap:(BOOL)byTap {
    if (index != _targetIndex && byTap == YES && _targetIndex != -1) return;
    if (index == _selectedIndex) return;
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.selectedLabel.alpha = 0.4;
        self.selectedLabel.font = STFontBold(18);
    
        _labelArray[index].alpha = 1.0;
        _labelArray[index].font = STFontBold(24);
        
        self.selectedIndex = index;
        self.selectedLabel = _labelArray[index];
    } completion:^(BOOL finished) {
        
        self.userInteractionEnabled = YES;
    }];
  
}

- (void)adjustSelectedItemToLeftmostEnd {
    
    CGFloat labelLeftOffset = CGRectGetMinX(_selectedLabel.frame);
//    [self.scrollView setContentOffset:CGPointMake(labelLeftOffset - STWidth(15), 0) animated:YES];
    if (self.scrollView.contentSize.width <= CGRectGetWidth(self.scrollView.frame)) {
        return;
    }
    if (self.scrollView.contentSize.width - labelLeftOffset - STWidth(15) > CGRectGetWidth(self.scrollView.frame)) {
        [self.scrollView setContentOffset:CGPointMake(labelLeftOffset - STWidth(15), 0) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.frame) - STWidth(15), 0) animated:YES];
    }
}

@end
