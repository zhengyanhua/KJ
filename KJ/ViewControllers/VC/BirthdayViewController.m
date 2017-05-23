//
//  BirthdayViewController.m
//  NR
//
//  Created by 范英强 on 15/10/24.
//  Copyright (c) 2015年 范英强. All rights reserved.
//

#import "BirthdayViewController.h"

@interface BirthdayViewController ()
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UILabel *labLine;
@property (nonatomic, copy) NSString * timeStr;
@end

@implementation BirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHEX:0xffffff];
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItemExtension leftBackButtonItem:@selector(backAciton) andTarget:self],[UIBarButtonItemExtension leftTitleItem:@"日期"]];
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.labTime];
    [self.view addSubview:self.datePicker];
    [self.view addSubview:self.labLine];
}

- (void)backAciton{
    if (self.BirthdayBlock) {
        self.BirthdayBlock(self.labTime.text,self.type);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UI

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, DeviceSize.height - 216  - 20, DeviceSize.width, 216)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale = locale;
        //当前时间创建NSDate
        NSDate *localDate = [NSDate date];
        self.datePicker.maximumDate = localDate;
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        NSDateFormatter *formatter = [[NSDateFormatter  alloc] init];
        if (self.dateString.length == 0) {
            [formatter setDateFormat:@"yyyy-MM-dd"];
            _datePicker.date = localDate;
            self.labTime.text = [formatter stringFromDate:localDate];
        }else{
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[self.dateString doubleValue]/1000.0];
            _datePicker.date = nd;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [dateFormat stringFromDate:nd];
            self.labTime.text = dateString;
        }
    }
    return _datePicker;
}

- (void)dateChange:(id)sender{
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSDate  *date = picker.date;
    //转成时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *timeSp = [NSString stringWithFormat:@"%li%@", (long)[date timeIntervalSince1970],@"000"];
    self.labTime.text = [formatter stringFromDate:date];
    self.timeStr = [formatter stringFromDate:date];
//    if (self.BirthdayBlock) {
//        self.BirthdayBlock(timeSp);
//    }
    
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(15, 64 + 52, DeviceSize.width -30, 96/2)];
        _backView.backgroundColor = [UIColor colorWithHEX:0xefefef];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 3;
    }
    return _backView;
}

- (UILabel *)labTime{
    if (!_labTime) {
        _labTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.backView.width, self.backView.height)];
        _labTime.font = [UIFont systemFontOfSize:15];
        _labTime.textColor = [UIColor colorWithHEX:0x77be31];
        _labTime.textAlignment = NSTextAlignmentCenter;
    }
    return _labTime;
}

- (UILabel *)labLine{
    if (!_labLine) {
        _labLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.datePicker.top -1, DeviceSize.width, 1)];
        _labLine.backgroundColor = [UIColor colorWithHEX:0x77be31];
    }
    return _labLine;
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
