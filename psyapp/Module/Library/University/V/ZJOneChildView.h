//
//  ZJOneChildView.h
//  smartapp
//
//  Created by lafang on 2019/2/21.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJOneChildViewDelegate <NSObject>

/**
 * 选中左边tableview cell的回调事件
 
 @param leftIndex 左边的索引
 @param rightIndex 右边的索引
 */
-(void)oneViewLeftTableviewDidSelectedWithLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex;

/**
 * 选中右边tableview cell的回调事件
 
 @param leftIndex 左边的索引
 @param rightIndex 右边的索引
 */
-(void)oneViewRightTableviewDidSelectedWithLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex;

@end


@interface ZJOneChildView : UIView

@property(nonatomic ,strong) NSArray        *leftDataArray;

@property(nonatomic ,strong) NSArray        *rightDataArray;

@property(nonatomic ,strong) UITableView    *leftTable;

@property(nonatomic ,strong) UITableView    *rightTable;


@property(nonatomic ,weak) id<ZJOneChildViewDelegate> delegate;

@end
