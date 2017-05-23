//
//  SelectModel.h
//  KJ
//
//  Created by iOSDeveloper on 16/9/18.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseModel.h"

@interface SelectModel : BaseModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString * bah;
@property (nonatomic, copy) NSString * barCode;
@property (nonatomic, copy) NSString * careState;
@property (nonatomic, copy) NSString * cxmc;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * ljmc;
@property (nonatomic, copy) NSString * partId;
@property (nonatomic, copy) NSString * repairAddress;
@property (nonatomic, copy) NSString * repairPhone;
@property (nonatomic, copy) NSString * sendDate;
@property (nonatomic, copy) NSString * vehSeriName;
@property (nonatomic, copy) NSString * qr;
@end
