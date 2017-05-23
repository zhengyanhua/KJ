//
//  GroupModel.h
//  KJ
//
//  Created by iOSDeveloper on 16/5/4.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseModel.h"

@interface GroupModel : BaseModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString * GD;
@property (nonatomic, copy) NSString * cph;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray * list;
@end
