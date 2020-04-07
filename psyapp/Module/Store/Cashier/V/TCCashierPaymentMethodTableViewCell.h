//
//  TCCashierPaymentMethodTableViewCell.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/14.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCCashierPaymentMethodTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL checked;
- (void)setIconImage:(UIImage *)image name:(NSString *)name checked:(BOOL)checked;
- (void)setSeparatorHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
