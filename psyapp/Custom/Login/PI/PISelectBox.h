//
//  PISelectBox.h
//  smartapp
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PIXibBaseBox.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PISelectBoxProtocal <NSObject>
@required
@property (nonatomic, copy) void(^pi_selectedHandler)(NSString *content);
- (void)pi_showSelector;
@optional
@property (nonatomic, copy) void(^pi_hiddenHandler)(void);

@end

@interface PISelectBox : PIXibBaseBox
@property (nonatomic, copy, readonly) NSString *selectedContent;

- (void)setCategory:(NSString *)category placeholder:(NSString *)placeholder;
@property (nonatomic, strong) id <PISelectBoxProtocal>selector;
@end

NS_ASSUME_NONNULL_END
