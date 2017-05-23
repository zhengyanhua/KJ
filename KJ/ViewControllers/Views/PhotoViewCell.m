//
//  PhotoViewCell.m
//  KJ
//
//  Created by iOSDeveloper on 16/7/4.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "PhotoViewCell.h"

@implementation PhotoViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imgView];
    }
    return self;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (DeviceSize.width - 30)/3, (DeviceSize.width - 30)/3)];
        _imgView.backgroundColor = [UIColor clearColor];
    }
    return _imgView;
}
- (void)configWithModel:(NSDictionary *)dict{
    NSRange range = [dict[@"url"] rangeOfString:@"http"];
    if (range.location != NSNotFound) {
        [self.imgView sd_setImageWithURL:URL(dict[@"url"]) placeholderImage:[UIImage imageNamed:@""]];
    }else{
        self.imgView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",ImagesPath,dict[@"url"]]];
    }
}
@end
