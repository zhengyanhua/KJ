//
//  PhotoViewController.h
//  KJ
//
//  Created by iOSDeveloper on 16/7/4.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseViewController.h"
#import "SDPhotoBrowser.h"
@interface PhotoViewController : BaseViewController<SDPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray * photoArr;
@property (nonatomic, copy)   NSString       * id;
@property (nonatomic, copy)   NSString       * ljbzmc;
@property (nonatomic, copy)   NSString       * cph;
@property (nonatomic, copy)   NSString       * ghdh;
@end
