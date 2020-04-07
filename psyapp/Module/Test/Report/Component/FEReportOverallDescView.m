//
//  FEReportOverallDescriptionView.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportOverallDescView.h"

@implementation FEReportOverallDescView {
    NSString *_content;
    CGFloat _width;
}

- (instancetype)initWithDescriptionContent:(NSString *)content projectedContentWidth:(CGFloat)width{
    self = [super init];
    _content = content;
    _width = width;
    [self build];
    return self;
}

- (void)build {
   
   UITextView *contentView = [[UITextView alloc] init];
   contentView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
   contentView.backgroundColor = [UIColor clearColor];
   contentView.editable = NO;
   contentView.selectable = NO;
   contentView.attributedText = [StringUtils setupAttributedString:_content font:STWidth(12)];
   contentView.textColor = UIColor.whiteColor;
   [self addSubview:contentView];
   
   CGFloat minHeight = [_content getHeightForFont:[UIFont systemFontOfSize:STWidth(12)] width:_width] + 10;
   CGFloat maxHeight = [SizeTool height:84];
   [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.top.offset(0);
       if (minHeight > maxHeight) {
           make.height.mas_equalTo(maxHeight);//描述内容过长，可滚动查看
       } else {
           make.height.mas_equalTo(minHeight);
       }
       
       make.bottom.right.offset(0);
   }];
}
@end
