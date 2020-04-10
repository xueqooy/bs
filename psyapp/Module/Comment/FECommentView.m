//
//  FECommentView.m
//  smartapp
//
//  Created by mac on 2019/7/29.
//  Copyright © 2019 xueqooy. All rights reserved.
//

#import "FECommentView.h"
#import "FECommentInputView.h"
#import "FastClickUtils.h"
@interface FECommentView () <UIGestureRecognizerDelegate>
@property(nonatomic, strong) UIView *container;
@property(nonatomic, strong) UITextField *contentTextField;

@property(nonatomic, strong) UIButton *discussButton;
@property(nonatomic, strong) UILabel *discussBadge;

@property(nonatomic, strong) UIButton *likeButton;
@property(nonatomic, strong) UILabel *likeBadge;

@property(nonatomic, strong) UIButton *collectButton;
@property(nonatomic, strong) UILabel *collectBadge;

@property(nonatomic, strong) UIButton *listButton;
@property(nonatomic, strong) UILabel *listBadge;

@property(nonatomic, strong) NSString *editingCommentText;

@property(nonatomic, assign) FECommentViewComponent components;
@property(nonatomic, assign) CGFloat componentsWidth;
@property(nonatomic, assign) NSInteger componentsCount;
@property(nonatomic, weak)   UIView *lastComponent;

@property(nonatomic, assign) BOOL likeIsSelected;
@property(nonatomic, assign) BOOL collectIsSelected;
@end
@implementation FECommentView {
    NSInteger _componentsCount;
}

+ (instancetype)createCommentViewWithComponent:(FECommentViewComponent)components {
    FECommentView *commentView = [[self alloc] init];
    commentView.components = components;
    commentView.componentsWidth = [SizeTool width:40];
    commentView.componentsCount = 0;
    commentView.editable = YES;
    commentView.likeIsSelected = NO;
    commentView.collectIsSelected = NO;
    commentView.autoSwitchButtonIcon = YES;
    if (components & FECommentViewComponentDiscuss) {
        commentView.componentsCount ++;
    }
    if (components & FECommentViewComponentLike) {
        commentView.componentsCount ++;
    }
    if (components & FECommentViewComponentCollect) {
        commentView.componentsCount ++;
    }
    
    if (components & FECommentViewComponentList) {
        commentView.componentsCount ++;
    }
    
    [commentView buildBaseSubviews];
    
    if (components & FECommentViewComponentDiscuss) {
        [commentView buildComponentWithType:FECommentViewComponentDiscuss iconImageNamed:@"comment_discuss"];
    }
    if (components & FECommentViewComponentLike) {
         [commentView buildComponentWithType:FECommentViewComponentLike iconImageNamed:@"comment_unlike"];
    }
    if (components & FECommentViewComponentCollect) {
         [commentView buildComponentWithType:FECommentViewComponentCollect iconImageNamed:@"comment_uncollect"];
    }
    
    if (components & FECommentViewComponentList) {
        [commentView buildComponentWithType:FECommentViewComponentList iconImageNamed:@"list_black"];
    }
    
    return commentView;
}

- (void)setCount:(NSInteger)count forComponent:(FECommentViewComponent)component {
    UILabel *badge = [self getBadgeForType:component];
    
    if (count == 0 ) {
        badge.hidden = YES;
        return;
    };
    badge.hidden = NO;
    
    badge.text = [NSString stringWithFormat:@"%ld", (long)count];
}

- (void)setSelected:(BOOL)selected forComponent:(FECommentViewComponent)component {
    if (component & FECommentViewComponentLike) {
        if (_likeIsSelected != selected && _likeButton != nil) {
            [_likeButton setImage:[UIImage imageNamed:selected?@"comment_like":@"comment_unlike"] forState:UIControlStateNormal];
            _likeIsSelected = selected;
        }
    }
    if (component & FECommentViewComponentCollect) {
        if (_collectIsSelected != selected && _collectButton != nil) {
            [_collectButton setImage:[UIImage imageNamed:selected?@"comment_collect":@"comment_uncollect"] forState:UIControlStateNormal];
            _collectIsSelected = selected;
        }
    }
}

- (void)buildComponentWithType:(FECommentViewComponent)type iconImageNamed:(NSString *)imageName {
    UIButton *button = [self getButtonForType:type];
    button.tag = type + 10000;
    button.contentMode = UIViewContentModeScaleAspectFill;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    [_container addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lastComponent.mas_right);
        make.centerY.equalTo(_container);
        make.size.mas_equalTo(CGSizeMake(_componentsWidth, _componentsWidth));
    }];
    
    [self setBadgeForComponent:type];
    
    _lastComponent = button;
}

- (void)setBadgeForComponent:(FECommentViewComponent)component {
    UILabel *badge = [self getBadgeForType:component];
    badge.text = @"";
    badge.textColor = [UIColor fe_dynamicColorWithDefault:UIColor.whiteColor darkColor:UIColor.fe_contentBackgroundColor];
    badge.font = mFontRegular([SizeTool height:8]);
    badge.userInteractionEnabled = NO;
    badge.textAlignment = NSTextAlignmentCenter;
    badge.backgroundColor = UIColor.fe_mainColor;
    badge.layer.cornerRadius = [SizeTool height:4.5];
    badge.layer.borderWidth = 0.5;
    badge.layer.borderColor = UIColor.fe_contentBackgroundColor.CGColor;
    badge.layer.masksToBounds = YES;
    
    UIView *superView = [self getButtonForType:component];
    
    if (superView == nil) return;
    
    [superView addSubview:badge];
    [badge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([SizeTool width:15], [SizeTool height:9]));
        make.left.mas_equalTo([SizeTool width:22.4]);
        make.bottom.mas_equalTo([SizeTool height:-22.4]);
    }];
    badge.hidden = YES;
    
}

- (UIButton *)getButtonForType:(FECommentViewComponent)type {
    UIButton *button;
    if (type == FECommentViewComponentDiscuss) {
        if (_discussButton == nil) {
            _discussButton = [UIButton new];
        }
        button = _discussButton;
    } else if (type == FECommentViewComponentLike) {
        if (_likeButton == nil) {
            _likeButton = [UIButton new];
        }
        button = _likeButton;
    } else if (type == FECommentViewComponentCollect) {
        if (_collectButton == nil) {
            _collectButton = [UIButton new];
        }
        button = _collectButton;
    } else if (type == FECommentViewComponentList) {
        if (_listButton == nil) {
            _listButton = [UIButton new];
        }
        button = _listButton;
    }
    
    return button;
}

- (UILabel *)getBadgeForType:(FECommentViewComponent)type {
    UILabel *badge;
    if (type == FECommentViewComponentDiscuss) {
        if (_discussBadge == nil) {
            _discussBadge = [UILabel new];
        }
        badge = _discussBadge;
    } else if (type == FECommentViewComponentLike) {
        if (_likeBadge == nil) {
            _likeBadge = [UILabel new];
        }
        badge = _likeBadge;
    } else if (type == FECommentViewComponentCollect) {
        if (_collectBadge == nil) {
            _collectBadge = [UILabel new];
        }
        badge = _collectBadge;
    } else if (type == FECommentViewComponentList) {
        if (_listBadge == nil) {
            _listBadge = [UILabel new];
        }
        badge = _listBadge;
    }
    return badge;
}


- (void)buildBaseSubviews {
    _container = [[UIView alloc] init];
    _container.backgroundColor = UIColor.fe_contentBackgroundColor;
    [self addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo([SizeTool height:50.f]);
    }];
    
    _contentTextField = [[UITextField alloc] init];
    _contentTextField.backgroundColor = UIColor.fe_buttonBackgroundColorActive;
    _contentTextField.layer.masksToBounds = YES;
    _contentTextField.layer.cornerRadius = 2;
    _contentTextField.layer.borderColor = UIColor.fe_separatorColor.CGColor;
    _contentTextField.placeholder = @"   写评论";
    _contentTextField.textColor = UIColor.fe_mainTextColor;
    _contentTextField.font = [UIFont systemFontOfSize:14];
   
    if (@available(iOS 13.0, *)) {
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"   写评论" attributes:@{NSForegroundColorAttributeName : UIColor.fe_placeholderColor}];
        _contentTextField.attributedPlaceholder = placeholderString;
    } else {
        [_contentTextField setValue:UIColor.fe_placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    [_container addSubview:_contentTextField];
    [_contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([SizeTool width:15]);
        make.centerY.equalTo(_container);
        make.height.mas_equalTo([SizeTool height:32]);
        if (self.componentsCount == 0) {
            make.right.mas_equalTo(-[SizeTool width:15]);
        } else {
            make.right.mas_equalTo(-self.componentsWidth * self.componentsCount - [SizeTool width:6]);
        }
    }];
    //兼容低版本textField拦截tap手势
    {
        UIView *gestureResposer = [UIView new];
        [_contentTextField addSubview:gestureResposer];
        [gestureResposer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [gestureResposer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInputView)]];
    }
    
    
    UIView *topLineView = [UIView new];
    topLineView.backgroundColor = UIColor.fe_separatorColor;
    [_container addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(mScreenWidth, 0.5));
        make.top.left.mas_equalTo(0);
    }];
    
    self.lastComponent = _contentTextField;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _contentTextField.placeholder =  [NSString stringWithFormat:@"   %@", placeholder];
}

- (void)buttonClick:(UIButton *)sender {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@0.99,@0.98,@0.97,@0.96,@.97,@0.98,@0.99,@1.0];
    animation.duration = 0.15;
    animation.calculationMode = kCAAnimationCubic;
    [sender.layer addAnimation:animation forKey:nil];
    
    if (_componentClickHandler) {
        _componentClickHandler(sender.tag%10000);
        
    }
    if (_autoSwitchButtonIcon) {
        if (sender.tag%10000 == FECommentViewComponentDiscuss) return;
        BOOL selected = NO;
        if (sender.tag%10000 == FECommentViewComponentLike) {
            selected = _likeIsSelected;
            if (!selected) [TCSystemFeedbackHelper impactLight];
        } else if (sender.tag%10000 == FECommentViewComponentCollect) {
            selected = _collectIsSelected;
            [TCSystemFeedbackHelper impactLight];
        }
        
        [self setSelected:!selected forComponent:sender.tag%10000];
    }
}



- (void)showInputView {
    if (!_editable) {
        return;
    }
    
    FECommentInputView *commentView = [[FECommentInputView alloc] init];
    commentView.placeholder = _placeholder? _placeholder: @"写评论" ;
    if(![NSString isEmptyString:_editingCommentText]){
        [commentView setContent:_editingCommentText];
    }
    commentView.result = ^(NSString *inputText,BOOL isSure) {
        if(inputText){
            if(inputText){
                _editingCommentText = inputText;
                _contentTextField.text = [NSString stringWithFormat:@"   %@",inputText];
            }else{
                _editingCommentText = @"";
            }
            if(isSure){
                if (_commentSendHandler) {
                    _commentSendHandler(inputText);
                    _contentTextField.text = nil;
                    _editingCommentText = nil;
                    _contentTextField.placeholder = _placeholder? [NSString stringWithFormat:@"   %@", _placeholder]: @"   写评论";
                }
            } else {
                if ([inputText isEqualToString:@""]) {
                    _contentTextField.text = nil;
                    _editingCommentText = nil;
                    _contentTextField.placeholder = _placeholder? [NSString stringWithFormat:@"   %@", _placeholder]: @"   写评论";

                }
            }
            
        }
    };
    [commentView show];
}
@end
