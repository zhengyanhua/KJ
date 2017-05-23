//
//  TitleView.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/25.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor greenColor];
        [self addSubview:self.labTitle];
    }
    return self;
}
- (UILabel *)labTitle{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 40)];
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.textColor = [UIColor blueColor];
        [_labTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
    }
    return _labTitle;
}
@end
