//
//  FEEvaluationView.m
//  smartapp
//
//  Created by mac on 2019/10/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEEvaluationView.h"
#import "TCCommonButton.h"
#import <FLAnimatedImage.h>
#import <FLAnimatedImageView.h>

@interface FEEvaluationView () <UIGestureRecognizerDelegate, QMUITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *explainLabel;

@property (weak, nonatomic) IBOutlet TCCommonButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starButtons;
@property (weak, nonatomic) IBOutlet UIView *starsContainer;


@property (nonatomic, weak) FLAnimatedImageView *fiveStarAniIV;


@property (nonatomic, strong) UIImage *choosedStarImage;
@property (nonatomic, strong) UIImage *unchoosedStarImage;
@property (nonatomic, assign) NSInteger currentChoosedIndex;

//@property (nonatomic, copy) void(^confirmHandler)(NSInteger selectedIndex);
@end

@implementation FEEvaluationView {
    BOOL _visibleViewControllerInteractivePopDisabled;
}
@synthesize height = _height;
@synthesize margins = _margins;
@synthesize hideBlock = _hideBlock;

static FEEvaluationView *singleView;
+ (instancetype)loadFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
   
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    _explain = @"该测评结果与你对自己的认识结果相符吗？";
    _starDescriptions = @[@"非常不符合", @"不太符合", @"一般般", @"还不错", @"非常符合"];
    self.height = STWidth(135);
    self.margins = UIEdgeInsetsZero;
    return self;
}

- (void)setExplain:(NSString *)explain {
    _explain = explain;
    _explainLabel.text = explain;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    _container.backgroundColor = UIColor.fe_contentBackgroundColor;
    _explainLabel.textColor = UIColor.fe_titleTextColorLighten;
    _hintLabel.textColor = UIColor.fe_auxiliaryTextColor;
    _explainLabel.text = _explain;

    
    _choosedStarImage = [UIImage imageNamed:@"star_active_bigger"];
    _unchoosedStarImage = [UIImage imageNamed:@"star_inactive"];
    _currentChoosedIndex = -1;
    
    _confirmButton.userInteractionEnabled = NO;
    [_confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _confirmButton.backgroundColor = UIColor.fe_buttonBackgroundColorDisabled;
 
    _confirmButton.layer.cornerRadius = STWidth(4);
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [_starsContainer addGestureRecognizer:panGR];
}

- (void)panAction:(UIPanGestureRecognizer *)gr {
    CGPoint touchPoint = [gr locationInView:_starsContainer];
    NSInteger touchIdx = [self getIndexOfStarForLocation:touchPoint];
    
    [self updateStarFromIndex:_currentChoosedIndex toIndex:touchIdx];
    [self updateHintWithIndex:touchIdx];
    
    _currentChoosedIndex = touchIdx;
    if (touchIdx != -1) {
        [self updateConfirmButtonEnabled];
    }
}

- (void)updateConfirmButtonEnabled {
    //_textView.text.qmui_trim.length > 0 &&
    if ( _currentChoosedIndex != -1) {
        _confirmButton.userInteractionEnabled = YES;
        _confirmButton.backgroundColor = UIColor.fe_mainColor;
    } else {
        _confirmButton.userInteractionEnabled = NO;
        _confirmButton.backgroundColor = UIColor.fe_buttonBackgroundColorDisabled;
    }
}

- (NSInteger)getIndexOfStarForLocation:(CGPoint)loc {
    __block NSInteger foundIdx = _currentChoosedIndex;
    [_starButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *star = obj;
        if (CGRectContainsPoint(star.frame, loc)) {
            foundIdx = idx;
            *stop = YES;
        }
    }];
    return foundIdx;
}

- (IBAction)confirmAction:(UIButton *)sender {
    if (_confirmBlock) {
        _confirmBlock(_currentChoosedIndex);
        if (self.hideBlock) self.hideBlock();
    }
}

- (IBAction)chooseStarAction:(UIButton *)sender {
    NSInteger idx = [_starButtons indexOfObject:sender];
   
    [self updateStarFromIndex:_currentChoosedIndex toIndex:idx];
    [self updateHintWithIndex:idx];
    
    _currentChoosedIndex = [_starButtons indexOfObject:sender];
    
    [self updateConfirmButtonEnabled];

}

- (void)updateStarFromIndex:(NSInteger)fromIdx toIndex:(NSInteger)toIdx {
    if (toIdx == fromIdx) {return;}
    
    if (toIdx > fromIdx) {
        [self addStarsToIndex:toIdx];
    } else {
        [self reduceStarsFromIndex:fromIdx toIndex:toIdx];
    }
}

- (void)addStarsToIndex:(NSInteger)toIdx  {
    NSInteger tmp = toIdx;
    
    CAKeyframeAnimation *scaleAni = [CAKeyframeAnimation animation];
    scaleAni.duration = 0.1;
    scaleAni.keyPath = @"transform.scale";
    scaleAni.values = @[@0.85, @0.9, @0.95, @1, @1.05, @1.1, @1.05, @1];
    int delay = 0;
    for (; tmp > -1; tmp --) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * 60 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
              UIButton *button = [self getButtonWithIndex:tmp];
              [button setImage:_choosedStarImage forState:UIControlStateNormal];
              [button.layer addAnimation:scaleAni forKey:nil];
        });
        delay += 1;
    }
   
}

- (void)reduceStarsFromIndex:(NSInteger)fromIdx toIndex:(NSInteger)toIdx  {
    NSInteger tmp = fromIdx;
    
    CAKeyframeAnimation *scaleAni = [CAKeyframeAnimation animation];
    scaleAni.duration = 0.1;
    scaleAni.keyPath = @"transform.scale";
    scaleAni.values = @[@0.85, @0.9, @0.95, @1, @1.05, @1.1, @1.05, @1];
    int delay = 0;
    for (;tmp > toIdx; tmp --) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * 30 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            UIButton *button = [self getButtonWithIndex:tmp];
            [button setImage:_unchoosedStarImage forState:UIControlStateNormal];
            [button.layer addAnimation:scaleAni forKey:nil];
        });
        delay += 1;
    }
}




- (UIButton *)getButtonWithIndex:(NSInteger)idx {
    if (idx < 0 || idx > 4) {return nil;}
    UIButton *btn = [_starButtons objectAtIndex:idx];
    return btn;
}

- (void)updateHintWithIndex:(NSInteger)idx {
    if (idx < 0 || idx >= _starDescriptions.count) return;
    
    _hintLabel.textColor = UIColor.fe_textColorHighlighted;
    _hintLabel.font = STFont(16);
    NSString *hintText = _starDescriptions[idx];
    
    _hintLabel.text = hintText;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.container]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateConfirmButtonEnabled];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIViewController *visibleVC = QMUIHelper.visibleViewController;
    _visibleViewControllerInteractivePopDisabled = visibleVC.fd_interactivePopDisabled;
    if (visibleVC) {
        visibleVC.fd_interactivePopDisabled = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    QMUIHelper.visibleViewController.fd_interactivePopDisabled = _visibleViewControllerInteractivePopDisabled;
}
@end
