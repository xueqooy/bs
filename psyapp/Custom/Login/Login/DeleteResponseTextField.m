//
//  DeleteResponseTextField.m
//  CheersgeniePlus
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "DeleteResponseTextField.h"

@implementation DeleteResponseTextField

- (void)deleteBackward {
    NSString *text = [self.text copy];
    if (_deletedHandler) {
        _deletedHandler(text);
    }
    [super deleteBackward];
}

@end
