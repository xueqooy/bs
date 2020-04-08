//
//  TCSearchMainViewController.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN



@interface TCLibSearchMainViewController : FEBaseViewController
@property (nonatomic, copy) NSString *keyword;
- (void)present;

@end

NS_ASSUME_NONNULL_END
