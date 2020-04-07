//
//  UITabBar+Tip.m
//  FlyClip
//
//  Created by 都兴忱 on 2017/2/6.
//  Copyright © 2017年 tongboshu. All rights reserved.
//

#import "UITabBar+Tip.h"

@implementation UITabBar (Tip)
//显示小红点
- (void)showTipOnItemIndex:(NSInteger)index unread:(NSString *)unreads{
    //移除之前的小红点
    [self removeTipOnItemIndex:index];
    //新建小红点
    UILabel *TipView = [[UILabel alloc]init];
    TipView.textColor = [UIColor whiteColor];
    TipView.text = unreads;
    TipView.font = [UIFont systemFontOfSize:12];
    TipView.textAlignment = NSTextAlignmentCenter;
    TipView.tag = 888 + index;
    TipView.layer.cornerRadius = 13.0;//圆形
    TipView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;

    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / 5.0; // 5个tabbar
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    TipView.frame = CGRectMake(x-4, y-4, 34, 26);//圆形大小为10
    TipView.clipsToBounds = YES;
    [self addSubview:TipView];
}
-(CGSize)sizeWithString:(NSString *)str
                  fount:(UIFont*)fount
                maxSize:(CGSize)size {
    
    CGRect rect = [str boundingRectWithSize:size
                                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                                 attributes:@{NSFontAttributeName:fount}
                                    context:nil];
    return rect.size;
}

//隐藏小红点
- (void)hideTipOnItemIndex:(NSInteger)index{
    //移除小红点
    [self removeTipOnItemIndex:index];
}

//移除小红点
- (void)removeTipOnItemIndex:(NSInteger)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
