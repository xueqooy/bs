//
//  ZJFourChildView.h
//  smartapp
//
//  Created by lafang on 2019/2/21.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJFourChildViewDelegate <NSObject>

/**
 * 选中的cell 回调
 
 @param index 索引
 */
-(void)fourViewTableviewDidSelectedWithIndex:(NSInteger)index;

@end

@interface ZJFourChildView : UIView


@property(nonatomic ,strong) UITableView *mainTable;

@property(nonatomic ,strong) NSArray *titleArray;

@property(nonatomic ,weak) id<ZJFourChildViewDelegate> delegate;

@end
