//
//  PAHomeGridViewCell.h
//  psyapp
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAHomeGridViewCell : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, copy) void (^onTouch)(void);

@property (nonatomic, copy) void (^onButtonClick)(void);
 @end

NS_ASSUME_NONNULL_END
