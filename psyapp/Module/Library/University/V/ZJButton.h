//
//  ZJButton.h
//  smartapp
//
//  Created by lafang on 2019/2/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  按钮中图片的位置
 */
typedef NS_ENUM(NSUInteger, ZJImageAlignment) {
    /**
     *  图片在左，默认
     */
    ZJImageAlignmentLeft = 0,
    /**
     *  图片在上
     */
    ZJImageAlignmentTop,
    /**
     *  图片在下
     */
    ZJImageAlignmentBottom,
    /**
     *  图片在右
     */
    ZJImageAlignmentRight,
};

@interface ZJButton : UIButton
/**
 *  按钮中图片的位置
 */
@property(nonatomic,assign)ZJImageAlignment imageAlignment;
/**
 *  按钮中图片与文字的间距
 */
@property(nonatomic,assign)CGFloat spaceBetweenTitleAndImage;
@end

NS_ASSUME_NONNULL_END
