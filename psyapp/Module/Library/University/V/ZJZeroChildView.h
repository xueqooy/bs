//
//  ZJZeroChildView.h
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJZeroChildViewDelegate <NSObject>
/**
 * 选中的cell 回调
 
 @param index 索引
 */
-(void)zeroViewTableviewDidSelectedWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZJZeroChildView : UIView

@property(nonatomic ,strong) UITableView *mainTable;

@property(nonatomic ,strong) NSArray *titleArray;

@property(nonatomic ,weak) id<ZJZeroChildViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
