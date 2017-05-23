//
//  BaseViewController.h
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBarButtonItemExtension.h"

@interface BaseViewController : UIViewController
/// 数组下标
@property (nonatomic, assign) NSInteger arrIndex;
/// 距离屏幕顶部的距离
@property(nonatomic,readonly) CGFloat viewTop;
/// 距离屏幕顶部的高度
@property(nonatomic,readonly) CGFloat frameTopHeight;

- (BOOL)equalInfoArray:(NSMutableArray *)array obj:(NSString *)obj;
/// 数据转换成分组数据格式
- (NSMutableArray *)getGroupInfoArray:(NSMutableArray *)array;

@end
