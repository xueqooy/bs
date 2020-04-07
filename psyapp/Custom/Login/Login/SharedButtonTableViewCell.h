//
//  SharedButtonTableViewCell.h
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/17.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "BaseTableViewCell.h"
typedef NS_OPTIONS(NSUInteger, SharedButtonComponent) {
    SharedButtonComponentLeftButton = 1 << 0,
    SharedButtonComponentRightButton = 1 << 1,
};
typedef NS_OPTIONS(NSUInteger, SharedButtonType) {
    SharedButtonTypetMain = 0,
    SharedButtonTypeLeft,
    SharedButtonTypeRight
};
NS_ASSUME_NONNULL_BEGIN

@interface SharedButtonTableViewCell : BaseTableViewCell
@property (nonatomic, copy) void (^buttonClickedHandler) (SharedButtonType type, UIButton *sender);

- (void)buildComponent:(SharedButtonComponent)comp;
- (void)setMainButtonEnabled:(BOOL)enabled;
- (void)setMainButtonTitle:(NSString *)title;
- (void)setLeftButtonTitle:(NSString *)title;
- (void)setRightButtonTitle:(NSString *)title;
- (void)setHidden:(BOOL)hidden forButton:(SharedButtonType)type;
@end

NS_ASSUME_NONNULL_END
