//
//  TCSimultaneousScrollView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/23.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCSimultaneousScrollView.h"

@implementation TCSimultaneousScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (self.contentOffset.y == 0) return YES;
    return NO;
}
@end
