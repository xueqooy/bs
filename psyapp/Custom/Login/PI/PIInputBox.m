//
//  PIInputBox.m
//  smartapp
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PIInputBox.h"
@interface PIInputBox () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation PIInputBox {
    BOOL _inputed;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    _categoryLabel.textColor = UIColor.fe_titleTextColorLighten;
    _bottomLine.backgroundColor = UIColor.fe_separatorColor;
    _inputTextField.textColor = UIColor.fe_titleTextColorLighten;
    [_inputTextField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)textDidChange {
    if (_inputTextField.text.length > 0) {
        if (self.stateHandler) {
            if (_inputed == NO) {
                _inputed = YES;
                self.stateHandler(_inputed);
            }
        }
    } else {
        if (self.stateHandler) {
            if (_inputed == YES) {
                _inputed = NO;
                self.stateHandler(_inputed);
            }
        }
    }
}

- (void)setCategory:(NSString *)category placeholder:(NSString *)placeholder {
    _categoryLabel.text = category;
    NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder];
    NSRange range = NSMakeRange(0, placeholder.length);
    [attributedPlaceholder addAttribute:NSFontAttributeName value:STFontRegular(18) range:range];
    [attributedPlaceholder addAttribute:NSForegroundColorAttributeName value:UIColor.fe_placeholderColor range:range];
    _inputTextField.attributedPlaceholder = attributedPlaceholder;
}

- (void)setInputEnabled:(BOOL)inputEnabled {
    _inputTextField.enabled = inputEnabled;
    _inputTextField.textColor = inputEnabled? UIColor.fe_titleTextColorLighten : [UIColor.fe_titleTextColorLighten colorWithAlphaComponent:0.8];
}

- (NSString *)inputedContent {
    //系统bug，右对齐时文本末端空格不显示
    NSString *content = _inputTextField.text;
    
    return [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setInputedContent:(NSString *)inputedContent {
    if (inputedContent.qmui_trim.length > 0) {
        _inputed = YES;
    }
    _inputTextField.text = inputedContent;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_bottomLine setBackgroundColor:UIColor.fe_mainColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_bottomLine setBackgroundColor:UIColor.fe_separatorColor];
}
@end
