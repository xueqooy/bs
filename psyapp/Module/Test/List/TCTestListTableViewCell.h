//
//  TCTestListTableViewCell.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/13.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCTestListTableViewCell : UITableViewCell
- (void)setTitleText:(NSString *)titleText participantsCount:(NSUInteger)count iconImageURL:(NSURL *)imageURL alreadyPurchase:(BOOL)purchased presentPrice:(CGFloat)presentPrice originPrice:(CGFloat)originPrice;
- (void)setCompleted:(BOOL)completed;

@property (nonatomic, assign) BOOL prefersWiderCellStyle;

@end

NS_ASSUME_NONNULL_END
