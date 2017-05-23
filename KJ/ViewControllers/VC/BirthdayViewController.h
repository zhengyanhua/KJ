//
//  BirthdayViewController.h
//  NR
//
//  Created by 范英强 on 15/10/24.
//  Copyright (c) 2015年 范英强. All rights reserved.
//

#import "BaseViewController.h"

@interface BirthdayViewController : BaseViewController

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) void (^BirthdayBlock)(NSString *date,NSInteger i);
@end
