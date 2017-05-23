//
//  DownloadListModel.h
//  KJ
//
//  Created by iOSDeveloper on 16/5/4.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseModel.h"

@interface DownloadListModel : BaseModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString * bah;
@property (nonatomic, copy) NSString * barCode;
@property (nonatomic, copy) NSString * careState;
@property (nonatomic, copy) NSString * cxmc;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * ljmc;
@property (nonatomic, copy) NSString * sendDate;

@property (nonatomic, copy) NSString * createDate;

@property (nonatomic, copy) NSString * zch;
@property (nonatomic, copy) NSString * ghdh;
@property (nonatomic, copy) NSString * cph;
@property (nonatomic, copy) NSString * sth;
@property (nonatomic, copy) NSString * repairAddress;
@property (nonatomic, copy) NSString * repairPhone;
@end
