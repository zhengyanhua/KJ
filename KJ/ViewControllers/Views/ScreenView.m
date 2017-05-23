//
//  ScreenView.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/26.
//  Copyright © 2516年 iOSDeveloper. All rights reserved.
//

#import "ScreenView.h"

@implementation ScreenView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setDateFormat:@"YYYY-MM-dd"];
        [self addSubview:self.labBah];
        [self addSubview:self.textBah];
        [self addSubview:self.labName];
        [self addSubview:self.textName];
        [self addSubview:self.labDate];
        [self addSubview:self.btnStart];
        [self addSubview:self.labLine];
        [self addSubview:self.btnStop];
        [self addSubview:self.btnReset];
        [self addSubview:self.btnSelect];
        [self addSubview:self.labLine1];
        self.height = self.labLine1.bottom;
    }
    return self;
}
- (UILabel *)labBah{
    if (!_labBah) {
        _labBah = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 25)];
        _labBah.font = [UIFont systemFontOfSize:13];
        _labBah.textAlignment = NSTextAlignmentLeft;
        _labBah.text = @"报案号";
    }
    return _labBah;
}
- (UITextField *)textBah{
    if (!_textBah) {
        _textBah = [[UITextField alloc]initWithFrame:CGRectMake(self.labBah.right + 10, 10, DeviceSize.width - self.labBah.right - 25, 25)];
        _textBah.delegate = self;
        _textBah.font = [UIFont systemFontOfSize:13];
        _textBah.borderStyle = UITextBorderStyleLine;
    }
    return _textBah;
}

- (UILabel *)labName{
    if (!_labName) {
        _labName = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labBah.bottom + 10, 70, 25)];
        _labName.font = [UIFont systemFontOfSize:13];
        _labName.textAlignment = NSTextAlignmentLeft;
        _labName.text = @"车牌号";
    }
    return _labName;
}
- (UITextField *)textName{
    if (!_textName) {
        _textName = [[UITextField alloc]initWithFrame:CGRectMake(self.labName.right + 10, self.labBah.bottom + 10, DeviceSize.width - self.labName.right - 25, 25)];
        _textName.font = [UIFont systemFontOfSize:13];
        _textName.borderStyle = UITextBorderStyleLine;
        _textName.delegate = self;
    }
    return _textName;
}
- (UILabel *)labDate{
    if (!_labDate) {
        _labDate = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labName.bottom + 10, 70, 25)];
        _labDate.font = [UIFont systemFontOfSize:13];
        _labDate.textAlignment = NSTextAlignmentLeft;
        _labDate.text = @"创建时间";
    }
    return _labDate;
}
- (UIButton *)btnStart{
    if (!_btnStart) {
        _btnStart = [[UIButton alloc]initWithFrame:CGRectMake(self.labDate.right + 10,self.labDate.top, (DeviceSize.width - self.labDate.right - 10 - 44)/2, 25)];
        _btnStart.titleLabel.font = [UIFont systemFontOfSize:13];
        _btnStart.backgroundColor = [UIColor clearColor];
        [_btnStart addTarget:self action:@selector(btnStartClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnStart setTitle:[self.formatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
        [_btnStart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _btnStart;
}
- (void)btnStartClick{
    if (self.btnStartBlock) {
        self.btnStartBlock();
    }
}
- (UILabel *)labLine{
    if (!_labLine) {
        _labLine = [[UILabel alloc]initWithFrame:CGRectMake(self.btnStart.right + 10, self.btnStart.top + (25 - 0.5)/2, 8, 0.5)];
        _labLine.backgroundColor = [UIColor grayColor];
    }
    return _labLine;
}
- (UIButton *)btnStop{
    if (!_btnStop) {
        _btnStop = [[UIButton alloc]initWithFrame:CGRectMake(self.labLine.right + 10,self.btnStart.top, (DeviceSize.width - self.labDate.right - 10 - 44)/2, 25)];
        _btnStop.titleLabel.font = [UIFont systemFontOfSize:13];
        _btnStop.backgroundColor = [UIColor clearColor];
        [_btnStop addTarget:self action:@selector(btnStopClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnStop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnStop setTitle:[self.formatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    }
    return _btnStop;
}
- (void)btnStopClick{
    if (self.btnStopBlock) {
        self.btnStopBlock();
    }
}
- (UIButton *)btnReset{
    if (!_btnReset) {
        _btnReset = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnReset.frame = CGRectMake(10, self.labDate.bottom + 10, (DeviceSize.width - 30)/2, 30);
        _btnReset.backgroundColor = [UIColor colorWithHEX:0x20c6c6];
        _btnReset.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnReset.layer.cornerRadius = 6.0f;
        _btnReset.layer.masksToBounds = YES;
        [_btnReset setTitle:@"重置" forState:UIControlStateNormal];
        [_btnReset addTarget:self action:@selector(btnResetClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnReset;
}
- (void)btnResetClick{
    if (self.btnResetBlock) {
        self.btnResetBlock();
    }
}
- (UIButton *)btnSelect{
    if (!_btnSelect) {
        _btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSelect.frame = CGRectMake(self.btnReset.right + 10, self.labDate.bottom + 10, (DeviceSize.width - 30)/2, 30);
        _btnSelect.backgroundColor = [UIColor colorWithHEX:0x20c6c6];
        _btnSelect.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnSelect.layer.cornerRadius = 6.0f;
        _btnSelect.layer.masksToBounds = YES;
        [_btnSelect setTitle:@"查询" forState:UIControlStateNormal];
        [_btnSelect addTarget:self action:@selector(btnSelectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSelect;
}
- (void)btnSelectClick{
    if (self.btnSelectBlock) {
        self.btnSelectBlock();
    }
}
- (UILabel *)labLine1{
    if (!_labLine1) {
        _labLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.btnSelect.bottom + 10, DeviceSize.width, 0.5)];
        _labLine1.backgroundColor = [UIColor grayColor];
    }
    return _labLine1;
}
- (void)configWithDict:(NSDictionary *)dict{

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
