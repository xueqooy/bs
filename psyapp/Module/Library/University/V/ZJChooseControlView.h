//
//  ZJChooseControlView.h
//  smartapp
//
//  Created by lafang on 2019/2/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZJChooseControlDelegate <NSObject>

// 点击按钮
-(void)chooseControlWithBtnArray:(NSArray *)array button:(UIButton *)sender;

@end

@interface ZJChooseControlView : UIView

@property(nonatomic ,strong) NSArray *titleArr;

@property(nonatomic ,weak) id<ZJChooseControlDelegate> delegate;
// 按钮数组
@property(nonatomic ,strong) NSMutableArray *btnArr;

-(void)setUpAllViewWithTitleArr:(NSArray *)titleArr;

@end

NS_ASSUME_NONNULL_END
