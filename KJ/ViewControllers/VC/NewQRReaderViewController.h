//
//  NewQRReaderViewController.h
//  PartRecycle
//
//  Created by iOSDeveloper on 平成27-12-23.
//  Copyright © 平成27年 jingyoutimes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewQRReaderViewController : UIViewController
@property (nonatomic, copy) void (^didFinishBlock)(NSString * string);
@end
