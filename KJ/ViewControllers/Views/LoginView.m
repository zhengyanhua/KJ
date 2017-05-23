//
//  LoginView.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/25.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.labLine1];
        [self addSubview:self.imgName];
        [self addSubview:self.textName];
        [self addSubview:self.labLine2];
        [self addSubview:self.imgPwd];
        [self addSubview:self.textPwd];
        [self addSubview:self.labLine3];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (UILabel *)labLine1{
    if (!_labLine1) {
        _labLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 0.5)];
        _labLine1.backgroundColor = [UIColor colorWithHEX:0xcccccc];
    }
    return _labLine1;
}
- (UIImageView *)imgName{
    if (!_imgName) {
        _imgName = [[UIImageView alloc]initWithFrame:CGRectMake(20, (45 - 28)/2, 28, 28)];
        _imgName.image = [UIImage imageNamed:@"userName"];
    }
    return _imgName;
}
- (UITextField *)textName{
    if (!_textName) {
        _textName = [[UITextField alloc]initWithFrame:CGRectMake(self.imgName.right + 20, (45 - 30)/2, DeviceSize.width - 2 * 20 - self.imgName.right, 30)];
        _textName.clearButtonMode = UITextFieldViewModeAlways;
        _textName.placeholder = @"请输入用户名";
        _textName.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
    }
    return _textName;
}
- (UILabel *)labLine2{
    if (!_labLine2) {
        _labLine2 = [[UILabel alloc]initWithFrame:CGRectMake(20, self.textName.bottom + (45 - 30)/2, DeviceSize.width - 40, 0.5)];
        _labLine2.backgroundColor = [UIColor colorWithHEX:0xcccccc];
    }
    return _labLine2;
}
- (UIImageView *)imgPwd{
    if (!_imgPwd) {
        _imgPwd = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.labLine2.bottom + (45 - 28)/2, 28, 28)];
        _imgPwd.image = [UIImage imageNamed:@"Password"];
    }
    return _imgPwd;
}
- (UITextField *)textPwd{
    if (!_textPwd) {
        _textPwd = [[UITextField alloc]initWithFrame:CGRectMake(self.imgName.right + 20, self.labLine2.bottom +(45 - 30)/2, DeviceSize.width - self.imgPwd.right - 2 * 20 , 30)];  
        _textPwd.placeholder = @"请输入密码";
        _textPwd.secureTextEntry = YES;
//        [_textPwd setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//        [_textPwd setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    }
    return _textPwd;
}
- (UILabel *)labLine3{
    if (!_labLine3) {
        _labLine3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, DeviceSize.width, 0.5)];
        _labLine3.backgroundColor = [UIColor colorWithHEX:0xcccccc];
    }
    return _labLine3;
}
@end
