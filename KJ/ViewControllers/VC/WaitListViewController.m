//
//  WaitListViewController.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/25.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "WaitListViewController.h"
#import "HeadView.h"
#import "ListTableViewCell.h"
#import "ScreenView.h"
#import "BirthdayViewController.h"
#import "GroupModel.h"
#import "DownloadListModel.h"

@interface WaitListViewController ()
@property (nonatomic, strong) HeadView * headView;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) ScreenView * screenView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIView * toolView;
@property (nonatomic, strong) UIButton * btnTool;
@property (nonatomic, strong) UILabel *labLine;
@property (nonatomic, strong) NSMutableArray * selectArray;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSMutableArray * noSelectArr;
@property (nonatomic, strong) UIWebView *phoneCallWebView;
@end

@implementation WaitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeight = 185.f;
    self.isOpen = YES;
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"YYYY-MM-dd"];
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItemExtension leftBackButtonItem:@selector(backAciton) andTarget:self],[UIBarButtonItemExtension leftTitleItem:@"待收货"]];
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItemExtension rightButtonItem:@selector(right1) andTarget:self andButtonTitle:@"筛选"],[UIBarButtonItemExtension rightButtonItem:@selector(right2) andTarget:self andButtonTitle:@"选择"]];
    self.noSelectArr = [NSMutableArray array];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.screenView];
    self.tableView.top = self.headView.height;
    self.tableView.height = DeviceSize.height - 40;
    [self.view addSubview:self.toolView];
    [self.toolView addSubview:self.labLine];
    [self.toolView addSubview:self.btnTool];
    self.selectArray = [NSMutableArray array];
    [self.view addSubview:self.phoneCallWebView];
    self.dataArray = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"Download%@",[CommUtil readDataWithFileName:@"userName"]]];
    NSInteger sum = 0;
    NSInteger all = 0;
    
    for (GroupModel * item in self.dataArray) {
        sum += item.count;
        for (DownloadListModel * model in item.list) {
            if ([BaseTool compareOneDay:[self.formatter stringFromDate:[NSDate date]] withAnotherDay:model.createDate] == 1) {
                all += 1;
            }
        }
    }
    NSMutableDictionary * dict  = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)sum] forKey:@"sum"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)all] forKey:@"all"];
    [self.headView configWithModel:dict];
    // Do any additional setup after loading the view.
}
- (void)backAciton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)right1{
    [self.view endEditing:YES];
    [self.tableView setEditing:NO animated:YES];
    [self.selectArray removeAllObjects];
    [self.btnTool setTitle:[NSString stringWithFormat:@"(%ld)个零件未找到",(unsigned long)self.selectArray.count] forState:UIControlStateNormal];
    if (self.tableView.editing == YES) {
        self.toolView.hidden = NO;
        self.tableView.height = DeviceSize.height - 40 - 49;
    }else{
        self.tableView.height = DeviceSize.height - 40 ;
        self.toolView.hidden = YES;
    }
    WeakSelf(WaitListViewController);
    [UIView animateWithDuration:0.4 animations:^{
        if (weakSelf.isOpen) {
            weakSelf.screenView.top = 64;
        }else{
            weakSelf.screenView.top = -225;
        }
    } completion:^(BOOL finished) {
        if (weakSelf.isOpen) {
            weakSelf.isOpen = NO;
        }else{
            weakSelf.isOpen = YES;
        }
    }];
}

- (void)right2{
    WeakSelf(WaitListViewController);
    if (self.screenView.top != -225) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.screenView.top = -225;
        } completion:^(BOOL finished) {
            if (weakSelf.isOpen) {
                weakSelf.isOpen = NO;
            }else{
                weakSelf.isOpen = YES;
            }
        }];
    }
    [self.view endEditing:YES];
    
    [self.tableView setEditing:(!self.tableView.editing) animated:YES];
    [self.selectArray removeAllObjects];
    [self.btnTool setTitle:[NSString stringWithFormat:@"(%ld)个零件未找到",(unsigned long)self.selectArray.count] forState:UIControlStateNormal];
    if (self.tableView.editing == YES) {
        self.toolView.hidden = NO;
        self.tableView.height = DeviceSize.height - 40 - 49;
    }else{
        self.tableView.height = DeviceSize.height - 40 ;
        self.toolView.hidden = YES;
    }
}

- (HeadView *)headView{
    if (!_headView) {
        _headView = [[HeadView alloc]initWithFrame:CGRectMake(0, 64, DeviceSize.width , 40)];
        _headView.backgroundColor = self.view.backgroundColor;
       
    }
    return _headView;
}
- (UIWebView *)phoneCallWebView{
    if (!_phoneCallWebView) {
        _phoneCallWebView  = [[UIWebView alloc]init];
    }
    return _phoneCallWebView;
}
- (ScreenView *)screenView{
    if (!_screenView) {
        _screenView = [[ScreenView alloc]initWithFrame:CGRectMake(0, 0 - 225, DeviceSize.width, 225)];
        _screenView.backgroundColor = self.view.backgroundColor;
        WeakSelf(WaitListViewController);
        BirthdayViewController * bvc = [[BirthdayViewController alloc]init];
        [_screenView  setBtnStartBlock:^{
            [weakSelf.screenView.textBah resignFirstResponder];
            [weakSelf.screenView.textName resignFirstResponder];
            bvc.type = 1;
            [weakSelf.navigationController pushViewController:bvc animated:YES];
        }];
        [_screenView setBtnStopBlock:^{
            [weakSelf.screenView.textBah resignFirstResponder];
            [weakSelf.screenView.textName resignFirstResponder];
            bvc.type = 2;
            [weakSelf.navigationController pushViewController:bvc animated:YES];
        }];
        [bvc setBirthdayBlock:^(NSString *date,NSInteger i) {
            
            if (i == 1) {
                [weakSelf.screenView.btnStart setTitle:date forState:UIControlStateNormal];
                if ([BaseTool compareOneDay:weakSelf.screenView.btnStart.titleLabel.text withAnotherDay:weakSelf.screenView.btnStop.titleLabel.text] == 1) {
                    [weakSelf.screenView.btnStop setTitle:date forState:UIControlStateNormal];
                }
            }else{
                [weakSelf.screenView.btnStop setTitle:date forState:UIControlStateNormal];
                if ([BaseTool compareOneDay:weakSelf.screenView.btnStart.titleLabel.text withAnotherDay:weakSelf.screenView.btnStop.titleLabel.text] == 1) {
                    [weakSelf.screenView.btnStart setTitle:date forState:UIControlStateNormal];
                }
            }
        }];
        [_screenView setBtnResetBlock:^{
            weakSelf.screenView.textBah.text = @"";
            weakSelf.screenView.textName.text = @"";
            [weakSelf.screenView.textBah resignFirstResponder];
            [weakSelf.screenView.textName resignFirstResponder];
            weakSelf.dataArray = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"Download%@",[CommUtil readDataWithFileName:@"userName"]]];
            [weakSelf.noSelectArr removeAllObjects];
            [weakSelf.tableView reloadData];
        }];
        [_screenView setBtnSelectBlock:^{
            [weakSelf.screenView.textBah resignFirstResponder];
            [weakSelf.screenView.textName resignFirstResponder];
            if ([weakSelf.screenView.textBah.text isEqualToString:@""]&&[weakSelf.screenView.textName.text isEqualToString:@""]) {
                [weakSelf showHudAuto:@"请输入报案号或者车牌号码"];
            }else{
                [weakSelf.noSelectArr removeAllObjects];
                NSMutableArray * arr = [NSMutableArray array];
                for (GroupModel * model in [CommUtil readDataWithFileName:[NSString stringWithFormat:@"Download%@",[CommUtil readDataWithFileName:@"userName"]]]) {
                    for (DownloadListModel * item  in model.list) {
                        [arr addObject:item];
                    }
                }
                NSMutableArray * selectArr = [NSMutableArray array];
                for (DownloadListModel * model in arr) {
                    if ([BaseTool compareOneDay:[weakSelf.formatter stringFromDate:[NSDate date]] withAnotherDay:weakSelf.screenView.btnStart.titleLabel.text]<= 0 && [BaseTool compareOneDay:[weakSelf.formatter stringFromDate:[NSDate date]] withAnotherDay:weakSelf.screenView.btnStop.titleLabel.text] >= 0) {
                        NSRange bahRange = [model.bah rangeOfString:weakSelf.screenView.textBah.text];
                        NSRange nameRange = [model.cph rangeOfString:weakSelf.screenView.textName.text];
                        if (![weakSelf.screenView.textName.text isEqualToString:@""]&&![weakSelf.screenView.textBah.text isEqualToString:@""]) {
                            if (nameRange.location != NSNotFound &&bahRange.location != NSNotFound) {
                                [selectArr addObject:model];
                            }else{
                                [weakSelf.noSelectArr addObject:model];
                            }
                        }else if(![weakSelf.screenView.textName.text isEqualToString:@""]&&[weakSelf.screenView.textBah.text isEqualToString:@""]){
                            if (nameRange.location != NSNotFound) {
                                [selectArr addObject:model];
                            }else{
                                [weakSelf.noSelectArr addObject:model];
                            }
                        }else if ([weakSelf.screenView.textName.text isEqualToString:@""]&&![weakSelf.screenView.textBah.text isEqualToString:@""]){
                            if (bahRange.location != NSNotFound) {
                                [selectArr addObject:model];
                            }else{
                                [weakSelf.noSelectArr addObject:model];
                            }
                        }
                    }
                }
                 weakSelf.dataArray = [weakSelf getGroupInfoArray:selectArr];
                [weakSelf.tableView reloadData];
            }
        }];
    }
    return _screenView;
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
- (UIButton *)btnTool{
    if (!_btnTool) {
        _btnTool = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTool.frame = CGRectMake(15, (49 - 40)/2, DeviceSize.width - 30, 40);
        _btnTool.backgroundColor = [UIColor colorWithHEX:0x20c6c6];
        [_btnTool setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnTool setTitle:[NSString stringWithFormat:@"(0)个零件未找到"] forState:UIControlStateNormal];
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
    WeakSelf(WaitListViewController);

    [cell setPlayPhone:^(NSString * phoneStr){
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneStr]];
        if (!weakSelf.phoneCallWebView ) {
            weakSelf.phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [weakSelf.phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }];
    DownloadListModel * item = model.list[indexPath.row];
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
        [self.btnTool setTitle:[NSString stringWithFormat:@"(%ld)个零件未找到",(unsigned long)self.selectArray.count] forState:UIControlStateNormal];
    }else{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing == YES) {
        [self.selectArray removeObject:indexPath];
        [self.btnTool setTitle:[NSString stringWithFormat:@"(%ld)个零件未找到",(unsigned long)self.selectArray.count] forState:UIControlStateNormal];
    }else{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}
#pragma mark ------
#pragma mark scrollerView delegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    WeakSelf(WaitListViewController);
    if (self.screenView.top != -225) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.screenView.top = -225;
        } completion:^(BOOL finished) {
            if (weakSelf.isOpen) {
                weakSelf.isOpen = NO;
            }else{
                weakSelf.isOpen = YES;
            }
        }];
    }
    [self.view endEditing:YES];
}
#pragma mark ------
#pragma mark touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    WeakSelf(WaitListViewController);
    if (self.screenView.top != -225) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.screenView.top = -225;
        } completion:^(BOOL finished) {
            if (weakSelf.isOpen) {
                weakSelf.isOpen = NO;
            }else{
                weakSelf.isOpen = YES;
            }
        }];
    }
}
- (void)btnToolClick{
    NSMutableArray * array = [NSMutableArray arrayWithArray:[CommUtil readDataWithFileName:[NSString stringWithFormat:@"NoFind%@",[CommUtil readDataWithFileName:@"userName"]]]];
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
        [CommUtil saveData:array andSaveFileName:[NSString stringWithFormat:@"NoFind%@",[CommUtil readDataWithFileName:@"userName"]]];
        for (GroupModel * neModel in self.dataArray) {
            for (DownloadListModel * neItem in neModel.list) {
                [self.noSelectArr addObject:neItem];
            }
        }
        self.dataArray = [self getGroupInfoArray:self.noSelectArr];
        [CommUtil saveData:self.dataArray andSaveFileName:[NSString stringWithFormat:@"Download%@",[CommUtil readDataWithFileName:@"userName"]]];
    });
    [self right2];
    [self.tableView reloadData];
    NSInteger sum = 0;
    NSInteger all = 0;
    
    for (GroupModel * item in self.dataArray) {
        sum += item.count;
        for (DownloadListModel * model in item.list) {
            if ([BaseTool compareOneDay:[self.formatter stringFromDate:[NSDate date]] withAnotherDay:model.createDate] == 1) {
                all += 1;
            }
        }
    }

    NSMutableDictionary * dict  = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)sum] forKey:@"sum"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)all] forKey:@"all"];
    [self.headView configWithModel:dict];
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
