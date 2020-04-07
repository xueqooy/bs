//
//  UITextField+EventObsever.m
//  Pods-XQCategoryKit_Example
//
//  Created by xueqooy on 2019/6/19.
//

#import "UITextField+EventObsever.h"
#import <objc/runtime.h>
@interface UITextField ()
@property (nonatomic, assign) TextFieldEvent observeEvents;//保存添加的属性
@end
static void *eventsKey = &eventsKey;
@implementation UITextField (EventObsever)
-(void)setObserveEvents:(TextFieldEvent)observeEvents
{
    objc_setAssociatedObject(self, &eventsKey, @(observeEvents), OBJC_ASSOCIATION_ASSIGN);
}

-(TextFieldEvent)observeEvents
{
    NSNumber *eventsValue = objc_getAssociatedObject(self, &eventsKey);
    return eventsValue.integerValue;
}

- (void)registerObsever:(id)observer forEvents:(TextFieldEvent)events;
{
    
    
    if ((events & TextFieldEventEditingChanged) && !(self.observeEvents & TextFieldEventEditingChanged)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_eventEditingChanged) name:UITextFieldTextDidChangeNotification
                                                   object:self ];
    }
    if ((events & TextFieldEventEditingDidBegin) && !(self.observeEvents & TextFieldEventEditingDidBegin)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_eventEditingDidBegin) name:UITextFieldTextDidBeginEditingNotification
                                                   object:self ];
    }
    if ((events & TextFieldEventEditingDidEnd) && !(self.observeEvents & TextFieldEventEditingDidEnd)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_eventEditingDidEnd) name:UITextFieldTextDidEndEditingNotification
                                                   object:self ];
    }
    if ((events & TextFieldEventTextAssigned) && !(self.observeEvents & TextFieldEventTextAssigned)) {
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil ];
    }
    if ((events & TextFieldEventCursorMovement) && !(self.observeEvents & TextFieldEventCursorMovement)) {
        [self addObserver:self forKeyPath:@"selectedTextRange" options:NSKeyValueObservingOptionNew context:nil];
    }
    self.delegate = observer;
    
    self.observeEvents = events | self.observeEvents;
}
- (void)removeObserversforEvents:(TextFieldEvent)events
{
    if ((events & TextFieldEventEditingChanged) && (self.observeEvents & TextFieldEventEditingChanged)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UITextFieldTextDidChangeNotification
                                                      object:self];
    }
    if ((events & TextFieldEventEditingDidBegin) && (self.observeEvents & TextFieldEventEditingDidBegin)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UITextFieldTextDidBeginEditingNotification
                                                      object:self];
    }
    if ((events & TextFieldEventEditingDidEnd) && (self.observeEvents & TextFieldEventEditingDidEnd)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UITextFieldTextDidEndEditingNotification
                                                      object:self];
    }
    if ((events & TextFieldEventTextAssigned) && (self.observeEvents & TextFieldEventTextAssigned)) {
        [self removeObserver:self forKeyPath:@"text"];
    }
    if ((events & TextFieldEventCursorMovement) && (self.observeEvents & TextFieldEventCursorMovement)) {
        [self removeObserver:self forKeyPath:@"selectedTextRange"];
    }
    if (events == TextFieldEventAllEvents)
        self.delegate = nil;
    
    self.observeEvents = self.observeEvents & events;
}
- (void)_eventEditingChanged
{
    if ([self.delegate respondsToSelector:@selector(observeTextField:ForEvent:)]) {
       [ self _observeTextFieldForEvent:TextFieldEventEditingChanged];
    }
}
- (void)_eventEditingDidBegin
{
    if ([self.delegate respondsToSelector:@selector(observeTextField:ForEvent:)]) {
        [ self _observeTextFieldForEvent:TextFieldEventEditingDidBegin];
    }
}
- (void)_eventEditingDidEnd
{
    if ([self.delegate respondsToSelector:@selector(observeTextField:ForEvent:)]) {
        [ self _observeTextFieldForEvent:TextFieldEventEditingDidEnd];
    }
}
- (void)_eventTextAssigned
{
    if ([self.delegate respondsToSelector:@selector(observeTextField:ForEvent:)]) {
        [ self _observeTextFieldForEvent:TextFieldEventTextAssigned];
    }
}
- (void)_eventTextCursorMovement {
    if ([self.delegate respondsToSelector:@selector(observeTextField:ForEvent:)]) {
        [ self _observeTextFieldForEvent:TextFieldEventCursorMovement];
    }
}
- (void)_observeTextFieldForEvent:(TextFieldEvent)event
{
    if ([self.delegate isKindOfClass:[UIView class]]) {
        UIView *__weak view = (UIView *)self.delegate;
        [view observeTextField:self ForEvent:event];
    } else if ([self.delegate isKindOfClass:[UIViewController class]]) {
        UIViewController *__weak viewController = (UIViewController *)self.delegate;
        [viewController observeTextField:self ForEvent:event];
    }
}
#pragma mark - assgin observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        [self _eventTextAssigned];
    } else if ([keyPath isEqualToString: @"selectedTextRange"]) {
        [self _eventTextCursorMovement];
    }
    
}
@end
