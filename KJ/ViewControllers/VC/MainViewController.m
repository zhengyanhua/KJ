//
//  MainViewController.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/25.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MainViewController.h"
#import "WaitListViewController.h"
#import "NoFindViewController.h"
#import "FinishViewController.h"
#import "DownloadListModel.h"
#import "GroupModel.h"
#import "SelectViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) UILabel * labTitle;
@property (nonatomic, strong) UIButton * btnWaiting;
@property (nonatomic, strong) UILabel * labTitle1;
@property (nonatomic, strong) UIButton * btnAlready;
@property (nonatomic, strong) UILabel * labTitle2;
@property (nonatomic, strong) UIButton * btnNofind;
@property (nonatomic, strong) UIButton * btnSelect;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger index;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 0;
    self.title = @"损益物资平台";
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItemExtension leftBackButtonItem:@selector(leftAction) andTarget:self]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andImageName:@"right"];
    [self.view addSubview:self.btnWaiting];
    [self.btnWaiting addSubview:self.labTitle];
    [self.view addSubview:self.btnAlready];
    [self.btnAlready addSubview:self.labTitle1];
    [self.view addSubview:self.btnNofind];
    [self.btnNofind addSubview:self.labTitle2];
    [self.view addSubview:self.btnSelect];
    [self rightAction];
}

- (void)leftAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightAction{
    WeakSelf(MainViewController);
    [self showHudWaitingView:WaitPrompt];
    self.dataArray = [NSMutableArray arrayWithArray:[CommUtil readDataWithFileName:[NSString stringWithFormat:@"All%@",[CommUtil readDataWithFileName:@"userName"]]]];
    [[NetWorkManager shareNetWork]getDownloadInfoCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if (response.responseCode == 210) {
            
            for (NSDictionary * dict in response.dataDic[@"list"]) {
                DownloadListModel * model = [response thParseDataFromDic:dict andModel:[DownloadListModel class]];
                model.zch = @"";
                model.ghdh = @"";
                model.cph = @"";
                model.sth = @"";
                NSDateFormatter *formatter = [[NSDateFormatter  alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate * date = [NSDate date];
                model.createDate = [formatter stringFromDate:date];
                if ([[model.barCode componentsSeparatedByString:@","] count] == 5) {
                    model.zch = [model.barCode componentsSeparatedByString:@","][0];
                    model.ghdh = [model.barCode componentsSeparatedByString:@","][2];
                    model.cph = [model.barCode componentsSeparatedByString:@","][3];
                    model.sth = [model.barCode componentsSeparatedByString:@","][4];
                    
                }
                if (![self RemovalOfDuplicationModel:model]) {
                    [weakSelf.dataArray insertObject:model atIndex:0];
                }
            }
            
            [self clearAlreadyInfo];
            NSMutableArray * arr = [NSMutableArray array];
            arr = [weakSelf judgeArray:weakSelf.dataArray noArr:[CommUtil readDataWithFileName:[NSString stringWithFormat:@"NoFind%@",[CommUtil readDataWithFileName:@"userName"]]] sArr:[CommUtil readDataWithFileName:[NSString stringWithFormat:@"Scanning%@",[CommUtil readDataWithFileName:@"userName"]]]];
            
            arr = [NSMutableArray arrayWithArray:arr];
            [weakSelf getGroupInfoArray:arr];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [CommUtil saveData:arr andSaveFileName:[NSString stringWithFormat:@"All%@",[CommUtil readDataWithFileName:@"userName"]]];
            });
            
            if ([response.dataDic[@"list"] count] == 0) {
                [CommUtil deleteUserDefaultsDataWithUserDefaultName:[NSString stringWithFormat:@"NoFind%@",[CommUtil readDataWithFileName:@"userName"]]];
                [CommUtil deleteUserDefaultsDataWithUserDefaultName:[NSString stringWithFormat:@"Scanning%@",[CommUtil readDataWithFileName:@"userName"]]];
            }
            [weakSelf showHudAuto:@"数据同步成功" andDuration:@"2"];
        }else{
            [weakSelf showHudAuto:response.message];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf showHudAuto:InternetFailerPrompt];
    }];
}
- (NSMutableArray *)getGroupInfoArray:(NSMutableArray *)array{
    NSMutableArray * ar = [super getGroupInfoArray:array];
    [CommUtil saveData:ar andSaveFileName:[NSString stringWithFormat:@"Download%@",[CommUtil readDataWithFileName:@"userName"]]];
    return ar;
}
#pragma mark ------
#pragma mark 接收新数据

- (BOOL)RemovalOfDuplicationModel:(DownloadListModel *)item{
    for (DownloadListModel * model in self.dataArray) {
        if ([model.bah isEqualToString:item.bah]&&[model.cxmc isEqualToString:item.cxmc]&&[model.ljmc isEqualToString:item.ljmc]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark ------
#pragma mark 判断未找到数据
- (NSMutableArray *)judgeArray:(NSMutableArray *)array noArr:(NSMutableArray *)noArr sArr:(NSMutableArray *)sArr{
    NSMutableArray * newAr = [NSMutableArray array];
    for (GroupModel * model in noArr) {
        for (DownloadListModel * item  in model.list) {
            [newAr addObject:item];
        }
    }
    NSPredicate * noFilterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",newAr];
    NSArray * filter = [array filteredArrayUsingPredicate:noFilterPredicate];
    NSPredicate * sFilterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",sArr];
    NSArray * downloadArray = [filter filteredArrayUsingPredicate:sFilterPredicate];
    return [NSMutableArray arrayWithArray:downloadArray];
}
#pragma mark ------
#pragma mark 清除 已经提交数据
- (void)clearAlreadyInfo{
//    NSMutableArray * allArr = [NSMutableArray arrayWithArray:[CommUtil readDataWithFileName:[NSString stringWithFormat:@"All%@",[CommUtil readDataWithFileName:@"userName"]]]];
    NSMutableArray * allArr = [NSMutableArray arrayWithArray:self.dataArray];
    
    NSMutableArray * noFindArr = [NSMutableArray array];
    for (DownloadListModel * item in [NSMutableArray arrayWithArray:[CommUtil readDataWithFileName:[NSString stringWithFormat:@"NoFind%@",[CommUtil readDataWithFileName:@"userName"]]]]) {
        [noFindArr addObject:item];
    }
    
    NSMutableArray * scanningArr = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"Scanning%@",[CommUtil readDataWithFileName:@"userName"]]];
    
    NSPredicate * noFilterPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)",allArr];
    NSArray * filter = [noFindArr filteredArrayUsingPredicate:noFilterPredicate];
    [CommUtil saveData:[NSMutableArray arrayWithArray:filter] andSaveFileName:[NSString stringWithFormat:@"NoFind%@",[CommUtil readDataWithFileName:@"userName"]]];
    
    NSPredicate * sFilterPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)",allArr];
    NSArray * downloadArray = [scanningArr filteredArrayUsingPredicate:sFilterPredicate];
    [CommUtil saveData:[NSMutableArray arrayWithArray:downloadArray] andSaveFileName:[NSString stringWithFormat:@"Scanning%@",[CommUtil readDataWithFileName:@"userName"]]];
    
    
}
- (UIButton *)btnWaiting{
    if (!_btnWaiting) {
        _btnWaiting = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnWaiting.frame = CGRectMake(10, 64 + 10, (DeviceSize.width - 30)/2 , (DeviceSize.width - 30)/2);
        _btnWaiting.backgroundColor = [UIColor colorWithRed:221/255.0f green:85/255.0f blue:57/255.0f alpha:1];
        [_btnWaiting setImage:[UIImage imageNamed:@"calculator"] forState:UIControlStateNormal];
        [_btnWaiting addTarget:self action:@selector(btnWaitingClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnWaiting;
}
- (void)btnWaitingClick{
    WaitListViewController * wvc = [[WaitListViewController alloc]init];
    [self.navigationController pushViewController:wvc animated:YES];
}
- (UILabel *)labTitle{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 12)];
        _labTitle.textColor = [UIColor whiteColor];
        _labTitle.text = @"待收货";
        _labTitle.font = [UIFont systemFontOfSize:12];
    }
    return _labTitle;
}
- (UIButton *)btnAlready{
    if (!_btnAlready) {
        _btnAlready = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAlready.frame = CGRectMake(self.btnWaiting.right + 10, 64 + 10, (DeviceSize.width - 30)/2 , ((DeviceSize.width - 30)/2 - 10)/2);
        [_btnAlready setImage:[UIImage imageNamed:@"notepad"] forState:UIControlStateNormal];
        _btnAlready.backgroundColor = [UIColor colorWithRed:179/255.0f green:84/255.0f blue:164/255.0f alpha:1];
        [_btnAlready addTarget:self action:@selector(btnAlreadyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAlready;
}
- (void)btnAlreadyClick{
    FinishViewController * fvc = [[FinishViewController alloc]init];
    [self.navigationController pushViewController:fvc animated:YES];
}
- (UILabel *)labTitle1{
    if (!_labTitle1) {
        _labTitle1 = [[UILabel alloc]initWithFrame:CGRectMake(self.btnAlready.width - 55, self.btnAlready.height - 17, 50, 12)];
        _labTitle1.textColor = [UIColor whiteColor];
        _labTitle1.text = @"已扫描";
        _labTitle1.textAlignment = NSTextAlignmentRight;
        _labTitle1.font = [UIFont systemFontOfSize:12];
    }
    return _labTitle1;
}
- (UIButton *)btnNofind{
    if (!_btnNofind) {
        _btnNofind = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNofind.frame = CGRectMake(self.btnWaiting.right + 10, self.btnAlready.bottom  + 10, (DeviceSize.width - 30)/2 , ((DeviceSize.width - 30)/2 - 10)/2);
        [_btnNofind setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
        _btnNofind.backgroundColor = [UIColor colorWithRed:78/255.0f green:218/255.0f blue:253/255.0f alpha:1];
        [_btnNofind addTarget:self action:@selector(btnNofindClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNofind;
}
- (void)btnNofindClick{
    NoFindViewController * fvc = [[NoFindViewController alloc]init];
    [self.navigationController pushViewController:fvc animated:YES];
}
- (UILabel *)labTitle2{
    if (!_labTitle2) {
        _labTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(self.btnNofind.width - 55, self.btnNofind.height - 17, 50, 12)];
        _labTitle2.textColor = [UIColor whiteColor];
        _labTitle2.text = @"未找到";
        _labTitle2.textAlignment = NSTextAlignmentRight;
        _labTitle2.font = [UIFont systemFontOfSize:12];
    }
    return _labTitle2;
}
- (UIButton *)btnSelect{
    if (!_btnSelect) {
        _btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSelect.frame = CGRectMake(10, self.btnWaiting.bottom + 10, DeviceSize.width - 20, ((DeviceSize.width - 30)/2 - 80)/2);
        _btnSelect.backgroundColor = [UIColor whiteColor];
        [_btnSelect setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_btnSelect setTitle:@"      查询配件" forState:UIControlStateNormal];
        _btnSelect.layer.borderColor = [UIColor redColor].CGColor;
        _btnSelect.layer.borderWidth = 2.0f;
        [_btnSelect setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnSelect addTarget:self action:@selector(btnSelectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSelect;
}
- (void)btnSelectClick{
    SelectViewController * svc = [[SelectViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
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
