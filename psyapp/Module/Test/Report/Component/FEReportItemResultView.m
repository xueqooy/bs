//
//  FEReportItemResultView.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportItemResultView.h"
#import "FEEqualSpaceFlowLayoutEvolve.h"

@implementation FEReportItemResultView {
    NSString *_name;
    id _result;
    BOOL _isBadTendency;
    CGFloat _width;
    
    UICollectionView *_collectionView;
    NSArray <NSString *>*_data;
}

- (instancetype)initWithItemName:(NSString *)name result:(id)result isBadTendency:(BOOL)isBadTendency projectedContentWidth:(CGFloat)width{
    self = [super init];
    if ([NSString isEmptyString:name]) {
        name = @"";
    }
    _name = name;
    _result = result;
    if ([result isKindOfClass:NSNumber.class]) {
        _result = @[[NSString formatFloatNumber:(NSNumber *)_result AfterDecimalPoint:1]];
    } else if ([result isKindOfClass:NSString.class]) {
        _result = @[[NSString stringWithString:_result]];
    }
    _data = [@[_name] arrayByAddingObjectsFromArray:_result];
    
    _isBadTendency = isBadTendency;
    _width = width;
    [self build];
    return self;
}


- (void)build {
    FEEqualSpaceFlowLayoutEvolve *layout = [[FEEqualSpaceFlowLayoutEvolve alloc] initWthType:AlignWithLeft];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = STWidth(10);
    layout.minimumInteritemSpacing = STWidth(10);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _width, 10) collectionViewLayout:layout];
    _collectionView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[FEReportItemResultViewNameCell class] forCellWithReuseIdentifier:@"FEReportItemResultViewNameCell"];
    [_collectionView registerClass:[FEReportItemResultViewResultCell class] forCellWithReuseIdentifier:@"FEReportItemResultViewResultCell"];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.size.mas_equalTo(CGSizeMake(_width, _collectionView.collectionViewLayout.collectionViewContentSize.height));
    }];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _data.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize;
    if (indexPath.item == 0) {
        itemSize = CGSizeMake([_data[0] getWidthForFont:STFontBold(16)], STWidth(22));
    } else {
        itemSize = CGSizeMake([_data[indexPath.item] getWidthForFont:STFont(12)] + STWidth(20), STWidth(22));
    }
    return itemSize;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        FEReportItemResultViewNameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FEReportItemResultViewNameCell" forIndexPath:indexPath];
        return cell;
    } else {
        FEReportItemResultViewResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FEReportItemResultViewResultCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        FEReportItemResultViewNameCell *_cell = (FEReportItemResultViewNameCell *)cell;
        [_cell setName:_data[0]];
    } else {
        FEReportItemResultViewResultCell *_cell = (FEReportItemResultViewResultCell *)cell;
        [_cell setResult:_data[indexPath.item] isBadTendency:_isBadTendency];
    }
}
@end



@implementation FEReportItemResultViewNameCell {
    UILabel *_label;
    NSString *_name;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setupSubviews];
    return self;
}

- (void)setName:(NSString *)name {
    _name = name;
    _label.text = _name;
}


- (void)setupSubviews {
    _label = [[UILabel alloc] init];
    _label.text = _name;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = UIColor.fe_titleTextColorLighten;
    [_label setFont:STFontBold(16)];
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
}
@end

@implementation FEReportItemResultViewResultCell {
    UILabel *_label;
    NSString *_result;
    BOOL _isBadTendency;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layer.cornerRadius = STWidth(2);
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = self.tendencyColor.CGColor;
    self.backgroundColor = _isBadTendency? [UIColor.fe_warningColor colorWithAlphaComponent:0.05] : [UIColor.fe_safeColor colorWithAlphaComponent:0.05];;
    [self setupSubviews];
    return self;
}

- (void)setResult:(NSString *)result isBadTendency:(BOOL)isBadTendency{
    _result = result;
    _label.text = result;
    _isBadTendency = isBadTendency;
    _label.textColor = self.tendencyColor;
    self.backgroundColor = _isBadTendency? [UIColor.fe_warningColor colorWithAlphaComponent:0.05] : [UIColor.fe_safeColor colorWithAlphaComponent:0.05];;
    self.layer.borderColor = self.tendencyColor.CGColor;

}

- (void)setupSubviews {
    _label = [UILabel createLabelWithDefaultText:_result numberOfLines:1 textColor:self.tendencyColor font:STFont(12)];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
}

- (UIColor *)tendencyColor {
    return _isBadTendency?UIColor.fe_warningColor:UIColor.fe_safeColor;
}

@end
