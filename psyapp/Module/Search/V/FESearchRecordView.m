//
//  FESearchRecordView.m
//  smartapp
//
//  Created by xueqooy on 2019/7/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FESearchRecordView.h"
#import "FEEqualSpaceFlowLayoutEvolve.h"
#import "FECommonAlertView.h"

@interface FESearchRecordCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *text;
@end

@implementation FESearchRecordCollectionViewCell {
    UILabel *_label;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.layer.cornerRadius = 2;
    self.backgroundColor = UIColor.fe_buttonBackgroundColorActive;

    _label = [[UILabel alloc] init];
    _label.font = [UIFont systemFontOfSize:14];
    _label.textColor = UIColor.fe_auxiliaryTextColor;
    _label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    _label.text = _text;
}


@end

@interface FESearchRecordView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) UIButton *trashButton;
@property (nonatomic, assign) NSInteger maxCap;
@end

static NSString * const kSearchRecordKey = @"search_record";
@implementation FESearchRecordView
{
    NSMutableArray *_records;
}
#pragma mark - public
- (instancetype)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
        self.key = key;
        self.maxCap = 20;
//        _records = @[@"测试", @"好棒我啊啊 啊啊啊", @"是打算打算打算打算打算打算打算的大时代大厦的啊的爱上大叔的撒 阿斯顿", @"das", @"1",@"dsadasdasdas", @"说的是当时的"].mutableCopy;
//        self.popularSearchTextArray = @[@"搜a你哦吗", @"是大多数", @"搭噶的阿", @"额但素健康的哈萨克觉得哈萨克剑辉的家啊是", @"大好时机看动画设计大奖就打算空间", @"das"];
        [self _loadLocalSearchRecords];
        [self addSubview:self.collectionView];
        
        
        [self.collectionView addTapGestureWithBlock:^{
            [mKeyWindow endEditing:YES];
        }];
        
        self.collectionView.gestureRecognizers.lastObject.delegate = self;
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = frame;
}

- (void)setMaximumCapacityOfRecords:(NSInteger)n {
    _maxCap = n;
}

- (void)reloadRecords {
    [self _loadLocalSearchRecords];
    [self.collectionView reloadData];
}

- (void)saveSearchRecord:(NSString *)aRecord {
    
    NSMutableArray *data = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:_key?_key : kSearchRecordKey];
    NSMutableArray *newRecords;
    if (data.count == 0) {
        newRecords = @[].mutableCopy;
        [newRecords addObject:aRecord];
    } else {
        newRecords = [NSMutableArray arrayWithArray:data];
        if (data.count >= _maxCap) { //超出记录最大容量
            [newRecords removeLastObject];
        }
        BOOL new = YES;     //查重
        for (NSString *anOldRecord in data) {
            if ([anOldRecord isEqualToString:aRecord]) {
                new = NO;
            }
        }
        if (new) {
            [newRecords insertObject:aRecord atIndex:0]; //倒序
        }
    }
    //存档
    [[NSUserDefaults standardUserDefaults] setObject:newRecords forKey:_key?_key : kSearchRecordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self reloadRecords];
}
#pragma mark - private

- (void)_loadLocalSearchRecords {
    _records = @[].mutableCopy;
    NSArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:_key?_key : kSearchRecordKey];
    _records = data.mutableCopy;
    if (_records.count != 0) {
        [self addSubview:self.collectionView];
    }
}

#pragma mark - lazy
-(UICollectionView *)collectionView
{
    if(!_collectionView){
        
        FEEqualSpaceFlowLayoutEvolve *flowLayout = [[FEEqualSpaceFlowLayoutEvolve alloc]initWthType:AlignWithLeft];
        
        _collectionView =[ [UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.fe_contentBackgroundColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        
        //注册
        [_collectionView registerClass:[FESearchRecordCollectionViewCell class] forCellWithReuseIdentifier:@"cellReuseIdentifier"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewReuseIdentifier"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _records.count;
    } else {
        return self.popularSearchTextArray.count;
    }
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FESearchRecordCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellReuseIdentifier" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    FESearchRecordCollectionViewCell *_cell = ((FESearchRecordCollectionViewCell *)cell);
    if (indexPath.section == 0) {
        _cell.text = _records[indexPath.item];
    } else {
        _cell.text = self.popularSearchTextArray[indexPath.item];
    }
}

//设置头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewReuseIdentifier" forIndexPath:indexPath];
    [headerReusableView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(kind == UICollectionElementKindSectionHeader){
        UILabel *sectionLabel = [[UILabel alloc] init];
        [headerReusableView addSubview:sectionLabel];

        sectionLabel.textColor = indexPath.section == 0?  UIColor.fe_mainTextColor : UIColor.fe_mainColor;
        sectionLabel.font = STFontBold(14);
        sectionLabel.text = indexPath.section == 0? @"历史记录" : @"大家都在搜";
        
        if (indexPath.section == 0) {
            [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerReusableView).offset(STWidth(15));
                make.centerY.equalTo(headerReusableView);
            }];
            
            UIButton *trashButton = [UIButton new];
            [trashButton setImage:_records? [UIImage imageNamed:@"trash"]:nil forState:UIControlStateNormal];;
            [headerReusableView addSubview:trashButton];
            [trashButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(STSize(18, 18));
                make.right.equalTo(headerReusableView).offset(- STWidth(15));
                make.centerY.equalTo(headerReusableView);
            }];
            
            [trashButton addTarget:self action:@selector(deleteAllRecords)
                   forControlEvents:UIControlEventTouchUpInside];
        } else {
            [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerReusableView).offset(STWidth(40));
                make.centerY.equalTo(headerReusableView);
            }];
            
            UIImageView *imageView = UIImageView.new;
            imageView.image = [UIImage imageNamed:@"search_hot"];
            [headerReusableView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(STSize(18, 18));
                make.left.offset(STWidth(15));
                make.centerY.offset(0);
            }];
        }
        
    }
    if (indexPath.section == 0) {
        headerReusableView.hidden = _records.count == 0;
    } else {
        headerReusableView.hidden = self.popularSearchTextArray.count == 0;
    }
   
    return headerReusableView;
}
- (void)deleteAllRecords {
    [mKeyWindow endEditing:YES];
    FECommonAlertView *alert = [[FECommonAlertView alloc] initWithTitle:@"确定要删除所有历史记录吗" leftText:@"取消" rightText:@"确定" icon:nil];
    alert.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            NSMutableArray *emptyRecord = @[].mutableCopy;
            [[NSUserDefaults standardUserDefaults] setObject:emptyRecord forKey:_key?_key : kSearchRecordKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self reloadRecords];
        }
    };
    [alert showCustomAlertView];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (section == 0) {
        height = _records.count == 0 ? 0 : 50;
        return CGSizeMake(_collectionView.frame.size.width, height);
    } else {
        height = self.popularSearchTextArray.count == 0 ? 0 : 50;
        return CGSizeMake(_collectionView.frame.size.width, height);
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectString ;
    if (indexPath.section == 0) {
        selectString = _records[indexPath.item];
    } else {
        selectString = self.popularSearchTextArray[indexPath.item];
    }
    if (selectString) {
        if (_selectCompletionHandler) {
            _selectCompletionHandler(selectString);
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *content;
    if (indexPath.section == 0) {
        content = _records[indexPath.item];
    } else {
        content = self.popularSearchTextArray[indexPath.item];
    }
    //计算字体宽度
    CGRect itemFrame = [content boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    CGFloat width = itemFrame.size.width + 20;
    
    if(width > self.frame.size.width - 42 - 15 ){
        return CGSizeMake(self.frame.size.width - 15 - 42 ,40);
    }
    return CGSizeMake(width + 10,40);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.collectionView] && touch.view != self.collectionView) {
        return NO;
    } else {
        return YES;
    }
}
@end


@implementation FESearchRecordView (Popular)
_Pragma("clang diagnostic push") _Pragma(ClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(ClangWarningConcat("-Wmismatched-return-types"))
static char kAssociatedObjectKey_popularSearchTextArray;
- (void)setPopularSearchTextArray:(id)popularSearchTextArray {
    [self reloadRecords];
    objc_setAssociatedObject(self, &kAssociatedObjectKey_popularSearchTextArray, popularSearchTextArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)popularSearchTextArray {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_popularSearchTextArray);
}
_Pragma("clang diagnostic pop")



@end
