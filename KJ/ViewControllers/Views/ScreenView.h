//
//  ScreenView.h
//  KJ
//
//  Created by iOSDeveloper on 16/4/26.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenView : UIView<UITextFieldDelegate>
@property (nonatomic, strong) UILabel     * labBah;
@property (nonatomic, strong) UITextField * textBah;
@property (nonatomic, strong) UILabel     * labName;
@property (nonatomic, strong) UITextField * textName;
@property (nonatomic, strong) UILabel     * labDate;
@property (nonatomic, strong) UIButton    * btnStart;
@property (nonatomic, strong) UIButton    * btnStop;
@property (nonatomic, strong) UILabel     * labLine;
@property (nonatomic, strong) UIButton    * btnReset;
@property (nonatomic, strong) UIButton    * btnSelect;
@property (nonatomic, strong) UILabel     * labLine1;

@property (nonatomic, copy) void (^btnStartBlock)(void);
@property (nonatomic, copy) void (^btnStopBlock)(void);

@property (nonatomic, copy) void (^btnResetBlock)(void);
@property (nonatomic, copy) void (^btnSelectBlock)(void);

@property (nonatomic, strong) NSDateFormatter *formatter;
- (void)configWithDict:(NSDictionary *)dict;
@end
