//
//  NoFindViewController.m
//  KJ
//
//  Created by iOSDeveloper on 16/5/3.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "NoFindViewController.h"
#import "GroupModel.h"
#import "DownloadListModel.h"
#import "ListTableViewCell.h"

@interface NoFindViewController ()
@property (nonatomic, strong) UIView * toolView;
@property (nonatomic, strong) UIButton * btnTool;
@property (nonatomic, strong) UILabel *labLine;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSMutableArray * selectArray;
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, strong) UILabel * labTitle;
@property (nonatomic, strong) UIWebView *phoneCallWebView;
@end

@implementation NoFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeight = 185.f;
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItemExtension leftBackButtonItem:@selector(backAciton) andTarget:self],[UIBarButtonItemExtension leftTitleItem:@"未找到"]];
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItemExtension rightButtonItem:@selector(right2) andTarget:self andButtonTitle:@"选择"]];
    self.tableView.top = 40;
    self.tableView.height = DeviceSize.height - 40;
    [self.view addSubview:self.headView];
    [self.headView addSubview:self.labTitle];
    [self.view addSubview:self.toolView];
    [self.toolView addSubview:self.labLine];
    [self.toolView addSubview:self.btnTool];
    self.selectArray = [NSMutableArray array];
    self.dataArray = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"NoFind%@",[CommUtil readDataWithFileName:@"userName"]]];
    NSInteger sum = 0;
    [self.view addSubview:self.phoneCallWebView];
    for (GroupModel * model in self.dataArray) {
        sum += model.count;
    }
    self.labTitle.text = [NSString stringWithFormat:@"未找到零件总数：%ld",(long)sum];
    
    // Do any additional setup after loading the view.
}
- (void)right1{
    
}
- (void)right2{
    [self.view endEditing:YES];
    
    [self.tableView setEditing:(!self.tableView.editing) animated:YES];
    [self.selectArray removeAllObjects];
    [self.btnTool setTitle:[NSString stringWithFormat:@"(%ld)个零件恢复",(long)self.selectArray.count] forState:UIControlStateNormal];
    if (self.tableView.editing == YES) {
        self.toolView.hidden = NO;
        self.tableView.height = DeviceSize.height - 40 - 49;
    }else{
        self.tableView.height = DeviceSize.height - 40 ;
        self.toolView.hidden = YES;
    }
    NSInteger sum = 0;
    for (GroupModel * model in self.dataArray) {
        sum += model.count;
    }
    self.labTitle.text = [NSString stringWithFormat:@"未找到零件总数：%ld",(long)sum];
}
- (void)backAciton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceSize.height - 49, DeviceSize.width, 49)];
        _toolView.backgroundColor = [UIColor whiteColor];
        _toolView.hidden = YES;
    }
    return _toolView;
}
- (UILabel *)labLine{
    if (!_labLine) {
        _labLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 0.5)];
        _labLine.backgroundColor = [UIColor colorWithHEX:0xcccccc];
    }
    return _labLine;
}
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, DeviceSize.width, 40)];
        _headView.backgroundColor = [UIColor lightGrayColor];
    }
    return _headView;
}
- (UILabel *)labTitle{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, (40 - 20)/2, DeviceSize.width - 20, 20)];
        _labTitle.font = [UIFont systemFontOfSize:15];
        _labTitle.text = @"未找到零件总数：0";
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}
- (UIButton *)btnTool{
    if (!_btnTool) {
        _btnTool = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTool.frame = CGRectMake(15, (49 - 40)/2, DeviceSize.width - 30, 40);
        _btnTool.backgroundColor = [UIColor colorWithHEX:0x20c6c6];
        [_btnTool setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnTool setTitle:[NSString stringWithFormat:@"(0)个零件恢复"] forState:UIControlStateNormal];
        _btnTool.layer.cornerRadius = 6.f;
        [_btnTool addTarget:self action:@selector(btnToolClick) forControlEvents:UIControlEventTouchUpInside];
        _btnTool.layer.masksToBounds = YES;
    }
    return _btnTool;
}
#pragma mark ------
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GroupModel * model = self.dataArray[section];
    return model.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellName = @"cellId";
    ListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    GroupModel * model  = self.dataArray[indexPath.section];
    DownloadListModel * item = model.list[indexPath.row];
    WeakSelf(NoFindViewController);
    [cell setPlayPhone:^(NSString *phoneStr) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneStr]];
        if (!weakSelf.phoneCallWebView ) {
            weakSelf.phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [weakSelf.phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }];
    self.cellHeight = [cell configWithModel:item row:indexPath.row + 1];
    return cell;
}

#pragma mark ------
#pragma mark groupview
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GroupModel * model = self.dataArray[section];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 40)];
    view.backgroundColor = [UIColor grayColor];
    UILabel * labBah = [[UILabel alloc]initWithFrame:CGRectMake(10, (40 - 15)/2, DeviceSize.width - 20 - 100, 15)];
    labBah.font = [UIFont systemFontOfSize:15];
    labBah.textAlignment = NSTextAlignmentLeft;
    labBah.text = model.cph;
    UILabel * labCount = [[UILabel alloc]initWithFrame:CGRectMake(DeviceSize.width - 10 - 100, (40 - 15)/2, 100, 15)];
    labCount.textAlignment = NSTextAlignmentRight;
    labCount.font = [UIFont systemFontOfSize:15];
    labCount.text = [NSString stringWithFormat:@"数量：%ld",(long)model.count];
    [view addSubview:labBah];
    [view addSubview:labCount];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete || editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"@@@@@");
    }else{
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing == YES) {
        [self.selectArray addObject:indexPath];
        [self.btnTool setTitle:[NSString stringWithFormat:@"(%ld)个零件恢复",(unsigned long)self.selectArray.count] forState:UIControlStateNormal];
    }else{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing == YES) {
        [self.selectArray removeObject:indexPath];
        [self.btnTool setTitle:[NSString stringWithFormat:@"(%ld)个零件恢复",(unsigned long)self.selectArray.count] forState:UIControlStateNormal];
    }else{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}
#pragma mark ------
#pragma mark scrollerView delegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark ------
#pragma mark touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)btnToolClick{
    NSMutableArray * array = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"Download%@",[CommUtil readDataWithFileName:@"userName"]]];
    for (int i=0; i<[self.selectArray count]; i++) {
        for (int j = i + 1; j<[self.selectArray count]; j++) {
            if ([[self.selectArray objectAtIndex:i] row] > [[self.selectArray objectAtIndex:j] row]) {
                [self.selectArray exchangeObjectAtIndex:j withObjectAtIndex:i];
            }
        }
    }
    [self.selectArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath * indexPath = (NSIndexPath *) obj;
        GroupModel * newItem;
        if (self.dataArray.count <= indexPath.section) {
            return ;
        }
        GroupModel * model = self.dataArray[indexPath.section];
        if (model.list.count <= indexPath.row) {
            return;
        }
        DownloadListModel * item = model.list[indexPath.row];
        if ([self equalInfoArray:array obj:model.GD]) {
            newItem = array[self.arrIndex];
            newItem.GD = model.GD;
            newItem.cph = model.cph;
            [newItem.list insertObject:item atIndex:0];
            newItem.count = newItem.list.count;
        }else{
            newItem = [[GroupModel alloc]init];
            newItem.list = [NSMutableArray array];
            newItem.GD = model.GD;
            newItem.cph = model.cph;
            [newItem.list insertObject:item atIndex:0];
            newItem.count = newItem.list.count;
            [array insertObject:newItem atIndex:0];
        }
        [model.list removeObject:item];
        if (model.list.count == 0) {
            [self.dataArray removeObjectAtIndex:indexPath.section];
        }
        model.count = model.list.count;
    }];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [CommUtil saveData:self.dataArray andSaveFileName:[NSString stringWithFormat:@"NoFind%@",[CommUtil readDataWithFileName:@"userName"]]];
        [CommUtil saveData:array andSaveFileName:[NSString stringWithFormat:@"Download%@",[CommUtil readDataWithFileName:@"userName"]]];
    });
    [self right2];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
