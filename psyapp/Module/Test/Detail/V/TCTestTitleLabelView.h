//
//  TCRoundTitleLabel.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/1.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCTestTitleLabelView : UIView
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *mainText;

@property (nonatomic, assign) CGFloat prefersMainTextWidth;
@end

NS_ASSUME_NONNULL_END
