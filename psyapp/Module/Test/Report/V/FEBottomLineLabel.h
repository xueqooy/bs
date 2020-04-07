//
//  FEBottomLineLabel.h
//  smartapp
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEBottomLineLabel : UIView
@property(nonatomic, copy) NSString *text;
- (instancetype)initWithLabelText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
