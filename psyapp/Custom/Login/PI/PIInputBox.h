//
//  PIInputBox.h
//  smartapp
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PIXibBaseBox.h"


@interface PIInputBox : PIXibBaseBox
@property (nonatomic, copy) NSString *inputedContent;
@property (nonatomic, assign) BOOL inputEnabled;
- (void)setCategory:(NSString *)category placeholder:(NSString *)placeholder;
@end

