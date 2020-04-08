//
//  ProfessionalBenkeView.m
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalBenkeView.h"
#import "CareerService.h"
#import <RATreeView/RATreeView.h>
//#import "RaTreeViewCell.h"
#import "RaTreeModel.h"
#import "ProfessionalDetailsViewController.h"
#import "FEOuccupationTreeViewCell.h"

@interface ProfessionalBenkeView()<RATreeViewDataSource,RATreeViewDelegate>

@property(nonatomic,strong) NSArray<ProfessionalSubjectModel *> *professionalSubjectModels;

@property (nonatomic,strong) RATreeView *raTreeView;

@property (nonatomic,strong) NSMutableArray *modelArray;//存储model的数组

@property (nonatomic,strong) FEBaseViewController *controller;

@property (nonatomic, weak) RaTreeModel *expandedCellModel; //只允许展开一个；保存当前展开的cell model

@end

@implementation ProfessionalBenkeView

-(instancetype)initWithController:(FEBaseViewController *)controller{
    
    self.controller = controller;
    
    if(self == [super init]){
        [self loadData];
    }
    
    return self;
}

-(void)initTreeView{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    [self setData];
    //创建raTreeView
    self.raTreeView = [[RATreeView alloc] initWithFrame:self.frame];
    _raTreeView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //设置代理
    self.raTreeView.delegate = self;
    self.raTreeView.dataSource = self;
    self.raTreeView.collapsesChildRowsWhenRowCollapses= YES;

    [self addSubview:self.raTreeView];
    
    //注册单元格
  //  [self.raTreeView registerNib:[UINib nibWithNibName:@"FEOuccupationTreeViewCell" bundle:nil] forCellReuseIdentifier:@"FEOuccupationTreeViewCell"];
}

//加载数据
- (void)setData {
    
    for(int i=0;i<self.professionalSubjectModels.count;i++){
        
        ProfessionalSubjectModel *model = self.professionalSubjectModels[i];
        
        NSArray<ProfessionalModel *> *professionalModels = model.categorys;
        
        NSMutableArray *secondArr = [[NSMutableArray alloc] init];
        
        RaTreeModel *firstRt = [RaTreeModel dataObjectWithName:model.subject children:secondArr];

        for(int j=0;j<professionalModels.count;j++){
            
            ProfessionalModel *professionalModel = professionalModels[j];
            
            NSArray<ProfessionalCategoryModel *> *pmodels = professionalModel.majors;
            
            NSMutableArray *thirdArr = [[NSMutableArray alloc] init];
            for(int k=0;k<pmodels.count;k++){
                
                ProfessionalCategoryModel *pmodel = pmodels[k];
                
                RaTreeModel *thirdRt = [RaTreeModel dataObjectWithName:pmodel.majorName children:nil];
                
                thirdRt.currentId = pmodel.majorCode;
                
                [thirdArr addObject:thirdRt];
            }
            
            RaTreeModel *secondRt = [RaTreeModel dataObjectWithName:professionalModel.category children:thirdArr];
            
            secondRt.parent = firstRt;
            
            [secondArr addObject:secondRt];
            
        }
        
        
        [self.modelArray addObject:firstRt];
        
    }
    
    
}

-(void)loadData{
    [QSLoadingView show];
    [CareerService getProfessionalList:@"2" majorName:@"" success:^(id data) {
        [QSLoadingView dismiss];
        if(data){
            ProfessionalRootModel *dataModel = [MTLJSONAdapter modelOfClass:ProfessionalRootModel.class fromJSONDictionary:data error:nil];
            if(dataModel){
                self.professionalSubjectModels = dataModel.items;
//                [self uploadToCloudForData:self.professionalSubjectModels];
                [self initTreeView];
            }
            
        }
        
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:self];
    }];
}

//- (void)uploadToCloudForData:(NSArray <ProfessionalSubjectModel *>*)data {
//    NSMutableArray *majors = @[].mutableCopy;
//    for (ProfessionalSubjectModel *model in data) {
//        for (ProfessionalModel *model1 in model.categorys) {
//            for (ProfessionalCategoryModel *model2 in model1.majors) {
//                AVObject *major = [AVObject objectWithClassName:@"MajorLib"];
//                [major setObject:model2.majorName forKey:@"majorName"];
//                [major setObject:model2.majorCode forKey:@"majorCode"];
//                [majors addObject:major];
//            }
//        }
//    }
//    [AVObject saveAllInBackground:majors block:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            [QSToast toastWithMessage:@"上传成功"];
//        }
//    }];
//}



#pragma mark -----------delegate

//返回行高
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    
    return STWidth(60);
}

//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    NSInteger level = [treeView levelForCellForItem:item];
    RaTreeModel *model = item;
    
    if (level != 2) {
        FEOuccupationTreeViewCell *cell = (FEOuccupationTreeViewCell *)[treeView cellForItem:item];
        [cell setExpantionStatus:YES];
        
        //收起上一次展开的cell
        if (_expandedCellModel && _expandedCellModel != model) {
            if (![_expandedCellModel.children containsObject:model]) {//再判断是不是展开子节点
                [treeView collapseRowForItem:_expandedCellModel];
                FEOuccupationTreeViewCell *cell = (FEOuccupationTreeViewCell *)[treeView cellForItem:_expandedCellModel];
                [cell setExpantionStatus:NO];
                if (_expandedCellModel.parent != model.parent) { //不是同一父节点， 关闭它的父节点
                    [treeView collapseRowForItem:_expandedCellModel.parent];
                    FEOuccupationTreeViewCell *cell = (FEOuccupationTreeViewCell *)[treeView cellForItem:_expandedCellModel.parent];
                    [cell setExpantionStatus:NO];
                }
            }
        }
        
        _expandedCellModel = model;
    }
    
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    
    FEOuccupationTreeViewCell *cell = (FEOuccupationTreeViewCell *)[treeView cellForItem:item];
    [cell setExpantionStatus:NO];
    
}

//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    
    
    NSLog(@"已经展开了");
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    
    NSLog(@"已经收缩了");
}


#pragma mark -----------dataSource

//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    
    
    
    //获取cell
    FEOuccupationTreeViewCell *cell = [FEOuccupationTreeViewCell treeViewCellWith:treeView];
    
    //当前item
    RaTreeModel *model = item;
    
    //当前层级
    NSInteger level = [treeView levelForCellForItem:item];
    
    //赋值
    [cell setCellWith:model.name level:level children:model.children.count];

    return cell;
    
}

/**
 *  必须实现
 *
 *  @param treeView treeView
 *  @param item    节点对应的item
 *
 *  @return  每一节点对应的个数
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    RaTreeModel *model = item;
    
    if (item == nil) {
        
        return self.modelArray.count;
    }
    
    return model.children.count;
}
/**
 *必须实现的dataSource方法
 *
 *  @param treeView treeView
 *  @param index    子节点的索引
 *  @param item     子节点索引对应的item
 *
 *  @return 返回 节点对应的item
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    
    RaTreeModel *model = item;
    if (item==nil) {
        
        return self.modelArray[index];
    }
    
    return model.children[index];
}


//cell的点击方法
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    
    //获取当前的层
    NSInteger level = [treeView levelForCellForItem:item];
    
    //当前点击的model
    RaTreeModel *model = item;
    
    NSLog(@"点击的是第%ld层,name=%@",level,model.name);
    
    if(level == 2){
        //跳转详情
        ProfessionalDetailsViewController *vc = [ProfessionalDetailsViewController suspendTopPausePageVC] ;//[[ProfessionalDetailsViewController alloc] init];
        vc.majorCode = model.currentId;
        [self.controller.navigationController pushViewController:vc animated:YES];
    }
    
}

//单元格是否可以编辑 默认是YES
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    
    return NO;
}

//编辑要实现的方法
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item {
    
    NSLog(@"编辑了实现的方法");
    
    
}

//....没看懂啥意思
- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item {
    
    return 3;
}



@end
