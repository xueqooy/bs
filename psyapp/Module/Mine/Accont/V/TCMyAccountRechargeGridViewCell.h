//
//  TCMyAccountRechargeGridViewCell.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCMyAccountRechargeGridViewCell : UIView
@property (nonatomic, copy) void (^onTap)(void);
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) NSInteger emoneyCount;
@property (nonatomic, assign) NSInteger price;
@end

NS_ASSUME_NONNULL_END
