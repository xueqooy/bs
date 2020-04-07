//
//  TCCashierProductTableViewCell.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/14.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCCashierProductTableViewCell : UITableViewCell
- (void)setIconImageURL:(NSURL *)imageURL name:(NSString *)name price:(CGFloat)price;
@end

NS_ASSUME_NONNULL_END
