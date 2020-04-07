//
//  VerifyCodeTableViewCell.m
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/17.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "VerifyCodeTableViewCell.h"
#import "DeleteResponseTextField.h"
#import "UITextField+ExtentRange.h"
#import "FastClickUtils.h"

@interface VerifyCodeTableViewCell () <UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *codeViews;
@property (nonatomic, strong) UIButton *retransmissionBtn;
@property (nonatomic, assign) NSInteger codeLength;
@property (nonatomic, assign) NSInteger inputIndex;

@property (nonatomic, strong) NSMutableIndexSet *uninputIndexs;

@end

static NSInteger const kTextFieldTag = 2019;
static NSInteger const kBottomLineTag = 2020;
static const NSTimeInterval  kDefualtRetransmissionTimeInterval = 63;
@implementation VerifyCodeTableViewCell

- (void)setUpSubviews {
    _codeLength = 6;
    _codeViews = @[].mutableCopy;
    _inputIndex = 0;
    for (int i = 0; i < 6; i++) {
        UIView *aView = [self addCodeViewAtIndex:i];
        [_codeViews addObject:aView];
    }
    
    _retransmissionBtn = [UIButton new];
    [_retransmissionBtn setTitle:[NSString stringWithFormat:@"%fs后重试", kDefualtRetransmissionTimeInterval] forState:UIControlStateNormal];
    _retransmissionBtn.titleLabel.font = STFont(12);
    [_retransmissionBtn setTitleColor:UIColor.fe_placeholderColor forState:UIControlStateNormal];
    _retransmissionBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_retransmissionBtn];
    _retransmissionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_retransmissionBtn addTarget:self action:@selector(retransmissionAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_retransmissionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(STWidth(19));
        //make.top.equalTo(self.contentView).offset(STWidth(75));
        make.size.mas_equalTo(STSize(65, 13));
        make.bottom.mas_equalTo(0);
    }];
    
    
//    UIView *testView = [UIView new];
//    testView.frame = CGRectMake(200, 10, 50, 50);
//    testView.backgroundColor = UIColor.fe_mainColor;
//    [self addSubview:testView];
//    [testView addTapGestureWithBlock:^{
//        UITextField *textField = [_codeViews[0] viewWithTag:kTextFieldTag];
//        textField.text = @"123456";
//        [textField didChangeValueForKey:@"text"];
//    }];
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

- (void)startCountDown {
    [self setRetransmissionCountDown:_retransmissionTimeInterval? _retransmissionTimeInterval:kDefualtRetransmissionTimeInterval];
}


- (void)setRetransmissionCountDown:(NSInteger)time {//重发倒计时
    self.retransmissionBtn.userInteractionEnabled = NO;
    _retransmissionBtn.titleLabel.font = STFont(12);
    [_retransmissionBtn setTitleColor:UIColor.fe_placeholderColor forState:UIControlStateNormal];
    
    __block NSInteger rest = time;
    __weak typeof (self) weakSelf = self;
    dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timerSource, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timerSource, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (rest == 0) {
                weakSelf.retransmissionBtn.userInteractionEnabled = YES;
                [weakSelf.retransmissionBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                weakSelf.retransmissionBtn.titleLabel.font = STFont(11);
                [weakSelf.retransmissionBtn setTitleColor:UIColor.fe_titleTextColor forState:UIControlStateNormal];
                dispatch_cancel(timerSource);
            } else {
                weakSelf.retransmissionBtn.userInteractionEnabled = NO;
                [weakSelf.retransmissionBtn setTitle:[NSString stringWithFormat:@"%lds后重试",rest] forState:UIControlStateNormal];
                 rest--;
            }
        });
    });
    dispatch_resume(timerSource);
    
}

- (void)retransmissionAction {//重发按钮点击行为
    if ([FastClickUtils isFastClick]) return;
    [self setRetransmissionCountDown:_retransmissionTimeInterval? _retransmissionTimeInterval:kDefualtRetransmissionTimeInterval];
    if (_retransmissionHandler) {
        _retransmissionHandler();
    }
    //重置textfield
    _inputIndex = 0;
    int i = 0;
    for (UIView *aView in _codeViews) {
        UITextField *textField = [aView viewWithTag:kTextFieldTag];
        UIView *bottomLine = [aView viewWithTag:kBottomLineTag];
        textField.text = @"";
        if (i != 0) {
            bottomLine.backgroundColor = UIColor.fe_separatorColor;
        }
        if (i == 0) {
            [textField becomeFirstResponder];
        }
        i++;
    }
    
    
}

- (UIView *)addCodeViewAtIndex:(NSInteger)i {
    UIView *containerView = [UIView new];
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = i? UIColor.fe_separatorColor :UIColor.fe_mainColor;
    bottomLine.tag = kBottomLineTag;

    DeleteResponseTextField *codeTextField = [DeleteResponseTextField new];
    if (@available(iOS 12.0, *)) {
        //codeTextField.textContentType = UITextContentTypeOneTimeCode;
    }
    
    codeTextField.font = STFontBold(18);
    codeTextField.textColor = UIColor.fe_titleTextColor;
    codeTextField.textAlignment = NSTextAlignmentCenter;
    [codeTextField registerObsever:self forEvents:TextFieldEventEditingChanged + TextFieldEventCursorMovement + TextFieldEventEditingDidBegin];
    codeTextField.tag = kTextFieldTag;
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    __weak typeof (codeTextField) weakTextField = codeTextField;
    __weak typeof (self) weakself = self;
    codeTextField.deletedHandler = ^(NSString * _Nonnull text) {
        [weakself deletedForTextField:weakTextField];
    };
    
    [self.contentView addSubview:containerView];
    [containerView addSubview:bottomLine];
    [containerView addSubview:codeTextField];
    
    CGFloat spacing = STWidth(5);
    CGFloat offset = STWidth(25);
    CGFloat width = (mScreenWidth - offset * 2 - (self->_codeLength - 1) * spacing)/self->_codeLength;
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, STWidth(50)));
        make.bottom.mas_equalTo(-STWidth(34));
        make.left.equalTo(self.contentView).mas_offset(offset + i * (spacing + width));
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(containerView);
        make.width.equalTo(containerView);
        make.height.mas_equalTo(0.5);
    }];
    
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(containerView).offset(-0.5);
        make.left.equalTo(containerView);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(STWidth(40));
    }];
    
    return containerView;
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
        //做验证码自动填入或粘贴判断
        if (textField.text.length > 1) {

            NSString *autoFillCode = removeSpaceAndNewline(textField.text);
            if (autoFillCode.length >= 6) {
                autoFillCode = [autoFillCode substringToIndex:6]; //截取6位
                for (int i = 0; i < _codeViews.count; i++) {
                    UITextField *textField = [_codeViews[i] viewWithTag:kTextFieldTag];
                    NSString *code = [autoFillCode substringWithRange:NSMakeRange(i, 1)];
                    textField.text  = code;
                    
                    UIView *blView = [_codeViews[i] viewWithTag:kBottomLineTag];
                    blView.backgroundColor =  UIColor.fe_mainColor;
                    if (i == _codeViews.count - 1) {
                        [textField becomeFirstResponder];
                        self.inputIndex = i;
                        
                        if (self.completionHandler) {
                            NSString *code = autoFillCode;//[self getVerifyCode]; 有时会出现填充验证码最后一位错误的情况，不再通过遍历获取Text
                            self.completionHandler(YES ,code);
                        }
                    }
                }
            } else {
                [_codeViews enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIView *blView = [obj viewWithTag:kBottomLineTag];
                    blView.backgroundColor =  UIColor.fe_separatorColor;
                }];
                for (int idx = 0; idx < autoFillCode.length; idx++) {
                    UITextField *textField = [_codeViews[idx] viewWithTag:kTextFieldTag];
                    textField.text = [autoFillCode substringWithRange:NSMakeRange(idx, 1)];
                    
                    UIView *blView = [_codeViews[idx] viewWithTag:kBottomLineTag];
                    blView.backgroundColor = UIColor.fe_mainColor;
                    
                    if (idx == autoFillCode.length - 1) {
                        UITextField *nextTF = [_codeViews[idx + 1] viewWithTag:kTextFieldTag];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [nextTF becomeFirstResponder];
                        });
                         UIView *nextBL = [_codeViews[idx + 1] viewWithTag:kBottomLineTag];
                        nextBL.backgroundColor = UIColor.fe_mainColor;
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
                if (index < _inputIndex) {
                    UIView *nextView = _codeViews[_inputIndex];
                    DeleteResponseTextField *nextCodeTF = [nextView viewWithTag:kTextFieldTag];
                    [nextCodeTF becomeFirstResponder];
                    if ([self getVerifyCode].length == 6) {
                        if (_completionHandler) {
                            NSString *code = [self getVerifyCode];
                            _completionHandler(YES ,code);
                        }
                    }
                    return;
                }
                //使下一个textfield成为焦点
                NSInteger nextIndex = index + 1;
                UIView *nextView = _codeViews[nextIndex];
                DeleteResponseTextField *nextCodeTF = [nextView viewWithTag:kTextFieldTag];
                _inputIndex = nextIndex;//标记光标位置
                [nextCodeTF becomeFirstResponder];
                //底部线条颜色转换
                UIView *nextBL = [nextView viewWithTag:kBottomLineTag];
                nextBL.backgroundColor = UIColor.fe_mainColor;
            } else {//输入完毕，回调
                if (_uninputIndexs.count > 0) {
                    return;
                }
                if (_completionHandler) {
                    NSString *code = [self getVerifyCode];
                    _completionHandler(YES ,code);
                }
            }
        }
    
    } else if (event == TextFieldEventCursorMovement) {//光标不可移动
        if ([textField selectedRange].location == 0 && textField.text.length != 0) {
            [textField setSelectedRange:NSMakeRange(1, 0)];
        }
    } else if (event == TextFieldEventEditingDidBegin) {//光标只能在当前要输入的位置上
        //立即使用becomeFirstResponder使另外一个textField获得焦点，不能够弹出键盘。延迟调用becomeFirstResponder，可以弹出键盘
        
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

- (NSString *)getVerifyCode {
    NSMutableString *code = @"".mutableCopy;
    for (int i = 0; i < _codeViews.count; i++) {
        UITextView *sigleCodeTextField = [_codeViews[i] viewWithTag:kTextFieldTag];
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

- (void)setTextFieldForIndex:(NSInteger)idx withText:(NSString *)text{
    UITextField *textField = [_codeViews[idx] viewWithTag:kTextFieldTag];
    
    if (text.length == 0 || text == nil) {
        textField.text = @"";
    } else {
        textField.text = text;
    }
}

- (BOOL)hasInputedForIndx:(NSInteger)idx {
    UITextField *textField = [_codeViews[idx] viewWithTag:kTextFieldTag];
    if (textField.text.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)deletedForTextField:(UITextField *)textField {
    UIView *superView = [textField superview];
    NSInteger index = [_codeViews indexOfObject:superView];
    
    NSString *nextCode = [self getNextCodeForIndex:index];
   if (index < _inputIndex) {   //光标不在输入位时的删除逻辑
//       for (NSInteger idx = index + 1; idx < _codeLength; idx ++) {
//           NSString *nextCode = [self getNextCodeForIndex:idx];
//           [self setTextFieldForIndex:idx withText:nextCode];
//       }
//       UIView *blView = [_codeViews[_inputIndex] viewWithTag:kBottomLineTag];
//        blView.backgroundColor =  mHexColor(@"e8e8e8");
//
//       _inputIndex --;
//
//       UITextField *lastTF = [self getLastTextFieldForIndex:index];
//       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//           [self setTextFieldForIndex:index withText:nextCode];
//
//           [lastTF becomeFirstResponder];
//       });
       if (_uninputIndexs == nil) {
           _uninputIndexs = [NSMutableIndexSet indexSet];
       }
       [_uninputIndexs addIndex:index];//添加未输入的单元索引
       return;
   }
    
    
    if (index != 0) {
        if (index == _codeLength - 1) { //最后一个验证码
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
        UIView *curBL = [superView viewWithTag:kBottomLineTag];
        curBL.backgroundColor = UIColor.fe_separatorColor;
    }
    NSString *unfillCode = [self getVerifyCode];
    if (_completionHandler) {
        _completionHandler(NO, unfillCode);
    }
}

// 限制只能输入数字 以及当前光标已经有输入不可输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "] || ![string isNumber]) {
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

       if ([_uninputIndexs containsIndex:index]) {  //从未输入单元的索引的集合中删除
           NSLog(@"%@",_uninputIndexs);
            [_uninputIndexs removeIndex:index];
           if (_uninputIndexs.count > 0) {
               hasInputCompleted = NO;
           }
       }
   
       
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
                                           if (_completionHandler) {
                                                              NSString *code = [self getVerifyCode];
                                                              _completionHandler(YES ,code);
                                                          }
                                                         
                                        }
                                    }
                    lastCode = tempText;
                }
            }
            
          //  _inputIndex ++;
         
            UIView *nextBV = [_codeViews[_inputIndex] viewWithTag:kBottomLineTag];
            if (nextBV) {
                nextBV.backgroundColor = UIColor.fe_mainColor;
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
    return [string isNumber];
}
@end
