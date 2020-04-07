//
//  FEEvaluationReportSelectionView.h
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEEvaluationReportSelectionView : UIView
@property (nonatomic, copy) void (^selectHandler)(NSInteger index);
@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger targetIndex;//标记将要选择的index，点击后立即赋值,作用于collectionView滚动过程中，使不是targetIndex对应的cell不加载
- (void)updateSelectedIndex:(NSInteger)index isTriggeredByTap:(BOOL)byTap;
- (instancetype)initWithItemNames:(NSArray <NSString *> *)itemNames;
- (void)adjustSelectedItemToLeftmostEnd;
@end

NS_ASSUME_NONNULL_END
