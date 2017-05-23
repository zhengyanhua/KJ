//
//  SelectViewController.m
//  KJ
//
//  Created by iOSDeveloper on 16/9/8.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "SelectViewController.h"
#import "NewQRReaderViewController.h"
#import "SeclectCell.h"
#import "PhotoViewController.h"
#import "SelectModel.h"

@interface SelectViewController ()
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSMutableArray * selectArray;
@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeight = 185.f;
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItemExtension leftBackButtonItem:@selector(backAciton) andTarget:self],[UIBarButtonItemExtension leftTitleItem:@"查询配件"]];
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItemExtension rightButtonItem:@selector(right1) andTarget:self andButtonTitle:@"手动输入"],[UIBarButtonItemExtension rightButtonItem:@selector(right2) andTarget:self andButtonTitle:@"扫描"]];

    self.tableView.top = 0;
    self.tableView.height = DeviceSize.height ;
    self.selectArray = [NSMutableArray array];

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
    WeakSelf(SelectViewController);
    [nvc setDidFinishBlock:^(NSString *string) {
        [weakSelf didFinishedReadingQR:string];
        NSLog(@"---->%@",string);
    }];
    [self.navigationController pushViewController:nvc animated:YES];
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
    SeclectCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[SeclectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    SelectModel * item = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cellHeight = [cell configWithModel:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (void)getNetWorkappNo:(NSString *)string{
    WeakSelf(SelectViewController);
    [self showHudWaitingView:WaitPrompt];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:[CommUtil readDataWithFileName:@"userName"] forKey:@"username"];
    [dict setObject:string forKey:@"appNo"];
    [[NetWorkManager shareNetWork]selectQR:dict andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if (response.responseCode == 641) {
            [weakSelf.dataArray removeAllObjects];
            for (NSDictionary * dic in response.dataDic[@"list"]) {
                SelectModel * model = [response thParseDataFromDic:dic andModel:[SelectModel class]];
                if ([model.barCode componentsSeparatedByString:@","].count == 5) {
                    model.qr = [[model.barCode componentsSeparatedByString:@","] lastObject];
                }else{
                    model.qr = @"";
                }
                [weakSelf.dataArray addObject:model];
            }
            
            [weakSelf.tableView reloadData];
            [weakSelf showHudAuto:@"查询成功" andDuration:@"2"];
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
    [self getNetWorkappNo:string];
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
