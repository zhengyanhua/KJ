//
//  HeadView.h
//  KJ
//
//  Created by iOSDeveloper on 16/4/25.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView
@property (nonatomic, strong) UILabel * labCount;
@property (nonatomic, strong) UILabel * labWait;
@property (nonatomic, strong) UILabel * labLine;
- (void)configWithModel:(NSDictionary *)dict;
@end
