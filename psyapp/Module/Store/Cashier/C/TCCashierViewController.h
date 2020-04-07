//
//  TCCashierViewController.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/14.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseViewController.h"
#import "TCProductModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TCCashierViewControllerDelegate <NSObject>
- (void)cashierDataErrorOccuredWithProductModel:(TCProductItemBaseModel *)productModel;
@end

@interface TCCashierViewController : FEBaseViewController
@property (nonatomic, weak) id <TCCashierViewControllerDelegate> delegate;

+ (void)handleExchangeWithProductModel:(TCProductItemBaseModel *)productModel presentedViewController:(UIViewController *)presentedViewController delegate:(id<TCCashierViewControllerDelegate> _Nullable)delegate;
@end

NS_ASSUME_NONNULL_END
