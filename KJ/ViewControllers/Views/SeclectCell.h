//
//  SeclectCell.h
//  KJ
//
//  Created by iOSDeveloper on 16/9/18.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SelectModel.h"

@interface SeclectCell : BaseTableViewCell
@property (nonatomic, strong) UILabel * labCheZu;
@property (nonatomic, strong) UILabel * labCheZuText;
@property (nonatomic, strong) UILabel * labCheXing;
@property (nonatomic, strong) UILabel * labCheXingText;
@property (nonatomic, strong) UILabel * labLingJian;
@property (nonatomic, strong) UILabel * labLingJianText;
@property (nonatomic, strong) UILabel * labErWeiMa;
@property (nonatomic, strong) UILabel * labErWeiMaText;
- (CGFloat)configWithModel:(SelectModel *)model;
@end
