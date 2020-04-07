//
//  UIImageView+Utils.m
//  FlyClip
//
//  Created by zhangmingwei on 2017/11/27.
//  Copyright © 2017年 tongboshu. All rights reserved.
//

#import "UIImageView+Utils.h"

@implementation UIImageView (Utils)

/**
 *  获取常用的 UIImageView
 *
 *  @param frame 设置圆角的时候需要
 *
 *  @return UIImageView
 */
+ (UIImageView *)imageViewWithFrame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;     ///这个是取中间的一部分。。不压缩的。
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

-(void)setImageByBezierPathWithImage:(UIImage *)image radius:(CGFloat)radius {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                cornerRadius:radius] addClip];
    [image drawInRect:self.bounds];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
