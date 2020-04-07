//
//  FEAnswerMergeSelectionCell.h
//  smartapp
//
//  Created by mac on 2019/11/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FEMergeSubquestionModel;
NS_ASSUME_NONNULL_BEGIN

@interface FEAnswerMergeSelectionCell : UITableViewCell <UIGestureRecognizerDelegate>
@property (nonatomic, copy) void(^answeredHandler)(NSInteger optionIndex, NSString *optionText);

- (void)setSelectedIndex:(NSInteger)selectedIndex options:(NSArray <NSString *>*)options subject:(NSString *)subject ;
@end

NS_ASSUME_NONNULL_END
