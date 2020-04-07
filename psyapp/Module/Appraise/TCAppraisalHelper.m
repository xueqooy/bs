//
//  TCAppraisalHelper.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/10.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCAppraisalHelper.h"
#import "TCPopupContainerView.h"
#import "FEEvaluationView.h"
@interface TCAppraisalHelper ()
@property (nonatomic, strong) TCPopupContainerView *popupView;
@property (nonatomic, strong) FEEvaluationView *appraisalView;
@end
@implementation TCAppraisalHelper

- (instancetype)initWithUniqueId:(NSString *)uniqueId type:(FEAppraisalType)type {
    self = [super init];
    _type = type;
 
    self.appraisalManager = [[FEAppraisalManager alloc] initWithUniqueId:uniqueId type:type];
    return self;
}

- (void)showAppraisalViewIfNotAppraisedWithCompletion:(void (^)(BOOL))completion {
    @weakObj(self);
    [self.appraisalManager loadAppraisalItemsDataOnSuccess:^{
        if (selfweak.appraisalManager.hasAppraised == NO) {
            FEEvaluationView *displayedView = FEEvaluationView.loadFromNib;
            
            selfweak.appraisalView = displayedView;
            selfweak.appraisalView.confirmBlock = selfweak.confirmBlock;
            selfweak.popupView = TCPopupContainerView.new;
            selfweak.popupView.limitedMaxHeight = mScreenHeight;
            selfweak.popupView.prefersHideButtonHidden = YES;
            selfweak.popupView.title =  @"测评评价";
            selfweak.popupView.displayedView = selfweak.appraisalView;
            [selfweak.popupView showToVisibleControllerViewWithCompletion:^{
            }];
            if (completion) completion(YES);
            return ;
        }
        if (completion) completion(NO);
    } onFailure:^{
        if (completion) completion(NO);
    }];
    
}

- (TCConfirmBlock)confirmBlock {
    @weakObj(self);
    return ^(NSInteger level) {
        [selfweak.appraisalManager commitAppraisalAtIndex:level onComplete:^{
            if (selfweak.appraiseSuccessBlock) selfweak.appraiseSuccessBlock();
        
        }];
    };
}
@end
