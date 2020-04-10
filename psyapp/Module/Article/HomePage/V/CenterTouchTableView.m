//
//  CenterTouchTableView.m
//  smartapp
//
//  Created by lafang on 2018/10/11.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "CenterTouchTableView.h"

@implementation CenterTouchTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
