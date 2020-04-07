//
//  DeleteResponseTextField.h
//  CheersgeniePlus
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeleteResponseTextField : UITextField
@property (nonatomic, copy) void (^deletedHandler) (NSString *before );
@end

NS_ASSUME_NONNULL_END
