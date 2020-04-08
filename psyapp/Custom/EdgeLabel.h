//
//  EdgeLabel.h
//  smartapp
//
//  Created by lafang on 2018/9/26.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EdgeLabel : UILabel

// 用来决定上下左右内边距，也可以提供一个借口供外部修改，在这里就先固定写死
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@end
