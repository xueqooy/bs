//
//  UIView+Extension.h
//  slp_ios_student
//
//  Created by 曾新 on 16/3/7.
//  Copyright © 2016年 ND. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat top;    //Y做标    self.frame.origin.x
@property (nonatomic, assign) CGFloat left;   //X坐标     self.frame.origin.x
@property (nonatomic, assign) CGFloat bottom; //视图最底端 self.frame.origin.y + self.frame.size.height
@property (nonatomic, assign) CGFloat right;  //视图最右边 self.frame.origin.x + self.frame.size.width

- (UIViewController *) attachedViewController;

////当每个view的width不一样，横向等间隙的排列一组view.每个view自己要设置top的位置和控件的size
//- (void)distributeSpacingHorizontallyWith:(NSArray*)views;
//
///**
// *  网络加载
// *
// *  @param string 提示文字
// */
//- (void)networkLoad:(NSString *)string;
//
///**
// *  隐藏对话框
// */
//- (void)hiddenNetworkLoad;
//
///**
// *  提醒
// *
// *  @param string    提醒的文字
// *  @param timeFloat 时间
// */
//-(void)reminder:(NSString *)string time:(int)timeFloat;



@end
