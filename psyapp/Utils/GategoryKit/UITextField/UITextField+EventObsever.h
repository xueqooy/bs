//
//  UITextField+EventObsever.h
//  Pods-XQCategoryKit_Example
//
//  Created by xueqooy on 2019/6/19.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, TextFieldEvent) {
    TextFieldEventEditingChanged = 1 << 0,
    TextFieldEventEditingDidBegin = 1 << 1,
    TextFieldEventEditingDidEnd = 1 << 2,
    TextFieldEventTextAssigned = 1 << 3,
    TextFieldEventCursorMovement = 1 << 4,
    TextFieldEventAllEvents  = 0b11111
};



NS_ASSUME_NONNULL_BEGIN


@interface UIView (TextFieldEvent)
/**
 *  TextFieldEvent Provide interfaces for ‘UIView’
 *  @param textField 'UITextField' under observation
 *  @param event     an event observed
 */
- (void)observeTextField:(UITextField *)textField ForEvent:(TextFieldEvent)event;
@end
@interface UIViewController (TextFieldEvent)
/**
 *  TextFieldEvent Provide interfaces for ‘UIViewController’
 *  @param textField  'UITextField' under observation
 *  @param event      an event observed
 */
- (void)observeTextField:(UITextField *)textField ForEvent:(TextFieldEvent)event;
@end

@interface UITextField (EventObsever)
/**
 *  Register observers of Textfield events
 *  @param observer  Pass an object that responds to the method (observeTextField: ForEvent:)
 *  @param events    Events to be observed，By enumeration
 */
- (void)registerObsever:(id)observer forEvents:(TextFieldEvent)events;
/**
 *  Remove observers of certain events
 *  @param events    Events to remove observers
 */
- (void)removeObserversforEvents:(TextFieldEvent)events;

@end
NS_ASSUME_NONNULL_END
