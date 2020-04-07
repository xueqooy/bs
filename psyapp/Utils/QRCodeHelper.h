//
//  QRCodeHelper.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/7.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeHelper : NSObject
+ (UIImage *)generateQRCodeImageByString:(NSString *)string size:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
