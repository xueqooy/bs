//
//  PIBoxStateManager.m
//  smartapp
//
//  Created by mac on 2019/10/31.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PIBoxStateManager.h"

@interface PIBoxStateManager ()

@property (nonatomic, assign) NSInteger completedFlag;
@property (nonatomic, copy)  void(^completedHandler)(void);
@property (nonatomic, weak) UIButton *completeButton;

@end

@implementation PIBoxStateManager
- (instancetype)initWithBoxes:(NSArray<PIXibBaseBox *> *)boxes completeButton:(UIButton *)button completedHandler:(void (^)(void))completeHandler{
    self = [super init];
    if (boxes.count == 0) {
        return  nil;
    }
    _completedFlag = boxes.count;
    _completeCount = 0;
    _completeButton = button;
    _completeButton.fe_adjustTitleColorAutomatically = YES;
    _completeButton.backgroundColor = [UIColor.fe_mainColor colorWithAlphaComponent:0.4];
    _completedHandler = completeHandler;
    @weakObj(self);
    for (PIXibBaseBox *box in boxes) {
        box.stateHandler = ^(BOOL complete) {
            @strongObj(self);
            [self handleStateChange:complete];
        };
    }
    
    return self;
}


- (void)handleStateChange:(BOOL)complete {
    GCD_ASYNC_MAIN(^{
        if (complete) {
            self.completeCount ++;
        } else {
            self.completeCount --;
        }
           
        [self setButtonEnableWhenStateChanged:(self.completeCount >= _completedFlag)];
    });
}

- (void)setButtonEnableWhenStateChanged:(BOOL)complete {
    _completeButton.userInteractionEnabled = complete;
    _completeButton.backgroundColor = complete? UIColor.fe_mainColor: [UIColor.fe_mainColor colorWithAlphaComponent:0.4];
}


@end
