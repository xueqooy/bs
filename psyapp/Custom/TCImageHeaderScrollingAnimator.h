//
//  TCImageHeaderScrollingAnimator.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/6.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCImageHeaderScrollingAnimator : NSObject <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readonly)  UIView *container;
@property (nonatomic) UIImage *image;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat relativeOffsetFactor;
@property (nonatomic, readonly) CGFloat scrollViewActualOffsetY;
@property (nonatomic) BOOL adjustsScrollIndicatorInsets;//vertical

- (void)setSize:(CGSize)size animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
