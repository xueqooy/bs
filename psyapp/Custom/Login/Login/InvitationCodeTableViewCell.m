//
//  InvitationCodeTableViewCell.m
//  smartapp
//
//  Created by mac on 2019/7/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "InvitationCodeTableViewCell.h"
#import "DeleteResponseTextField.h"
#import "UITextField+ExtentRange.h"

@interface InvitationCodeTableViewCell () <UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *codeViews;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, assign) NSInteger codeLength;
@property (nonatomic, assign) NSInteger inputIndex;

@end

static NSInteger const kTextFieldTag = 2019;
static NSInteger const kBlockViewTag = 2020;

@implementation InvitationCodeTableViewCell

- (void)setResultText:(NSString *)text {
    _resultLabel.text = text;
}

- (void)clearContent {
//    for (UIView *view in _codeViews) {
//        
//        UITextField *textField = [view viewWithTag:kTextFieldTag];
//        textField.text = @"";
//    }
//    _inputIndex = 0;
//    
}

- (void)setFirstResponder:(BOOL)fr {
    UIView *lastView = _codeViews[_codeLength - 1];
    UITextView *sigleCodeTextField = [lastView viewWithTag:kTextFieldTag];
    if (!fr) {
        [sigleCodeTextField resignFirstResponder];
    } else {
        [sigleCodeTextField becomeFirstResponder];
    }
}

- (void)setUpSubviews {
    _codeLength = 8;
    _codeViews = @[].mutableCopy;
    _inputIndex = 0;
    for (int i = 0; i < _codeLength; i++) {
        UIView *aView = [self addCodeViewAtIndex:i];
        [_codeViews addObject:aView];
    }
    
    _resultLabel = [UILabel new];
    _resultLabel.font = STFont(14);
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    _resultLabel.textColor = mHexColor(@"306DFE");
    _resultLabel.text = @"";
    [self.contentView addSubview:_resultLabel];
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
    
}

- (UIView *)addCodeViewAtIndex:(NSInteger)i {
    UIView *blockView = [UIView new];
    blockView.tag = kBlockViewTag;
   
    if (i == 0) {
        blockView.backgroundColor = mHexColor(@"fff8de");
        blockView.layer.borderWidth = 0.5;
        blockView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:214/255.0 blue:48/255.0 alpha:1.0].CGColor;
    } else {
        blockView.backgroundColor = mHexColor(@"f0f2f5");
        blockView.layer.cornerRadius = STWidth(2);
    }
    DeleteResponseTextField *codeTextField = [DeleteResponseTextField new];
    codeTextField.font = STFontBold(18);
    codeTextField.textColor = mHexColor(@"1b1c1d");
    codeTextField.textAlignment = NSTextAlignmentCenter;
    [codeTextField registerObsever:self forEvents:TextFieldEventEditingChanged + TextFieldEventCursorMovement + TextFieldEventEditingDidBegin];
    codeTextField.tag = kTextFieldTag;
    codeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    __weak typeof (codeTextField) weakTextField = codeTextField;
    codeTextField.deletedHandler = ^(NSString * _Nonnull text) {
        [self deletedForTextField:weakTextField];
    };
    
    [self.contentView addSubview:blockView];
    [blockView addSubview:codeTextField];
    
    CGFloat spacing = STWidth(5);
    CGFloat offset = STWidth(17);
    CGFloat width = (mScreenWidth - offset * 2 - (self->_codeLength - 1) * spacing)/self->_codeLength;
    
    [blockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.bottom.equalTo(self.contentView).offset(-STWidth(26));
        make.left.equalTo(self.contentView).mas_offset(offset + i * (spacing + width));
    }];
    
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(blockView);
        make.width.height.mas_equalTo(width);
    }];
    
    return blockView;
}

static inline
NSString * removeSpaceAndNewline(NSString * str){
    
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

- (void)observeTextField:(DeleteResponseTextField *)textField ForEvent:(TextFieldEvent)event {
    if (event == TextFieldEventEditingChanged) {
         //粘贴判断
        if (textField.text.length > 1) {
            NSString *autoFillCode = removeSpaceAndNewline(textField.text);
            [autoFillCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (autoFillCode.length >= 8) {
                autoFillCode = [autoFillCode substringToIndex:8]; //截取8位
                [_codeViews enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UITextField *textField = [obj viewWithTag:kTextFieldTag];
                    textField.text  = [autoFillCode substringWithRange:NSMakeRange(idx, 1)];
                    
                    UIView *blView = [obj viewWithTag:kBlockViewTag];
                    blView.backgroundColor = mHexColor(@"fff8de");
                    blView.layer.borderWidth = 0.5;
                    blView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:214/255.0 blue:48/255.0 alpha:1.0].CGColor;
                    if (idx == 7) {
                        [textField becomeFirstResponder];
                        _inputIndex = idx;
                        
                        if (_textChangedHandler) {
                            NSString *code = [self getInvitationCode];
                            _textChangedHandler( YES, code);
                        }
                    }
                }];
            } else {
                [_codeViews enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIView *blView = [obj viewWithTag:kBlockViewTag];
                    blView.backgroundColor = mHexColor(@"f0f2f5");
                    blView.layer.borderWidth = 0;
                }];
                for (int idx = 0; idx < autoFillCode.length; idx++) {
                    UITextField *textField = [_codeViews[idx] viewWithTag:kTextFieldTag];
                    textField.text = [autoFillCode substringWithRange:NSMakeRange(idx, 1)];
                    
                    UIView *blView = [_codeViews[idx] viewWithTag:kBlockViewTag];
                    blView.backgroundColor = mHexColor(@"fff8de");
                    blView.layer.borderWidth = 0.5;
                    blView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:214/255.0 blue:48/255.0 alpha:1.0].CGColor;
                    
                    if (idx == autoFillCode.length - 1) {
                        UITextField *nextTF = [_codeViews[idx + 1] viewWithTag:kTextFieldTag];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [nextTF becomeFirstResponder];
                        });
                                       
                        UIView *nextBL = [_codeViews[idx + 1] viewWithTag:kBlockViewTag];
                        nextBL.backgroundColor = mHexColor(@"fff8de");
                        nextBL.layer.borderWidth = 0.5;
                        nextBL.layer.borderColor = [UIColor colorWithRed:255/255.0 green:214/255.0 blue:48/255.0 alpha:1.0].CGColor;
                        _inputIndex = idx + 1;
                    }
                }
            }
            return;
        }
        
        
        UIView *superView = [textField superview];
        NSInteger index = [_codeViews indexOfObject:superView];
        if (textField.text.length == 1) {
            if (index != _codeLength - 1) {
                //使下一个textfield成为焦点
                NSInteger nextIndex = index + 1;
                UIView *nextView = _codeViews[nextIndex];
                DeleteResponseTextField *nextCodeTF = [nextView viewWithTag:kTextFieldTag];
                _inputIndex = nextIndex;//标记光标位置
                [nextCodeTF becomeFirstResponder];
               
                //底部线条颜色转换
                UIView *nextBV = [nextView viewWithTag:kBlockViewTag];
                nextBV.backgroundColor = mHexColor(@"fff8de");
                nextBV.layer.borderWidth = 0.5;
                nextBV.layer.borderColor = [UIColor colorWithRed:255/255.0 green:214/255.0 blue:48/255.0 alpha:1.0].CGColor;
            } else {//输入完毕，回调
                if (_textChangedHandler) {
                    NSString *code = [self getInvitationCode];
                    _textChangedHandler( YES, code);
                }
            }
        }
        
       
    } else if (event == TextFieldEventCursorMovement) {//光标不可移动
        if ([textField selectedRange].location == 0 && textField.text.length != 0) {
            [textField setSelectedRange:NSMakeRange(1, 0)];
        }
    } else if (event == TextFieldEventEditingDidBegin) {
        UIView *superView = [textField superview];
        NSInteger index = [_codeViews indexOfObject:superView];
        if (index > _inputIndex) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIView *view = [_codeViews objectAtIndex:_inputIndex];
                UITextField *_textField = [view viewWithTag:kTextFieldTag];
                [_textField becomeFirstResponder];
            });
        }
    }
}

- (NSString *)getInvitationCode {
    NSMutableString *code = @"".mutableCopy;
    for (UIView *aView in _codeViews) {
        UITextView *sigleCodeTextField = [aView viewWithTag:kTextFieldTag];
        [code appendString:sigleCodeTextField.text];
    }
    return code;
}

- (UITextField *)getLastTextFieldForIndex:(NSInteger)idx {
    if (idx == 0) return nil;
    UITextField *lastTF = [_codeViews[idx - 1] viewWithTag:kTextFieldTag];
    return lastTF;
}

- (UITextField *)getNextTextFieldForIndex:(NSInteger)idx {
    if (idx == _codeLength - 1) return nil;
    UITextField *lastTF = [_codeViews[idx + 1] viewWithTag:kTextFieldTag];
    return lastTF;
}

- (NSString *)getNextCodeForIndex:(NSInteger)idx {
    if (idx + 1 == _codeLength) return nil;
    UITextField *nextTF = [_codeViews[idx + 1] viewWithTag:kTextFieldTag];
    return nextTF.text;
}

- (BOOL)hasInputedForIndx:(NSInteger)idx {
    UITextField *textField = [_codeViews[idx] viewWithTag:kTextFieldTag];
    if (textField.text.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setTextFieldForIndex:(NSInteger)idx withText:(NSString *)text{
    UITextField *textField = [_codeViews[idx] viewWithTag:kTextFieldTag];
    
    if (text.length == 0 || text == nil) {
        textField.text = @"";
    } else {
        textField.text = text;
    }
}

- (BOOL)isNumberOrLetterForString:(NSString *) string {
    NSString * regex = @"^[A-Za-z0-9]+$";

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    BOOL isMatch = [pred evaluateWithObject:string];
  
    return isMatch;
}

- (void)deletedForTextField:(UITextField *)textField {
    UIView *superView = [textField superview];
    NSInteger index = [_codeViews indexOfObject:superView];
    
    NSString *nextCode = [self getNextCodeForIndex:index];
    if (index < _inputIndex) {   //光标不在输入位时的删除逻辑
        for (NSInteger idx = index + 1; idx < _codeLength; idx ++) {
            NSString *nextCode = [self getNextCodeForIndex:idx];
            [self setTextFieldForIndex:idx withText:nextCode];
        }
        UIView *blView = [_codeViews[_inputIndex] viewWithTag:kBlockViewTag];
          blView.backgroundColor = mHexColor(@"f0f2f5");
          blView.layer.borderWidth = 0;
        
        _inputIndex --;
        
        UITextField *lastTF = [self getLastTextFieldForIndex:index];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTextFieldForIndex:index withText:nextCode];
            
            [lastTF becomeFirstResponder];
        });
       
        return;
    }
    
    
    if (index != 0) {
        if (index == _codeLength - 1) { //最后一个验证码
            if (_textChangedHandler) {
                _textChangedHandler(NO, textField.text);
            }
            if (textField.text.length != 0) {
                return;
            }
        }
        //使下一个textfield成为焦点,并清空内容
        NSInteger nextIndex = index - 1;
        UIView *nextView = _codeViews[nextIndex];
        DeleteResponseTextField *nextCodeTF = [nextView viewWithTag:kTextFieldTag];
        nextCodeTF.text = @"";
        _inputIndex = nextIndex;//标记光标位置
        [nextCodeTF becomeFirstResponder];
        //底部线条颜色转换
        UIView *curBV = [superView viewWithTag:kBlockViewTag];
        curBV.backgroundColor = mHexColor(@"f0f2f5");
        curBV.layer.borderWidth = 0;
       // curBV.layer.borderColor = [UIColor colorWithRed:255/255.0 green:214/255.0 blue:48/255.0 alpha:1.0].CGColor;
    }
}

 //不可输入空格 当前光标已经有输入不可输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "] || ![self isNumberOrLetterForString:string]) {
        if ([string isEqualToString:@""]) {
            return  YES;
        }
        return NO;
    }
    //光标不在输入位时的输入逻辑
    UIView *superView = [textField superview];
     NSInteger index = [_codeViews indexOfObject:superView];
     
     NSString *lastCode;
    UITextField *endTF = [_codeViews[_codeLength - 1] viewWithTag:kTextFieldTag];
    BOOL hasInputCompleted = endTF.text.length == 0? NO: YES;
     if (string.length == 1 && textField.text.length == 1 && index < _inputIndex && !hasInputCompleted) {
         for (NSInteger idx = index + 1; idx < _codeLength; idx ++) {
             if (idx == index + 1) {
                 lastCode = [self getNextCodeForIndex:idx - 1];
                 [self setTextFieldForIndex:idx withText:string];
             } else {
                 UITextField *tf = [_codeViews[idx] viewWithTag:kTextFieldTag];
                 NSString *tempText = tf.text;
                 [self setTextFieldForIndex:idx withText:lastCode];
                 if (idx == _codeLength - 1) {
                     if ([self hasInputedForIndx:idx]) {
                         if (_textChangedHandler) {
                                           NSString *code = [self getInvitationCode];
                                           _textChangedHandler( YES, code);
                                       }
                     }
                 }
                 lastCode = tempText;
             }
         }
         
         _inputIndex ++;
      
         UIView *nextBV = [_codeViews[_inputIndex] viewWithTag:kBlockViewTag];
         if (nextBV) {
             nextBV.backgroundColor = mHexColor(@"fff8de");
                  nextBV.layer.borderWidth = 0.5;
                  nextBV.layer.borderColor = [UIColor colorWithRed:255/255.0 green:214/255.0 blue:48/255.0 alpha:1.0].CGColor;
         }
     
        
         UITextField *nextTF = [self getNextTextFieldForIndex:index];
         if (nextTF) {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 
                 [nextTF becomeFirstResponder];
             });
         }
     }
    
   if (textField.text.length != 0 && ![string isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}
@end
