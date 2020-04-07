//
//  FEChildInfoViewController.m
//  smartapp
//
//  Created by lafang on 2018/10/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEChildInfoViewController.h"
#import "UserService.h"
#import "ChildInfoTableViewCell.h"
#import "FETextInputAlertView.h"
#import "SelectHeadAlertView.h"
#import "TCPeriodSelectionView.h"

@interface FEChildInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong)NSArray *textArray;



@end
NSString *const FEChildInfoViewControllerInfoDidChangedNotification = @"FEChildInfoViewControllerInfoDidChangedNotification";
@implementation FEChildInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (UCManager.sharedInstance.isVisitorPattern) {
        [self showEmptyViewInView:self.view type:FEErrorType_NoData];
        return;
    }
    self.title = @"我的资料";
    
    
    self.textArray = @[@[@"头像:",@"昵称:",@"年级:"],@[@"姓名:",@"性别:"]];
    
    
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[ChildInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ChildInfoTableViewCell class])];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.fe_backgroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}


- (void)postInfoDidChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:FEChildInfoViewControllerInfoDidChangedNotification object:nil userInfo:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return ((NSArray *)self.textArray[0]).count;
    }else if(section == 1){
        return ((NSArray *)self.textArray[1]).count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return STWidth(10);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0){
        return STWidth(90);
    }
    return STWidth(60);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    headerView.contentView.backgroundColor = UIColor.fe_backgroundColor;
    return  headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    footerView.contentView.backgroundColor = UIColor.fe_backgroundColor;
    return  footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChildInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChildInfoTableViewCell class]) forIndexPath:indexPath];
    
    NSString *headUrl = @"";
    if(indexPath.section == 0 && indexPath.row == 0){
        headUrl = BSUser.currentUser.avatar.url;
    }
    NSString *rightStr = @"";
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            @weakObj(self);
            cell.commonBlock = ^(NSInteger index) {
                [selfweak alterAvatar];
            };
        } else if(indexPath.row == 1){
            rightStr = BSUser.currentUser.nickname;
        } else if (indexPath.row == 2) {
            rightStr = BSUser.currentUser.gradeName;
            cell.bottomLine.hidden = YES;
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            rightStr = BSUser.currentUser.realName;
        }else if(indexPath.row == 1){
            NSString *sexName = [BSUser.currentUser.gender isEqualToNumber:@1]? @"男": @"女";
            rightStr = sexName;
            cell.bottomLine.hidden = YES;
        }
        
        
    }
    if ([NSString isEmptyString:rightStr]) {
        rightStr = @"";
    }
    [cell updateCell:self.textArray[indexPath.section][indexPath.row] rightStr:rightStr headImageUrl:headUrl];
   
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if(indexPath.row == 1){
            [self nickNameClick];
        } else if (indexPath.row == 2){
            [self gradeClick];
        }
    }
    
}




//修改昵称点击
-(void)nickNameClick{
    FETextInputAlertView *alert = [[FETextInputAlertView alloc] initWithTitle:@"修改昵称" placeholder:@"请输入新昵称(2-12位字符)" cancleText:@"取消" confirmText:@"确认"];
    @weakObj(self);
    alert.result = ^(BOOL isConfirm, NSString * _Nonnull content) {
        if (isConfirm) {
            //中文，英文，数字正则
            NSString *regex = @"^[A-Za-z\u4E00-\u9FA5][A-Za-z0-9\u4E00-\u9FA5]{1,11}";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if([content isEqualToString:@""]){
                [QSToast toast:selfweak.view message:@"昵称不能为空"];
            }else if(content.length>12 || content.length<2){
                [QSToast toastWithMessage:@"昵称要求2-12位数字、英文、或者中文,不能以数字开头" duration:2];
            }else if(![pred evaluateWithObject:content]){
                [QSToast toastWithMessage:@"昵称要求2-12位数字、英文、或者中文,不能以数字开头" duration:2];
            }else{
                
                [QSLoadingView show];
                BSUser.currentUser.nickname = content;
                [BSUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    [QSLoadingView dismiss];
                    if (succeeded) {
                        [QSToast toast:selfweak.view message:@"昵称修改成功"];
                        [selfweak.tableView reloadData];
                        [selfweak postInfoDidChangeNotification];
                    } else {
                        [HttpErrorManager showErorInfo:error];
                    }
                }];
                
            }
        }
        
    };
    [alert show];
}


//修改年级
-(void)gradeClick{
    @weakObj(self);
    TCPeriodSelectionView *selectionView= [[TCPeriodSelectionView alloc] initWithOptions:@[@"高一", @"高二", @"高三"] selectedIndex:BSUser.currentUser.gradeNum.intValue - 10];
    selectionView.onSelected = ^(NSString * _Nonnull content, NSInteger index) {
        [QSLoadingView show];
        NSNumber *gradeNum;
        if ([content isEqualToString:PIMiddle10]) {
            gradeNum = @(10);
        } else  if ([content isEqualToString:PIMiddle11]) {
            gradeNum = @(11);
        } else if ([content isEqualToString:PIMiddle12]) {
            gradeNum = @(12);
        }
        BSUser.currentUser.gradeNum = gradeNum;
        [BSUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [QSLoadingView dismiss];
            if (succeeded) {
                [QSToast toast:selfweak.view message:@"年级修改成功"];
                [selfweak.tableView reloadData];
                [selfweak postInfoDidChangeNotification];
            } else {
                [HttpErrorManager showErorInfo:error];
            }
        }];
    };
    [selectionView showWithAnimated:YES];
}

-(void)alterAvatar{
    SelectHeadAlertView *selectHeadAlert = [[SelectHeadAlertView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    @weakObj(self);
    selectHeadAlert.resultAlert = ^(NSInteger index) {
        if(index == 1){
            //初始化UIImagePickerController
            UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
            //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
            //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
            //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
            PickerImage.navigationBar.translucent = NO;//去除毛玻璃效果
            PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //允许编辑，即放大裁剪
            PickerImage.allowsEditing = YES;
            //自代理
            PickerImage.delegate = selfweak;
            //页面跳转
            [selfweak presentViewController:PickerImage animated:YES completion:nil];
        }else if(index == 2){
            /**
             其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
             */
            UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
            //获取方式:通过相机
            PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            PickerImage.allowsEditing = YES;
            PickerImage.delegate = selfweak;
            [selfweak presentViewController:PickerImage animated:YES completion:nil];
        }
    };
    [selectHeadAlert showAlertView];
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    [self.avatarButton setImage:newPhoto];
    [self dismissViewControllerAnimated:YES completion:nil];
@weakObj(self);
    AVFile *file = [AVFile fileWithData:newPhoto.sd_imageData];
    [QSLoadingView show];
    [file uploadWithCompletionHandler:^(BOOL succeeded, NSError * _Nullable error) {
        [QSLoadingView dismiss];
        if (succeeded) {
            BSUser.currentUser.avatar = file;
            [BSUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [QSToast toast:self.view message:@"头像上传成功"];
                    ChildInfoTableViewCell *cell = [selfweak.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    if (cell) {
                        [cell updateUserHeadImage:file.url];
                        [selfweak postInfoDidChangeNotification];
                    }
                }
            }];
            
        } else {
            [HttpErrorManager showErorInfo:error];
        }
    }];

}

//相机相册取消按钮回调
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
