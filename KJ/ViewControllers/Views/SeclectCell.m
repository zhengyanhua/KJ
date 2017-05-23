//
//  SeclectCell.m
//  KJ
//
//  Created by iOSDeveloper on 16/9/18.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "SeclectCell.h"

@implementation SeclectCell
- (void)customView{
    [self.contentView addSubview:self.labCheZu];
    [self.contentView addSubview:self.labCheZuText];
    [self.contentView addSubview:self.labCheXing];
    [self.contentView addSubview:self.labCheXingText];
    [self.contentView addSubview:self.labLingJian];
    [self.contentView addSubview:self.labLingJianText];
    [self.contentView addSubview:self.labErWeiMa];
    [self.contentView addSubview:self.labErWeiMaText];
}
- (UILabel *)labCheZu{
    if (!_labCheZu) {
        _labCheZu = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 15)];
        _labCheZu.textAlignment = NSTextAlignmentLeft;
        _labCheZu.font = [UIFont systemFontOfSize:13];
        _labCheZu.text = @"车组名称：";
    }
    return _labCheZu;
}
- (UILabel *)labCheZuText{
    if (!_labCheZuText) {
        _labCheZuText = [[UILabel alloc]initWithFrame:CGRectMake(self.labCheZu.right + 5,self.labCheZu.top , DeviceSize.width - 5 - 10 - self.labCheZu.right, 15)];
        _labCheZuText.textAlignment = NSTextAlignmentLeft;
        _labCheZuText.font = [UIFont systemFontOfSize:13];
    }
    return _labCheZuText;
}
- (UILabel *)labCheXing{
    if (!_labCheXing) {
        _labCheXing = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labCheZu.bottom + 5, 80, 15)];
        _labCheXing.textAlignment = NSTextAlignmentLeft;
        _labCheXing.font = [UIFont systemFontOfSize:13];
        _labCheXing.text = @"车型名称：";
    }
    return _labCheXing;
}
- (UILabel *)labCheXingText{
    if (!_labCheXingText) {
        _labCheXingText = [[UILabel alloc]initWithFrame:CGRectMake(self.labCheXing.right + 5,self.labCheXing.top , DeviceSize.width - 5 - 10 - self.labCheXing.right, 15)];
        _labCheXingText.textAlignment = NSTextAlignmentLeft;
        _labCheXingText.font = [UIFont systemFontOfSize:13];
    }
    return _labCheXingText;
}
- (UILabel *)labLingJian{
    if (!_labLingJian) {
        _labLingJian = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labCheXing.bottom + 5, 80, 15)];
        _labLingJian.textAlignment = NSTextAlignmentLeft;
        _labLingJian.font = [UIFont systemFontOfSize:13];
        _labLingJian.text = @"零件名称：";
    }
    return _labLingJian;
}
- (UILabel *)labLingJianText{
    if (!_labLingJianText) {
        _labLingJianText = [[UILabel alloc]initWithFrame:CGRectMake(self.labLingJian.right + 5,self.labLingJian.top , DeviceSize.width - 5 - 10 - self.labLingJian.right, 15)];
        _labLingJianText.textAlignment = NSTextAlignmentLeft;
        _labLingJianText.font = [UIFont systemFontOfSize:13];
    }
    return _labLingJianText;
}
- (UILabel *)labErWeiMa{
    if (!_labErWeiMa) {
        _labErWeiMa = [[UILabel alloc]initWithFrame:CGRectMake(10, self.labLingJian.bottom + 5, 80, 15)];
        _labErWeiMa.textAlignment = NSTextAlignmentLeft;
        _labErWeiMa.font = [UIFont systemFontOfSize:13];
        _labErWeiMa.text = @"二维码号：";
    }
    return _labErWeiMa;
}
- (UILabel *)labErWeiMaText{
    if (!_labErWeiMaText) {
        _labErWeiMaText = [[UILabel alloc]initWithFrame:CGRectMake(self.labErWeiMa.right + 5,self.labErWeiMa.top , DeviceSize.width - 5 - 10 - self.labErWeiMa.right, 15)];
        _labErWeiMaText.textAlignment = NSTextAlignmentLeft;
        _labErWeiMaText.font = [UIFont systemFontOfSize:13];
    }
    return _labErWeiMaText;
}
- (CGFloat)configWithModel:(SelectModel *)model{
    self.labCheZuText.text = model.vehSeriName;
    self.labCheXingText.text = model.cxmc;
    self.labLingJianText.text = model.ljmc;
    self.labErWeiMaText.text =model.qr;
    return self.labErWeiMaText.bottom + 10;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
