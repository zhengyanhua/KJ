//
//  BaseTool.h
//  KJ
//
//  Created by iOSDeveloper on 16/5/6.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseTool : NSObject
#pragma mark ------
#pragma mark 返回 1 未超过当前日期  返回  -1  超过当前日期 返回0 两个日期相同
/// 比较时间大小
+ (int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;

@end
