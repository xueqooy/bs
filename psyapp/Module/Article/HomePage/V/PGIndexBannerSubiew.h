//
//  PGIndexBannerSubiew.h
//  smartapp
//
//  Created by lafang on 2018/10/10.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EdgeLabel.h"
//#import "DevelopEvaluateModel.h"
#import "DateUtil.h"

@interface PGIndexBannerSubiew : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;



@property (nonatomic, copy) void (^didSelectCellBlock)(NSInteger tag, PGIndexBannerSubiew *cell);



//-(void)updateContent:(DevelopEvaluateModel *)model;


/**
 设置子控件frame,继承后要重写
 
 @param superViewBounds <#superViewBounds description#>
 */
- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds;

@end
