//
//  FECommentInputView.m
//  smartapp
//
//  Created by mac on 2019/8/16.
//  Copyright © 2019 xueqooy. All rights reserved.
//

#import "FECommentInputView.h"
@interface FECommentInputView()<UIGestureRecognizerDelegate, UITextViewDelegate>

@property(nonatomic, strong) UIView *container;
@property(nonatomic, strong) UIButton *sendButton;
@property(nonatomic, strong) UITextView *contentTextView;
@property(nonatomic, strong) UILabel *placeholderLabel;
@property(nonatomic, strong) UIButton *clearButton;

@property(nonatomic, assign) CGFloat containerHeight;
@property(nonatomic, assign) BOOL initialNoHiding;//解决键盘弹起时就消失的问题
@end
#define MAX_HEIGHT 160.f
#define CLEAR_SHOW_HEIGHT 80.f
#define E 10.f //高度误差
@implementation FECommentInputView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(instancetype) init{
    
    if (self == [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(globalClick:)]];
        
        _containerHeight = [SizeTool height:52];
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.container];
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(_containerHeight);//当输入内容不足2行时高度为60
        }];
        
        CGFloat horMargin = [SizeTool width:15];
        CGFloat verMargin = [SizeTool width:10];
        _contentTextView= [[UITextView alloc] init];
        _contentTextView.layer.cornerRadius = 2;
        _contentTextView.backgroundColor = mHexColor(@"f0f2f5");
        _contentTextView.font = [UIFont systemFontOfSize:12];
        _contentTextView.delegate = self;
        _contentTextView.textContainerInset = UIEdgeInsetsMake(verMargin, verMargin, verMargin, verMargin);
        [_container addSubview:_contentTextView];
        [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-verMargin);
            make.left.offset(horMargin);
            make.width.mas_equalTo([SizeTool width:295.f]);
            make.top.offset(verMargin);
        }];
        [[UITextView appearance] setTintColor:mMainColor];
        
        _placeholderLabel = [UILabel createLabelWithDefaultText:@"写评论" numberOfLines:1 textColor:mHexColor(@"b0b5b9") font:mFont(14)];
        _placeholderLabel.userInteractionEnabled = NO;
        [_contentTextView addSubview:_placeholderLabel];
        [_placeholderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(horMargin + 2);
            make.centerY.equalTo(_contentTextView);
        }];
        
        
        _sendButton = [[UIButton alloc] init];
        _sendButton.layer.cornerRadius = 2;
        [_sendButton setTitle:@"提交" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = mFontBold(12);
        [_sendButton addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.tag = 2;
        [_container addSubview:_sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake([SizeTool width:40], [SizeTool height:32]));
            make.right.equalTo(_container).offset(-horMargin);
            make.bottom.mas_equalTo(-verMargin);
        }];
        [self setSendButtonEnabled:NO];

        UIView *clearButtonContainer = [UIView new];
        [_container addSubview:clearButtonContainer];
        [clearButtonContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentTextView.mas_right).offset(verMargin);
            make.bottom.mas_equalTo(- 2 * verMargin - [SizeTool height:32]);
            make.top.mas_equalTo(verMargin);
            make.right.mas_equalTo(-horMargin);
        }];
    
        
        _clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIImage *clearImg = [[UIImage imageNamed:@"share_clear"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_clearButton setImage:clearImg forState:UIControlStateNormal];
        _clearButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_clearButton addTarget:self action:@selector(clearContent) forControlEvents:UIControlEventTouchUpInside];
        _clearButton.hidden = YES;
        
        [clearButtonContainer addSubview:_clearButton];
        [_clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
}

- (void)setSendButtonEnabled:(BOOL)enabled {
    if (_sendButton) {
        _sendButton.enabled = enabled;
        if (enabled) {
            _sendButton.backgroundColor = mMainColor;
            [_sendButton setTitleColor:mHexColor(@"1b1c1d") forState:UIControlStateNormal];
            
        } else {
            [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _sendButton.backgroundColor = mHexColor(@"d7d9db");
        }
    }
}

-(void)setContent:(NSString *)content{
    if(!content || [content isEqualToString:@""]){
        return;
    }
    if(_contentTextView){
        _contentTextView.text = content;
        _placeholderLabel.text = @"";
        [self setSendButtonEnabled:YES];
        
        //刷新contentSize
        [_contentTextView layoutIfNeeded];
        
        CGFloat newHeight = [SizeTool height:20] + _contentTextView.contentSize.height;
        if (newHeight >= CLEAR_SHOW_HEIGHT) {
            _clearButton.hidden = NO;
        } else {
            _clearButton.hidden = YES;
        }
        if (newHeight > MAX_HEIGHT) {
            newHeight = MAX_HEIGHT;
        } else if (fabs(newHeight - _containerHeight) < E){
            return;
        }
        if (_containerHeight != newHeight) {
            _containerHeight = newHeight;
            [_container mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(newHeight);
            }];
        }
    }
}

- (void)buttonEvent:(UIButton *)sender {
    if(sender == self.sendButton){
        if([_contentTextView.text isEqualToString:@""]){
            [QSToast toast:_contentTextView message:@"输入内容不能为空"];
            return;
        }
        if(self.result){
            self.result(_contentTextView.text, YES);
        }
    }
    [self removeFromSuperview];
}

- (void)globalClick:(UIGestureRecognizer *)gr{
    CGPoint tapPoint = [gr locationInView:self];
    if (CGRectContainsPoint(self.container.frame, tapPoint)) {
        return;
    }
    [self endEditingIfNoSending];
}

- (void)clearContent {
    _contentTextView.text = @"";
    _placeholderLabel.text = _placeholder ? _placeholder : @"写评论";
    [self p_relayout];
    [self setSendButtonEnabled:NO];
}

- (void)endEditingIfNoSending {
    if(self.result){
        self.result(_contentTextView.text, NO);
    }
    [self removeFromSuperview];
}


//展示从底部向上弹出的UIView（包含遮罩）
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [_contentTextView becomeFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    // 获取键盘的高度
    NSDictionary *userInfo = aNotification.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = aValue.CGRectValue;
    [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-keyboardRect.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
    }];
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self p_relayout];
    if (textView.text.length == 0) {
        _placeholderLabel.text = _placeholder ? _placeholder : @"写评论";;
        [self setSendButtonEnabled:NO];
        
    }else{
        _placeholderLabel.text = @"";
        [self setSendButtonEnabled:YES];
    }
}

- (void)p_relayout{
    CGFloat newHeight = [SizeTool height:20] + _contentTextView.contentSize.height;
    if (newHeight >= CLEAR_SHOW_HEIGHT) {
        _clearButton.hidden = NO;
    } else {
        _clearButton.hidden = YES;
    }
    if (newHeight > MAX_HEIGHT) {
        newHeight = MAX_HEIGHT;
    } else if (fabs(newHeight - _containerHeight) < E){
        return;
    }

    
    if (_containerHeight != newHeight) {
        _containerHeight = newHeight;
        [UIView animateWithDuration:0.3 animations:^{
            [_container mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(newHeight);
            }];
            [self layoutIfNeeded];
        }];
    }
}

@end
