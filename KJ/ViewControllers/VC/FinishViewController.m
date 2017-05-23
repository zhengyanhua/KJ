//
//  FinishViewController.m
//  KJ
//
//  Created by iOSDeveloper on 16/5/3.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "FinishViewController.h"
#import "NewQRReaderViewController.h"
#import "GroupModel.h"
#import "DownloadListModel.h"
#import "ListTableViewCell.h"
#import "PhotoViewController.h"

@interface FinishViewController ()
@property (nonatomic, strong) UIView * toolView;
@property (nonatomic, strong) UIButton * btnTool;
@property (nonatomic, strong) UILabel *labLine;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSMutableArray * selectArray;
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, strong) UILabel * labTitle;
@end

@implementation FinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeight = 185.f;
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItemExtension leftBackButtonItem:@selector(backAciton) andTarget:self],[UIBarButtonItemExtension leftTitleItem:@"已扫描"]];
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItemExtension rightButtonItem:@selector(right1) andTarget:self andButtonTitle:@"手动输入"],[UIBarButtonItemExtension rightButtonItem:@selector(right2) andTarget:self andButtonTitle:@"扫描"]];
    [self.view addSubview:self.headView];
    [self.headView addSubview:self.labTitle];
    self.tableView.top = 40;
    self.tableView.height = DeviceSize.height - 40 - 49;
    [self.view addSubview:self.toolView];
    [self.toolView addSubview:self.labLine];
    [self.toolView addSubview:self.btnTool];
    self.selectArray = [NSMutableArray array];
    self.dataArray = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"Scanning%@",[CommUtil readDataWithFileName:@"userName"]]];
    self.labTitle.text = [NSString stringWithFormat:@"已扫描零件总数：%ld",(long)self.dataArray.count];
    // Do any additional setup after loading the view.
}
- (void)backAciton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)right1{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"请输入二维码"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        UITextField *tf = [alertView textFieldAtIndex:0];
        if (![tf.text isEqualToString:@""]) {
            [self didFinishedReadingQR:tf.text];
        }
    }
}
- (void)right2{
    NewQRReaderViewController * nvc = [[NewQRReaderViewController alloc]init];
    WeakSelf(FinishViewController);
    [nvc setDidFinishBlock:^(NSString *string) {
        [weakSelf didFinishedReadingQR:string];
        NSLog(@"---->%@",string);
    }];
    [self.navigationController pushViewController:nvc animated:YES];
}
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, DeviceSize.width, 40)];
        _headView.backgroundColor = [UIColor grayColor];
    }
    return _headView;
}
- (UILabel *)labTitle{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, (40 - 20)/2, DeviceSize.width - 20, 20)];
        _labTitle.font = [UIFont systemFontOfSize:15];
        _labTitle.text = @"已扫描零件总数：0";
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}

- (UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceSize.height - 49, DeviceSize.width, 49)];
        _toolView.backgroundColor = [UIColor whiteColor];
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
- (UIButton *)btnTool{
    if (!_btnTool) {
        _btnTool = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTool.frame = CGRectMake(15, (49 - 40)/2, DeviceSize.width - 30, 40);
        _btnTool.backgroundColor = [UIColor colorWithHEX:0x20c6c6];
        [_btnTool setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnTool setTitle:[NSString stringWithFormat:@"上传数据"] forState:UIControlStateNormal];
        _btnTool.layer.cornerRadius = 6.f;
        [_btnTool addTarget:self action:@selector(btnToolClick) forControlEvents:UIControlEventTouchUpInside];
        _btnTool.layer.masksToBounds = YES;
    }
    return _btnTool;
}
#pragma mark ------
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellName = @"cellId";
    ListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    DownloadListModel * item = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cellHeight = [cell configWithModel:item row:9999999];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadListModel * item = self.dataArray[indexPath.row];
    PhotoViewController * pvc = [[PhotoViewController alloc]init];
    pvc.id = item.id;
    pvc.ljbzmc = item.ljmc;
    pvc.cph = item.cph;
    pvc.ghdh = item.ghdh;
    [self.navigationController pushViewController:pvc animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    [self getNetWork];
}
- (void)getNetWork{
    WeakSelf(FinishViewController);
    [self showHudWaitingView:WaitPrompt];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * arr = [NSMutableArray array];
    NSMutableArray * goodAr = [NSMutableArray array];
    for (DownloadListModel * item in self.dataArray) {
        [arr addObject:item.id];
        [goodAr addObject:item.ghdh];
    }
    [dict setObject:arr forKey:@"ids"];
    [dict setObject:goodAr forKey:@"goodNos"];
    [dict setObject:[CommUtil readDataWithFileName:@"userName"] forKey:@"username"];
    [[NetWorkManager shareNetWork]getUploadInfoDict:dict andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if (response.responseCode == 310) {
            [weakSelf.dataArray removeAllObjects];
            [CommUtil deleteUserDefaultsDataWithUserDefaultName:[NSString stringWithFormat:@"Scanning%@",[CommUtil readDataWithFileName:@"userName"]]];
            weakSelf.labTitle.text = [NSString stringWithFormat:@"已扫描零件总数：0"];
            [weakSelf.tableView reloadData];
            [weakSelf showHudAuto:@"上传成功" andDuration:@"2"];
        }else{
            [weakSelf showHudAuto:response.message andDuration:@"2"];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf showHudAuto:InternetFailerPrompt];
    }];
}
#pragma mark ------
#pragma mark  扫描二维码成功
- (void)didFinishedReadingQR:(NSString *)string{
    NSMutableArray * arr = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"Download%@",[CommUtil readDataWithFileName:@"userName"]]];
    NSMutableArray * newArr = [NSMutableArray array];
    for (GroupModel * model in arr) {
        for (DownloadListModel * item in model.list) {
            [newArr addObject:item];
        }
    }
    NSMutableArray * noFindArr = [NSMutableArray array];
    for (DownloadListModel * item in newArr) {
        if ([item.sth isEqualToString:string]) {
            if (![self RemovalOfDuplicationModel:item]) {
                [self.dataArray insertObject:item atIndex:0];
            }
        }else{
            [noFindArr addObject:item];
        }
    }
    if (![self judgeIsScanning:string] && newArr.count == noFindArr.count) {
        [self showHudAuto:@"找不到此零件" andDuration:@"2"];
    }else if([self judgeIsScanning:string] && newArr.count == noFindArr.count){
        [self showHudAuto:@"已扫描此零件" andDuration:@"2"];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [CommUtil saveData:self.dataArray andSaveFileName:[NSString stringWithFormat:@"Scanning%@",[CommUtil readDataWithFileName:@"userName"]]];
        NSMutableArray * array = [NSMutableArray array];
        array = [self judgeArray:[CommUtil readDataWithFileName:[NSString stringWithFormat:@"Download%@",[CommUtil readDataWithFileName:@"userName"]]] sArr:[CommUtil readDataWithFileName:[NSString stringWithFormat:@"Scanning%@",[CommUtil readDataWithFileName:@"userName"]]]];
        array = [NSMutableArray arrayWithArray:array];
        [self getGroupInfoArray:array];
         dispatch_async(dispatch_get_main_queue(), ^{
             self.labTitle.text = [NSString stringWithFormat:@"已扫描零件总数：%ld",(long)self.dataArray.count];
             [self.tableView reloadData];
         });
    });
}
- (BOOL)judgeIsScanning:(NSString *)string{
    for (DownloadListModel * item in self.dataArray) {
        if ([item.sth isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray *)getGroupInfoArray:(NSMutableArray *)array{
    NSMutableArray * ar = [super getGroupInfoArray:array];
    [CommUtil saveData:ar andSaveFileName:[NSString stringWithFormat:@"Download%@",[CommUtil readDataWithFileName:@"userName"]]];
    return ar;
}
#pragma mark ------
#pragma mark 判断未找到数据
- (NSMutableArray *)judgeArray:(NSMutableArray *)array  sArr:(NSMutableArray *)sArr{
    NSMutableArray * dArr = [NSMutableArray array];
    for (GroupModel * model in array) {
        for (DownloadListModel * item in model.list) {
            [dArr addObject:item];
        }
    }
    NSPredicate * noFilterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",sArr];
    NSArray * filter = [dArr filteredArrayUsingPredicate:noFilterPredicate];
    return [NSMutableArray arrayWithArray:filter];
}
- (BOOL)RemovalOfDuplicationModel:(DownloadListModel *)item{
    for (DownloadListModel * model  in self.dataArray) {
        if ([model.barCode isEqualToString:item.barCode]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark ------
#pragma mark  侧滑删除

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 1.删除数据
        [self deleteInfoIndex:indexPath];
    }
}
- (void)deleteInfoIndex:(NSIndexPath *)indexPath{
    NSMutableArray * arr = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"Download%@",[CommUtil readDataWithFileName:@"userName"]]];
    NSMutableArray * newArr = [NSMutableArray array];
    for (GroupModel * model in arr) {
        for (DownloadListModel * item in model.list) {
            [newArr addObject:item];
        }
    }
    [newArr addObject:self.dataArray[indexPath.row]];
    [self getGroupInfoArray:newArr];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [CommUtil saveData:self.dataArray andSaveFileName:[NSString stringWithFormat:@"Scanning%@",[CommUtil readDataWithFileName:@"userName"]]];
    self.labTitle.text = [NSString stringWithFormat:@"已扫描零件总数：%ld",(long)self.dataArray.count];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"还原";
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
