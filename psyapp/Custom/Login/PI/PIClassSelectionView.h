//
//  PIClassSelectionView.h
//  ClassSelection
//
//  Created by xueqooy on 2019/10/30.
//  Copyright © 2019年 cheers-genius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIClassSelectionView : UIView
@property (nonatomic, copy, readonly) NSString *selectedClassName;
@property (nonatomic, copy) void (^onSelected)(NSString *name);
- (void)setUnselected;

@end
