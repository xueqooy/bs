//
//  ThirdSignInFooterView.h
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/16.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThirdSignInFooterView : UIView
@property(nonatomic, copy) void(^wechatButtonClickHandler)(void);
@property(nonatomic, copy) void(^qqButtonClickHandler)(void);
@property(nonatomic, copy) void(^vistorButtonClickHandler)(void);
@property(nonatomic, copy) void(^serviceButtonClickHandler)(void);
@property(nonatomic, copy) void(^secretButtonClickHandler)(void);

@end

NS_ASSUME_NONNULL_END
