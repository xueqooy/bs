//
//  PAPeriodStageSelectionView.h
//  psyapp
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAPeriodStageSelectionView : UIView
@property (nonatomic, copy) NSArray <NSString *>*stageNames;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat buttonHeight;

@property (nonatomic, copy) void (^onSelect)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
