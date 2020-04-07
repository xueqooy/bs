//
//  UIImageView+Utils.h
//  FlyClip
//
//  Created by zhangmingwei on 2017/11/27.
//  Copyright © 2017年 tongboshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Utils)

/**
 *  获取常用的 UIImageView  默认：UIViewContentModeScaleAspectFill;     //取图片中间的一部分，不压缩。
 *
 *  @param frame 设置圆角的时候需要
 *
 *  @return UIImageView
 */
+ (UIImageView *)imageViewWithFrame:(CGRect)frame;


/**
 *  用于添加圆角
 *  @param image 添加的图片
 *  @param radius 圆角比例
 */
- (void)setImageByBezierPathWithImage:(UIImage *)image radius:(CGFloat)radius;
@end
