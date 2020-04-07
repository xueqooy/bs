//
//  FEChangePasswordViewController.m
//  smartapp
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019 jeyie0. All rights reserved.
//


#import "FEChangePasswordViewController.h"

#import "SharedTextTableViewCell.h"
#import "SharedButtonTableViewCell.h"

#import "UserService.h"
#import "UILabel+FEChain.h"
typedef NS_OPTIONS(NSUInteger, TextInputCompleteState) {
    TextInputCompleteStateOrigin = 1 << 0,
    TextInputCompleteStateNew = 1 << 1
};
@interface FEChangePasswordViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) BOOL needVerification;
@property(nonatomic, assign) TextInputCompleteState inputCompleteState;

@property(nonatomic, copy) NSString *originPassword;
@property(nonatomic, copy) NSString *n3wPassword;

@end

@implementation FEChangePasswordViewController

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    _needVerification = NO;
}

- (void)completeAction {
    [[UIApplication sharedApplication].keyWindow endEditing: YES];
    [QSLoadingView  show];
    [UserService changePassword:_originPassword newPassword:_n3wPassword success:^(id data) {
        [QSLoadingView dismiss];
        [QSToast toast:self.view message:@"密码修改成功！"];
        dispatch_time_t delayToPop = dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC);
        dispatch_after(delayToPop, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:self.view];
    }];
}

#pragma mark -
#pragma mark - TableView

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return STHeight(60);
    } else {
        return STHeight(82);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (_needVerification) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell = [self configVerficationCodeSenderCell];
            } else if (indexPath.row == 1) {
                cell = [self configVerficationCodeReceiverCell];
            } else {
                cell = [self configPasswordCellWithPlaceholder:@"请输入新密码"];
            }
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                 cell = [self configPasswordCellWithPlaceholder:@"请输入原密码"];
            } else {
                cell = [self configPasswordCellWithPlaceholder:@"请输入新密码"];
            }
        }
    }
    
    if (indexPath.section == 1) {
        cell = [self configCompletionButton];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)configVerficationCodeSenderCell {
    SharedTextTableViewCell *cell = [[SharedTextTableViewCell alloc] init];
    [cell buildComponent:SharedTextFieldComponentClearOrVisibleButton + SharedTextFieldComponentVerifyButton usePhoneFormat:YES];
    return cell;
}

- (UITableViewCell *)configVerficationCodeReceiverCell {
    SharedTextTableViewCell *cell = [[SharedTextTableViewCell alloc] init];
    [cell buildComponent:SharedTextFieldComponentClearOrVisibleButton usePhoneFormat:NO];
    return cell;
}

- (UITableViewCell *)configPasswordCellWithPlaceholder:(NSString *)placeholder {
    SharedTextTableViewCell *cell = [[SharedTextTableViewCell alloc] init];
    
    __weak typeof(self) weakSelf = self;
    cell.stateChangedHandler = ^(BOOL filled, NSString *changedText) {
        TextInputCompleteState state = [placeholder isEqualToString:@"请输入原密码"]? TextInputCompleteStateOrigin: TextInputCompleteStateNew;
        
        if (state == TextInputCompleteStateOrigin) {
            weakSelf.originPassword = changedText;
        } else {
            weakSelf.n3wPassword = changedText;
        }
        
        if (filled) {
            weakSelf.inputCompleteState = weakSelf.inputCompleteState | state;
        } else {
            weakSelf.inputCompleteState = weakSelf.inputCompleteState & (~state);
        }
        SharedButtonTableViewCell *buttonCell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        if (weakSelf.inputCompleteState == TextInputCompleteStateNew + TextInputCompleteStateOrigin) {
            [buttonCell setMainButtonEnabled:YES];
        } else {
            [buttonCell setMainButtonEnabled:NO];
        }
    };
    [cell setPlaceholder:placeholder];
    [cell buildComponent:SharedTextFieldComponentClearOrVisibleButton usePhoneFormat:NO];
    [cell secureTextEntry:YES];

    return cell;
}

- (UITableViewCell *)configCompletionButton {
    SharedButtonTableViewCell *cell = [[SharedButtonTableViewCell alloc] init];
    [cell setMainButtonTitle:@"完成"];
    [cell setMainButtonEnabled:NO];
//    [cell buildComponent:SharedButtonComponentRightButton];
//    if (_needVerification) {
//        [cell setRightButtonTitle:@"使用原密码修改"];
//    } else {
//        [cell setRightButtonTitle:@"使用验证码修改"];
//    }
    
    __weak typeof(self) weakSelf = self;
    cell.buttonClickedHandler = ^(SharedButtonType type, UIButton * _Nonnull sender) {
//        if (type == SharedButtonComponentRightButton) {
//            weakSelf.needVerification = !weakSelf.needVerification;
//            [weakSelf.tableView reloadData];
//        }
        [weakSelf completeAction];
        if (type == SharedButtonTypetMain) {
            
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return STHeight(60);
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [UIView new];
        
        [UILabel create:^(UILabel *label) {
            label.textIs(@"密码长度为6-24个字符，可以是数字、字母等任意字符")
            .textColorIs(UIColor.fe_mainColor)
            .fontIs(STFont(12))
            .backgroundColorIs(UIColor.fe_contentBackgroundColor);
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo([SizeTool width:15]);
            }];
        } addTo:view];
        return view;
    } else {
        return nil;
    }
}

@end
