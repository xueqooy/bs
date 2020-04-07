//
//  FireSelectDefaultTableViewCell.m
//  smartapp
//
//  Created by lafang on 2018/9/19.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEAnswerSelectionCell.h"
#import "FECommentInputView.h"
#import "FastClickUtils.h"
#import "FETailLabel.h"

@interface FEAnswerSelectionCell ()

@property(nonatomic,strong) UIView *itemView;
@property(nonatomic,strong) UIButton *optionBtn;
@property(nonatomic,strong) UIImageView *optionImage;
@property(nonatomic,strong) UIView *fillView;
@property(nonatomic,strong) UILabel *optionBtnField;
@property(nonatomic,strong) FETailLabel *optionBtnText;

@end

@implementation FEAnswerSelectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = UIColor.fe_contentBackgroundColor;
        self.itemView = [[UIView alloc] init];
        self.itemView.layer.cornerRadius = STWidth(4);
        self.itemView.backgroundColor = UIColor.fe_buttonBackgroundColorActive;
        [self.contentView addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([SizeTool width:15]);
            make.right.equalTo(self.contentView).offset(-[SizeTool width:15]);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.optionBtn = [[UIButton alloc] init];
        self.optionBtn.layer.masksToBounds = YES;
        self.optionBtn.tag = 20000;
        self.optionBtn.backgroundColor = [UIColor clearColor];
        [self.optionBtn setTitle:@"完全符合" forState:UIControlStateNormal];
        [self.optionBtn setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];
        self.optionBtn.titleLabel.font = STFontRegular(16);
        [self.optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.optionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, STWidth(15), 0, STWidth(15))];
        [self.itemView addSubview:self.optionBtn];
        [self.optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.itemView);
            make.size.equalTo(self.itemView);
        }];
        
        self.optionBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;

        
        self.fillView = [[UIView alloc] init];
        self.fillView.backgroundColor = [UIColor clearColor];
        self.fillView.layer.masksToBounds = YES;
//        self.fillView.layer.cornerRadius = STWidth(4);
        [self.itemView addSubview:self.fillView];
        [self.fillView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.itemView);
            make.size.equalTo(self.itemView);
        }];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(optionClick:)];
        [self.fillView addGestureRecognizer:tapGesturRecognizer];
        self.fillView.hidden = YES;

        self.optionBtnField = [[UILabel alloc] init];
        self.optionBtnField.textAlignment = NSTextAlignmentCenter;
        self.optionBtnField.textColor = UIColor.fe_titleTextColorLighten;
        self.optionBtnField.font = STFontRegular(16);
        [self.fillView addSubview:self.optionBtnField];
        [self.optionBtnField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.fillView);
            make.height.equalTo(self.fillView);
        }];
        
        self.optionBtnText = [[FETailLabel alloc] initWithFrame:CGRectMake(0, 0, [SizeTool width:75], [SizeTool height:18])];
        self.optionBtnText.textColor = UIColor.fe_titleTextColorLighten;
        self.optionBtnText.font = STFontRegular(12);
        self.optionBtnText.textAlignment = NSTextAlignmentCenter;
        self.optionBtnText.backgroundColor = UIColor.fe_mainColor;
        self.optionBtnText.textInsets = UIEdgeInsetsMake(0, [SizeTool width:10], 0, [SizeTool width:9]);
        [self.fillView addSubview:self.optionBtnText];
        [self.optionBtnText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.fillView);
            make.left.mas_equalTo([SizeTool width:260]);
            make.height.mas_equalTo([SizeTool height:18]);
            make.width.mas_equalTo([SizeTool width:75]);
        }];

            
        self.optionImage = [[UIImageView alloc] init];
        [self.optionImage setImage:[UIImage imageNamed:@"fire_common_head_circle"]];
        [self.itemView addSubview:self.optionImage];
        [self.optionImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView).offset(20);
            make.centerY.equalTo(self.itemView);
            make.size.mas_equalTo(CGSizeMake(32, 12));
        }];
        self.optionImage.hidden = YES;
        
        

        
    }
    
    return self;
}




-(void)optionClick:(UIButton *)sender{
    
    
    if([FastClickUtils isFastClick]){
        return;
    }

    
    if([_optionModel.type integerValue] == 2){
        
        FECommentInputView *commentView = [[FECommentInputView alloc] init];
        commentView.result = ^(NSString *inputText,BOOL isSure) {
            if(inputText && isSure){
                _optionText = inputText;
                NSString *contentText = [NSString stringWithFormat:@"%@%@",_optionModel.content,_optionText];
                [self.optionBtn setTitle:contentText forState:UIControlStateNormal];
                if(self.answeredHandler){
                    self.answeredHandler(self.curOptionIndex,self.optionText);
                }
            }
        };
        [commentView show];
        
    }else{
        if(self.answeredHandler){
            self.answeredHandler(self.curOptionIndex,self.optionText);
        }
    }
    
}

-(void)setOptionIndex:(NSInteger)optionIndex optionText:(NSString *)optionText selectIndex:(NSInteger)selectIndex optionModel:(OptionModel *)optionModel questionChildModel:(QuestionChildModel *)questionChildModel{
    _curOptionIndex = optionIndex;
    _optionModel = optionModel;
    _questionChildModel = questionChildModel;
    
    if(optionText && ![optionText isEqualToString:@""]){
        _optionText = optionText;
    }else{
        if(questionChildModel){
            _optionText = questionChildModel.optionText;
        }else{
            _optionText = @"";
        }
    }
    
    if([optionModel.type integerValue] == 2){ //文本输入

        self.fillView.hidden = NO;
        self.optionBtn.hidden = YES;
        self.optionBtnField.text = optionModel.content;
        
        CGFloat textWidth = [_optionText getWidthForFont:STFontRegular(12)] + [SizeTool width:20];
        CGFloat maxWidth = [SizeTool width:75];
        self.optionBtnText.text = _optionText;
        
        if (textWidth > maxWidth) {
            textWidth = maxWidth;
        }
        [_optionBtnText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textWidth);
        }];
        
        if(selectIndex == optionIndex){
            //self.optionImage.hidden = NO;
           
            self.itemView.backgroundColor = [UIColor fe_dynamicColorWithDefault:[UIColor.fe_mainColor colorWithAlphaComponent:0.05] darkColor:[mHexColor(@"fffbed") colorWithAlphaComponent:FEThemeDarkCommonAlpha]];
            self.itemView.layer.borderWidth = 1;
            self.itemView.layer.borderColor = UIColor.fe_mainColor.CGColor;
            NSString *contentText = [NSString stringWithFormat:@"%@%@",optionModel.content,_optionText];
            [self.optionBtn setTitle:contentText forState:UIControlStateNormal];

            
            self.optionBtnText.hidden = NO;

            if ( [[_optionText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                self.optionBtnText.hidden = YES;
            }
        }else{
            self.itemView.backgroundColor = UIColor.fe_buttonBackgroundColorActive;
           
            self.itemView.layer.borderWidth = 0;

            
            self.optionBtnText.hidden = YES;
        }


    }else{
        self.fillView.hidden = YES;
        self.optionBtn.hidden = NO;
        [self.optionBtn setTitle:optionModel.content forState:UIControlStateNormal];
        if(selectIndex == optionIndex){
            self.itemView.backgroundColor = UIColor.fe_mainColor;
            self.itemView.layer.borderWidth = 1;
            self.itemView.layer.borderColor = UIColor.fe_mainColor.CGColor;
            [self.optionBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        }else{
            self.itemView.backgroundColor = UIColor.fe_buttonBackgroundColorActive;
            self.itemView.layer.borderWidth = 0;
            [self.optionBtn setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];

        }

    }

}

@end
