//
//  SegmentHeaderView.m
//  smartapp
//
//  Created by lafang on 2018/10/11.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "SegmentHeaderView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Category.h"
#import "FEDeviceManager.h"
#import "FEEqualSpaceFlowLayoutEvolve.h"


#define kWidth self.frame.size.width


@interface SegmentHeaderViewCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;
@end;

@implementation SegmentHeaderViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = UIColor.fe_mainColor;
        _bottomLine.layer.cornerRadius = STWidth(2);
        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.width.mas_equalTo(STWidth(18));
            make.height.mas_equalTo(STWidth(4));
            make.bottom.offset(0);
        }];
        
    }
    return self;
}

@end


@interface SegmentHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *moveLine;
@property (nonatomic, strong) UIView *separator;

@property (nonatomic, copy) NSArray <NSNumber *>*titleWidthArray;
@end


@implementation SegmentHeaderView {
    SegmentHeaderViewCollectionViewCell *_selectedCell;
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _bottomSeparatorHeight = STWidth(0.5);
    self.qmui_borderPosition = QMUIViewBorderPositionBottom;
    self.qmui_borderLocation = QMUIViewBorderLocationInside;
    self.qmui_borderWidth = _bottomSeparatorHeight;
    self.qmui_borderColor = UIColor.fe_separatorColor;
    _moveLineHidden = NO;
    _selectedTitleFont = STFontBold(16);
    _itemWidth = -1;
    _alignment = SegmentHeaderAlignmentLeft;
    _itemSpacing = STWidth(30);
    _titleFont = STFontBold(14);
    _titleColor = UIColor.fe_unselectedTextColor;
    _selectedTitleColor = UIColor.fe_titleTextColorLighten;
    _selectedIndex = 0;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray {
    if (self = [self initWithFrame:frame]) {
        _titleArray = titleArray;
        [self updateTitleWidthArray];
    }
    return self;
}

#pragma mark - Public Method

- (UIScrollView *)scrollView {
    return _collectionView;
}

- (void)setBottomSeparatorHeight:(CGFloat)bottomSeparatorHeight {
    if (_bottomSeparatorHeight == bottomSeparatorHeight) return;
    _bottomSeparatorHeight = bottomSeparatorHeight;
    self.qmui_borderWidth = _bottomSeparatorHeight;
}

- (void)setCustomRightView:(UIView *)customRightView {
    _customRightView = customRightView;
    [self addSubview:_customRightView];
    FEEqualSpaceFlowLayoutEvolve *flowLayout = (FEEqualSpaceFlowLayoutEvolve *)_collectionView.collectionViewLayout;
    CGFloat width = CGRectGetWidth(customRightView.frame);
    CGFloat height = CGRectGetHeight(customRightView.frame);

    flowLayout.sectionInset = UIEdgeInsetsMake(0, self.itemSpacing, 0, self.itemSpacing + width);
    
    [customRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
}

- (void)setCustomLeftView:(UIView *)customLeftView {
    _customLeftView = customLeftView;
    [self addSubview:_customLeftView];
    FEEqualSpaceFlowLayoutEvolve *flowLayout = (FEEqualSpaceFlowLayoutEvolve *)_collectionView.collectionViewLayout;
    CGFloat width = CGRectGetWidth(_customLeftView.frame);
    CGFloat height = CGRectGetHeight(_customLeftView.frame);

    flowLayout.sectionInset = UIEdgeInsetsMake(0, self.itemSpacing+width, 0, self.itemSpacing);
    
    [_customLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.offset(0);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
}

- (void)setMoveLineHidden:(BOOL)moveLineHidden {
    _moveLineHidden = moveLineHidden;
    _moveLine.hidden = _moveLineHidden;
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    _titleArray = titleArray;
    [self updateTitleWidthArray];
    [_collectionView reloadData];
    CGFloat offsetX = [self getMoveLineOffsetX];
    [_moveLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self getWidthWithContent:_titleArray[_selectedIndex]]);
        make.left.offset(offsetX);
    }];
}

- (void)updateTitleWidthArray {
    NSMutableArray *temp = @[].mutableCopy;
    for (NSString *title in _titleArray) {
        CGFloat width = [self getWidthWithContent:title];
        [temp addObject:@(width)];
    }
    _titleWidthArray = temp;
}

- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex {
    if (_selectedIndex == targetIndex && !_alwaysTriggerSelected) {
        return;
    }
    self.appearanceSelectedIndex = targetIndex;
    
    _selectedIndex = targetIndex;
    
    [self layoutAndScrollToSelectedItem];
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (self.titleArray == nil && self.titleArray.count == 0) {
        return;
    }
    if (selectedIndex < 0 || selectedIndex >= self.titleArray.count) {
        return;
    }
    [self changeItemWithTargetIndex:selectedIndex];
}

- (void)setAppearanceSelectedIndex:(NSInteger)appearanceSelectedIndex {
    if (_appearanceSelectedIndex == appearanceSelectedIndex) return;
    [self setAppearanceSelectedIndex:appearanceSelectedIndex progress:1.f];

}

- (void)setAppearanceSelectedIndex:(NSInteger)appearanceSelectedIndex updateSelectedIndexValue:(BOOL)update {
    self.appearanceSelectedIndex = appearanceSelectedIndex;
    _selectedIndex = appearanceSelectedIndex;
}

- (void)setAppearanceSelectedIndex:(NSInteger)appearanceSelectedIndex progress:(CGFloat)progress {
    SegmentHeaderViewCollectionViewCell *selectedCell = [self getCell:_selectedIndex];
    SegmentHeaderViewCollectionViewCell *targetCell = [self getCell:appearanceSelectedIndex];

    
    UIColor *selectedCellTitleColor = [QMUIAnimationHelper interpolateFromValue:self.selectedTitleColor toValue:self.titleColor time:progress easing:QMUIAnimationEasingsLinear];
    UIColor *targetCellTitleColor = [QMUIAnimationHelper interpolateFromValue:self.titleColor toValue:self.selectedTitleColor time:progress easing:QMUIAnimationEasingsSpring];
    
    UIFont *seletedCellTitleFont;
    UIFont *targetCellTitleFont;
//    [UIFont fontWithDescriptor:self.font.fontDescriptor size:STWidth(self.font.pointSize)]
    if (progress == 0) {
        seletedCellTitleFont = self.selectedTitleFont;
        targetCellTitleFont = self.titleFont;
    } else if (progress == 1){
        seletedCellTitleFont = self.titleFont;
        targetCellTitleFont = self.selectedTitleFont;
    } else {
        NSNumber *seletedfontSize = [QMUIAnimationHelper interpolateFromValue:@(self.selectedTitleFont.pointSize) toValue:@(self.titleFont.pointSize) time:progress easing:QMUIAnimationEasingsLinear];
        NSNumber *targetfontSize = [QMUIAnimationHelper interpolateFromValue:@(self.titleFont.pointSize) toValue:@(self.selectedTitleFont.pointSize) time:progress easing:QMUIAnimationEasingsLinear];
        seletedCellTitleFont = [UIFont fontWithDescriptor:self.titleFont.fontDescriptor size:seletedfontSize.floatValue];
        targetCellTitleFont = [UIFont fontWithDescriptor:self.selectedTitleFont.fontDescriptor size:targetfontSize.floatValue];
    }
    
    if (selectedCell) {
        selectedCell.titleLabel.textColor = selectedCellTitleColor;
        selectedCell.titleLabel.font = seletedCellTitleFont;
        
        UIView *selectedCellBottomLine = selectedCell.bottomLine;
        CGFloat selectedCellBottomLineWidth = [[QMUIAnimationHelper interpolateFromValue:@(STWidth(18)) toValue:@(0) time:progress easing:QMUIAnimationEasingsLinear] floatValue];
        [selectedCellBottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(selectedCellBottomLineWidth);
        }];
    }
    
    if (targetCell) {
        targetCell.titleLabel.textColor = targetCellTitleColor;
        targetCell.titleLabel.font = targetCellTitleFont;
        
        UIView *targetCellBottomLine = targetCell.bottomLine;
        CGFloat targetCellBottomLineWidth = [[QMUIAnimationHelper interpolateFromValue:@(0) toValue:@(STWidth(18)) time:progress easing:QMUIAnimationEasingsSpring] floatValue];
        [targetCellBottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(targetCellBottomLineWidth);
        }];
    }
    _appearanceSelectedIndex = appearanceSelectedIndex;
}

#pragma mark - Private Method
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self setupSubViews];
}

- (void)setupSubViews {
    [self addSubview:self.collectionView];
  //  [self.collectionView addSubview:self.moveLine];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    if (_customRightView){
        FEEqualSpaceFlowLayoutEvolve *flowLayout = (FEEqualSpaceFlowLayoutEvolve *)_collectionView.collectionViewLayout;
        CGFloat width = CGRectGetWidth(_customRightView.frame);
         flowLayout.sectionInset = UIEdgeInsetsMake(0, self.itemSpacing, 0, self.itemSpacing + width);
        [self bringSubviewToFront:_customRightView];
    }
    
    if (_customLeftView){
        FEEqualSpaceFlowLayoutEvolve *flowLayout = (FEEqualSpaceFlowLayoutEvolve *)_collectionView.collectionViewLayout;
        CGFloat width = CGRectGetWidth(_customLeftView.frame);
         flowLayout.sectionInset = UIEdgeInsetsMake(0, self.itemSpacing + width, 0, self.itemSpacing);
        [self bringSubviewToFront:_customLeftView];
    }
}

- (SegmentHeaderViewCollectionViewCell *)getCell:(NSUInteger)Index {
    return (SegmentHeaderViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:Index inSection:0]];
}

- (void)layoutAndScrollToSelectedItem {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    if  (_collectionView.contentSize.width > CGRectGetWidth(self.frame)) {
        CGFloat offsetX = [self getMoveLineOffsetX] - CGRectGetWidth(self.frame)/2 + [self getWidthWithContent:_titleArray[_selectedIndex]] / 2;
        if (offsetX < 0) {
            offsetX = 0;
        } else if (offsetX > _collectionView.contentSize.width - CGRectGetWidth(self.frame)) {
            offsetX = _collectionView.contentSize.width - CGRectGetWidth(self.frame);
        }
        [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        //当item数量较多时，滚动到后面几个，会出现往前滚的Bug，所以改用设置contentOffset的方法
        //    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    
    
    if (self.selectedItemHelper) {
        self.selectedItemHelper(_selectedIndex);
    }


}

- (void)setupMoveLineDefaultLocation {
    CGFloat width = [self getWidthWithContent:self.titleArray[0]];
    [self.moveLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        if (_itemWidth > 0) {
            make.left.offset((_itemWidth - width) / 2);;
        } else {
            make.left.offset(self.itemSpacing);
        }
    }];
}

- (void)updateMoveLineLocation {

    CGFloat offsetX = [self getMoveLineOffsetX];
    [UIView animateWithDuration:0.2 animations:^{
        [self.moveLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.height.mas_equalTo(STWidth(3));
            make.left.offset(offsetX);
            make.width.mas_equalTo(_titleWidthArray[_selectedIndex].floatValue);
        }];
        [self.collectionView layoutIfNeeded];
    }];
}

- (CGFloat)getMoveLineOffsetX {
    CGFloat offsetX = 0;

    if (_itemWidth > 0) {
        offsetX = _itemSpacing * (_selectedIndex + 1) + _itemWidth  * _selectedIndex + (_itemWidth - _titleWidthArray[_selectedIndex].floatValue)/2;
    } else {
        offsetX = _itemSpacing * (_selectedIndex + 1);
        for (int i = 0; i < _selectedIndex; i ++) {
            CGFloat titleWidth = _titleWidthArray[i].floatValue;
            offsetX += titleWidth;
        }
    }
    return offsetX;
}

- (CGFloat)getWidthWithContent:(NSString *)content {
    if (self.selectedTitleFont == nil) return 0;
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:self.selectedTitleFont}
                                        context:nil
                   ];
    return ceilf(rect.size.width);;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = self.itemWidth > 0? self.itemWidth : [self getWidthWithContent:self.titleArray[indexPath.item]];
    return CGSizeMake(itemWidth, CGRectGetHeight(self.frame) );
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}
//在cellForItem中
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //注册多个cell，防止复用，复用会导致moveLine位置错误
    NSString *identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section, (long)indexPath.item];
    [collectionView registerClass:[SegmentHeaderViewCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    SegmentHeaderViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.item];
   if (indexPath.item == _selectedIndex) {
       cell.titleLabel.font = self.selectedTitleFont;
       cell.titleLabel.textColor = self.selectedTitleColor;
       
       [cell.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(STWidth(18));
       }];
    } else {
       cell.titleLabel.textColor = self.titleColor;
       cell.titleLabel.font = self.titleFont;
       
       [cell.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(0);
       }];
   }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self changeItemWithTargetIndex:indexPath.item];
}




#pragma mark - Lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        FEEqualSpaceFlowLayoutEvolve *flowLayout = [[FEEqualSpaceFlowLayoutEvolve alloc] initWthType:(AlignType)self.alignment];
        flowLayout.betweenOfCell = self.itemSpacing;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = self.itemSpacing;
       
       
        flowLayout.sectionInset = UIEdgeInsetsMake(0, self.itemSpacing, 0, self.itemSpacing);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, CGRectGetHeight(self.frame)) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.fe_contentBackgroundColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
    }
    return _collectionView;
}

- (UIView *)moveLine {
    if (_moveLineHidden) return nil;
    if (!_moveLine) {
        _moveLine = [[UIView alloc] init];
        _moveLine.backgroundColor = UIColor.fe_mainColor;
        _moveLine.layer.cornerRadius = STWidth(1.5);
    }
    return _moveLine;
}


@end

