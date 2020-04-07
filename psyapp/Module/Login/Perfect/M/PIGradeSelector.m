//
//  PIGradeSelector.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/12.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "PIGradeSelector.h"
#import "FEBottomPopUpView.h"
#import "PIClassSelectionView.h"
#import <QMUIKit.h>
@interface PIGradeSelector ()
@property (nonatomic, strong) FEBottomPopUpView *popupView;

@end

@implementation PIGradeSelector
@synthesize pi_selectedHandler = _pi_selectedHandler;
- (instancetype)init {
    self = [super init];
    PIClassSelectionView *selectionView = [PIClassSelectionView new];
    selectionView.frame = CGRectMake(0, 0, mScreenWidth, STWidth(380));
    @weakObj(self);
    selectionView.onSelected = ^(NSString *name) {
        selfweak.pi_selectedHandler(name);
        [selfweak.popupView hide];
    };
    
    _popupView = [FEBottomPopUpView new];
    _popupView.clickBackgroundToHideEnable = YES;
    _popupView.containerView = selectionView;
    return self;
}
- (void)pi_showSelector {
    [_popupView show];
}



@end
