//
//  PISelectBox.m
//  smartapp
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PISelectBox.h"

@interface PISelectBox ()
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UIView *touchResponser;

@property (nonatomic, copy, readwrite) NSString *selectedContent;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation PISelectBox {
    BOOL _selected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _targetLabel.textColor = UIColor.fe_titleTextColorLighten;
    _categoryLabel.textColor = UIColor.fe_titleTextColorLighten;
    _bottomLine.backgroundColor = UIColor.fe_separatorColor;
    _placeholderLabel.textColor = UIColor.fe_placeholderColor;
    self.targetLabel.hidden = YES;
    @weakObj(self);
    [_touchResponser addTapGestureWithBlock:^{
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        @strongObj(self);
        [self.bottomLine setBackgroundColor:UIColor.fe_mainColor];
        [self.selector pi_showSelector];
        @weakObj(self);
        self.selector.pi_selectedHandler = ^(NSString * _Nonnull content) {
            @strongObj(self);
            self.targetLabel.text = content;
            self.placeholderLabel.hidden = YES;
            self.arrowImageView.hidden = YES;
            self.targetLabel.hidden = NO;
            self.selectedContent = content;
            
            if (self.stateHandler) {
                if (self->_selected == NO) {
                    self->_selected = YES;
                    self.stateHandler(self->_selected);
                }
            }
        };
        if ([self.selector respondsToSelector:@selector(setPi_hiddenHandler:)]) {
            self.selector.pi_hiddenHandler = ^{
                @strongObj(self);
                [self.bottomLine setBackgroundColor:UIColor.fe_separatorColor];
            };
        }
    }];
}


- (void)setCategory:(NSString *)category placeholder:(NSString *)placeholder {
    _categoryLabel.text = category;
    _placeholderLabel.text = placeholder;
}


@end
