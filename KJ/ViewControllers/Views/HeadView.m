//
//  HeadView.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/25.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.labCount];
        [self addSubview:self.labWait];
        [self addSubview:self.labLine];
    }
    return self;
}

- (UILabel *)labCount{
    if (!_labCount) {
        _labCount = [[UILabel alloc]initWithFrame:CGRectMake(10, (40 - 15)/2, DeviceSize.width/2 - 10, 15)];
        _labCount.font = [UIFont systemFontOfSize:15];
        _labCount.textAlignment = NSTextAlignmentCenter;
        _labCount.textColor = [UIColor blackColor];
    }
    return _labCount;
}

- (UILabel *)labWait{
    if (!_labWait) {
        _labWait = [[UILabel alloc]initWithFrame:CGRectMake(self.labCount.right, (40 - 15)/2, DeviceSize.width/2 - 10, 15)];
        _labWait.font = [UIFont systemFontOfSize:15];
        _labWait.textAlignment = NSTextAlignmentCenter;
        _labWait.textColor = [UIColor blackColor];
    }
    return _labWait;
}
- (UILabel *)labLine{
    if (!_labLine) {
        _labLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height, DeviceSize.width, 0.5)];
        _labLine.backgroundColor = [UIColor colorWithHEX:0xcccccc];
    }
    return _labLine;
}
- (void)configWithModel:(NSDictionary *)dict{
    self.labCount.text = [NSString stringWithFormat:@"待收货数量：%@",dict[@"sum"]];
    self.labWait.text = [NSString stringWithFormat:@"延迟收货数量：%@",dict[@"all"]];
}

@end
