//
//  ListTableViewCell.h
//  KJ
//
//  Created by iOSDeveloper on 16/4/26.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DownloadListModel.h"
@interface ListTableViewCell : BaseTableViewCell
@property (nonatomic, strong) UILabel * labNum;
@property (nonatomic, strong) UILabel * labAll;
@property (nonatomic, strong) UILabel * labAddress;
@property (nonatomic, strong) UILabel * labAddressText;
@property (nonatomic, strong) UILabel * labSupply;
@property (nonatomic, strong) UILabel * labSupplyText;
@property (nonatomic, strong) UILabel * labBah;
@property (nonatomic, strong) UILabel * labBahText;
@property (nonatomic, strong) UILabel * labCar;
@property (nonatomic, strong) UILabel * labCarText;
@property (nonatomic, strong) UILabel * labName;
@property (nonatomic, strong) UILabel * labNameText;
@property (nonatomic, strong) UILabel * labDate;
@property (nonatomic, strong) UILabel * labDateText;
@property (nonatomic, strong) UIButton * btnFollow;

@property (nonatomic, copy) NSString * phoneStr;
@property (nonatomic, copy) void (^playPhone)(NSString * phone);
- (CGFloat)configWithModel:(DownloadListModel *)dict row:(NSInteger)row;

@end
