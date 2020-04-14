//
//  ZJThreeChildView.h
//  smartapp
//
//  Created by lafang on 2019/2/21.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJThreeChildViewDelegate <NSObject>


/**
 * 选中的cell 回调
 
 @param index 索引
 */
-(void)threeViewTableviewDidSelectedWithIndex:(NSInteger)index;

@end


@interface ZJThreeChildView : UIView

@property(nonatomic ,assign) NSInteger seleIndex;


@property(nonatomic ,strong) UITableView *mainTable;

@property(nonatomic ,strong) NSArray *titleArray;

@property(nonatomic ,weak) id<ZJThreeChildViewDelegate> delegate;



@end
