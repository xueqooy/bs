//
//  UIImage+ColorAtPixel.h
//  公议
//
//  Created by 吴伟毅 on 18/1/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorAtPixel)
- (UIColor *)colorAtPixel:(CGPoint)point;
@end
