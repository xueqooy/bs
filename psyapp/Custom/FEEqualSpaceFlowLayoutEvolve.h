//
//  FEEqualSpaceFlowLayoutEvolve.h
//  UICollectionViewDemo
//
//  Created by xueqooy on 17/5/26.
//  Copyright © 2017年 CHC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AlignType){
    AlignWithLeft,
    AlignWithCenter,
    AlignWithRight
};

@interface FEEqualSpaceFlowLayoutEvolve : UICollectionViewFlowLayout
//两个Cell之间的距离
@property (nonatomic,assign)CGFloat betweenOfCell;
//cell对齐方式
@property (nonatomic,assign)AlignType cellType;

-(instancetype)initWthType : (AlignType)cellType;

@property (nonatomic, assign) BOOL isHorizontal;
@property (nonatomic, assign) BOOL verticalToHorizontal;
@end
