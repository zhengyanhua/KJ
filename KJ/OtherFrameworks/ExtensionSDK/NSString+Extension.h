//
//  NSString+Extension.h
//  KYPatient
//
//  Created by JY on 15/7/7.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
/// md5加密
- (NSString *)toMD5 ;
//  判断是否是空
- (BOOL)isNULL;
//  获取UUID
+ (NSString*)queryUUID;

//  unicode编辑
- (NSString *)utf8ToUnicode;
//  unicode解码
- (NSString *)replaceUnicode:(NSString *)unicodeStr;
@end
