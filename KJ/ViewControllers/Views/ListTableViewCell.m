//
//  ListTableViewCell.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/26.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell
- (void)customView{
    [self.contentView addSubview:self.labNum];
    [self.contentView addSubview:self.labAll];
    [self.contentView addSubview:self.labAddress];
    [self.contentView addSubview:self.labAddressText];
    [self.contentView addSubview:self.labSupply];
    [self.contentView addSubview:self.labSupplyText];
    [self.contentView addSubview:self.labBah];
    [self.contentView addSubview:self.labBahText];
    [self.contentView addSubview:self.labCar];
    [self.contentView addSubview:self.labCarText];
    [self.contentView addSubview:self.labName];
    [self.contentView addSubview:self.labNameText];
    [self.contentView addSubview:self.labDate];
    [self.contentView addSubview:self.labDateText];
    
    [self.contentView addSubview:self.btnFollow];
}
- (UILabel *)labNum{
    if (!_labNum) {
        _labNum = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
        _labNum.textAlignment = NSTextAlignmentCenter;
        _labNum.layer.cornerRadius = 15/2.0;
        _labNum.layer.masksToBounds = YES;
        _labNum.textColor = [UIColor whiteColor];
        _labNum.backgroundColor = [UIColor redColor];
        _labNum.font = [UIFont systemFontOfSize:13];
    }
    return _labNum;
}
- (UILabel *)labAll{
    if (!_labAll) {
        _labAll = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labNum.bottom + 5, DeviceSize.width - 20, 15)];
        _labAll.numberOfLines = 0;
        _labAll.font = [UIFont systemFontOfSize:13];
        _labAll.textAlignment = NSTextAlignmentLeft;
    }
    return _labAll;
}
- (UILabel *)labAddress{
    if (!_labAddress) {
        _labAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labAll.bottom  + 5, 80, 15)];
        _labAddress.text = @"收货地址：";
        _labAddress.font = [UIFont systemFontOfSize:13];
        _labAddress.textAlignment = NSTextAlignmentLeft;
    }
    return _labAddress;
}
- (UILabel *)labAddressText{
    if (!_labAddressText) {
        _labAddressText = [[UILabel alloc]initWithFrame:CGRectMake(self.labAddress.right + 5, self.labDateText.bottom + 5, DeviceSize.width - self.labAddress.right - 5 - 10 , 15)];
        _labAddressText.numberOfLines = 0;
        _labAddressText.font = [UIFont systemFontOfSize:13];
        _labAddressText.textAlignment = NSTextAlignmentLeft;
    }
    return _labAddressText;
}
- (UILabel *)labSupply{
    if (!_labSupply) {
        _labSupply = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labAddress.bottom + 5, 80, 15)];
        _labSupply.text = @"联系电话：";
        _labSupply.font = [UIFont systemFontOfSize:13];
        _labSupply.textAlignment = NSTextAlignmentLeft;
    }
    return _labSupply;
}
- (UILabel *)labSupplyText{
    if (!_labSupplyText) {
        _labSupplyText = [[UILabel alloc]initWithFrame:CGRectMake(self.labSupply.right + 5, self.labAll.bottom + 5, DeviceSize.width - self.labSupply.right - 5 - 10, 15)];
        _labSupplyText.text = @"";
        _labSupplyText.userInteractionEnabled = YES;
        _labSupplyText.textColor = [UIColor blueColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labSupplyTextTap:)];
        [_labSupplyText addGestureRecognizer:tap];
        _labSupplyText.font = [UIFont systemFontOfSize:13];
        _labSupplyText.textAlignment = NSTextAlignmentLeft;
    }
    return _labSupplyText;
}
- (UILabel *)labBah{
    if (!_labBah) {
        _labBah = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labSupply.bottom + 5, 80, 15)];
        _labBah.text = @"报案号：";
        _labBah.font = [UIFont systemFontOfSize:13];
        _labBah.textAlignment = NSTextAlignmentLeft;
    }
    return _labBah;
}
- (UILabel *)labBahText{
    if (!_labBahText) {
        _labBahText = [[UILabel alloc]initWithFrame:CGRectMake(self.labBah.right + 5, self.labSupply.bottom + 5, DeviceSize.width - self.labBah.right - 5 - 10, 15)];
        _labBahText.text = @"";
        _labBahText.font = [UIFont systemFontOfSize:13];
        _labBahText.textAlignment = NSTextAlignmentLeft;
    }
    return _labBahText;
}
- (UILabel *)labCar{
    if (!_labCar) {
        _labCar = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labBah.bottom + 5, 80, 15)];
        _labCar.text = @"车型：";
        _labCar.font = [UIFont systemFontOfSize:13];
        _labCar.textAlignment = NSTextAlignmentLeft;
    }
    return _labCar;
}
- (UILabel *)labCarText{
    if (!_labCarText) {
        _labCarText = [[UILabel alloc]initWithFrame:CGRectMake(self.labCar.right + 5, self.labBah.bottom + 5, DeviceSize.width - self.labCar.right - 5 - 10, 15)];
        _labCarText.text = @"";
        _labCarText.font = [UIFont systemFontOfSize:13];
        _labCarText.textAlignment = NSTextAlignmentLeft;
    }
    return _labCarText;
}
- (UILabel *)labName{
    if (!_labName) {
        _labName = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labCar.bottom + 5, 80, 15)];
        _labName.text = @"零件名称：";
        _labName.font = [UIFont systemFontOfSize:13];
        _labName.textAlignment = NSTextAlignmentLeft;
    }
    return _labName;
}
- (UILabel *)labNameText{
    if (!_labNameText) {
        _labNameText = [[UILabel alloc]initWithFrame:CGRectMake(self.labName.right + 5, self.labCar.bottom + 5, DeviceSize.width - self.labName.right - 5 - 10 - 60, 15)];
        _labNameText.text = @"";
        _labNameText.font = [UIFont systemFontOfSize:13];
        _labNameText.textAlignment = NSTextAlignmentLeft;
    }
    return _labNameText;
}
- (UILabel *)labDate{
    if (!_labDate) {
        _labDate = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labName.bottom + 5, 80, 15)];
        _labDate.text = @"创建日期：";
        _labDate.font = [UIFont systemFontOfSize:13];
        _labDate.textAlignment = NSTextAlignmentLeft;
    }
    return _labDate;
}
- (UILabel *)labDateText{
    if (!_labDateText) {
        _labDateText = [[UILabel alloc]initWithFrame:CGRectMake(self.labDate.right + 5, self.labName.bottom + 5, DeviceSize.width - self.labDate.right - 5 - 10 - 60, 15)];
        _labDateText.text = @"";
        _labDateText.font = [UIFont systemFontOfSize:13];
        _labDateText.textAlignment = NSTextAlignmentLeft;
    }
    return _labDateText;
}
- (UIButton *)btnFollow{
    if (!_btnFollow) {
        _btnFollow = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnFollow.frame = CGRectMake(DeviceSize.width - 60, self.labDateText.bottom + 7.5, 50, 30);
        _btnFollow.backgroundColor = [UIColor colorWithHEX:0x20c6c6];
        _btnFollow.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnFollow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnFollow setTitle:@"关注" forState:UIControlStateNormal];
        _btnFollow.hidden = YES;
    }
    return _btnFollow;
}

- (CGFloat)configWithModel:(DownloadListModel *)dict row:(NSInteger)row{
    if (row == 9999999) {
        self.labNum.hidden = YES;
    }else{
        self.labNum.hidden = NO;
        self.labNum.text = [NSString stringWithFormat:@"%ld",(long)row];
    }
    self.phoneStr = dict.repairPhone;
    self.labAll.text = dict.barCode;
    [self.labAll sizeToFit];
    
    if (self.labNum.hidden == YES) {
        self.labAll.top = 10;
    }else{
        self.labAll.top = self.labNum.bottom + 5;
    }
    self.labAll.width = DeviceSize.width - 20;
    
    self.labAddressText.text = dict.repairAddress;
    [self.labAddressText sizeToFit];
    self.labAddress.top = self.labAll.bottom + 5;
    self.labAddressText.left = self.labAddress.right + 5;
    self.labAddressText.top = self.labAddress.top;
    self.labAddressText.width =  DeviceSize.width - self.labAddress.right - 5 - 10;
    
    self.labSupply.top = self.labAddressText.bottom + 5;
    self.labSupplyText.text = dict.repairPhone;
    self.labSupplyText.top = self.labSupply.top;
    
    self.labBah.top = self.labSupply.bottom + 5;
    self.labBahText.text = dict.bah;
    self.labBahText.top = self.labBah.top;
    
    self.labCar.top = self.labBah.bottom + 5;
    self.labCarText.text = dict.cxmc;
    self.labCarText.top = self.labCar.top;
    
    self.labName.top = self.labCar.bottom + 5;
    self.labNameText.text = dict.ljmc;
    self.labNameText.top = self.labName.top;
    
    if (self.labNum.hidden == YES) {
        self.btnFollow.top = self.labCarText.bottom + 15;
    }else{
//        self.btnFollow.top = self.labNameText.bottom + 7.5;
    }
    self.labDate.top = self.labName.bottom + 5;
    self.labDateText.text = dict.createDate;
    self.labDateText.top = self.labDate.top;
    if ([dict.careState isEqualToString:@"1"]) {
        self.btnFollow.hidden = NO;
        self.btnFollow.top =  self.labDateText.bottom - 30 ;
    }else{
        self.btnFollow.hidden = YES;
    }
    return self.labDateText.bottom + 10;
}
- (void)labSupplyTextTap:(UITapGestureRecognizer *)tap{
    if (self.playPhone) {
        self.playPhone(self.phoneStr);
    }
}
@end
