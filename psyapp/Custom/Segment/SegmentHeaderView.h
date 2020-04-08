//
//  SegmentHeaderView.h
//  smartapp
//
//  Created by lafang on 2018/10/11.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentHeaderViewCollectionViewCell : UICollectionViewCell
@property (nonatomic, readonly, strong) UILabel *titleLabel;
@end;

typedef NS_ENUM(NSInteger,SegmentHeaderAlignmentType){
    SegmentHeaderAlignmentLeft,
    SegmentHeaderAlignmentCenter,
    SegmentHeaderAlignmentRight
};

@interface SegmentHeaderView : UIView
@property (nonatomic, copy) NSArray <NSString *>*titleArray;

@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) SegmentHeaderAlignmentType alignment;
@property (nonatomic, assign) BOOL moveLineHidden;
@property (nonatomic, assign) CGFloat itemSpacing;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *selectedTitleFont;


@property (nonatomic, assign) CGFloat bottomSeparatorHeight;


@property (nonatomic, copy) void (^selectedItemHelper)(NSUInteger index);
@property (nonatomic, assign) BOOL alwaysTriggerSelected;

@property (nonatomic, strong) UIView *customRightView;
@property (nonatomic, strong) UIView *customLeftView;

- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex;

//只会更新appearance,不会更新selectedIndex，不会有s选中回调
@property (nonatomic) NSInteger appearanceSelectedIndex;
//更新selectedIndex,并更新appearance，有选中回调
@property (nonatomic) NSInteger selectedIndex;

//只会更新appearance,不会更新selectedIndex，不会有选中回调
- (void)setAppearanceSelectedIndex:(NSInteger)appearanceSelectedIndex  progress:(CGFloat)progress;

//更新appearance,并更新selectedIndex，不会有选中回调
- (void)setAppearanceSelectedIndex:(NSInteger)appearanceSelectedIndex updateSelectedIndexValue:(BOOL)update;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray ;
@end
