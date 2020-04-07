//
//  KMTag.m
//  KMTag
//
//  Created by chavez on 2017/7/13.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "KMTag.h"
#import "UIColor+Category.h"

@implementation KMTag

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setupWithText:(NSString*)text {
    
    self.text = text;
//    self.textColor = [KMTools colorWithHexString:@"#999999"];
    self.textColor = UIColor.fe_mainTextColor;
    self.font = [UIFont systemFontOfSize:14];
    UIFont* font = self.font;
    
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(size.width + 20, size.height + 10);
    
    self.frame = frame;
    
    self.layer.cornerRadius = 5;
    self.layer.borderColor = UIColor.fe_titleTextColorLighten.CGColor;
    self.layer.borderWidth = 1.0;
    
}



@end
