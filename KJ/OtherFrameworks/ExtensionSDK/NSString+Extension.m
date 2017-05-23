//
//  NSString+Extension.m
//  KYPatient
//
//  Created by JY on 15/7/7.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)
- (NSString *)toMD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (BOOL)isNULL
{
    BOOL identifier = YES;
    if (self == nil) {
        identifier = YES;
    } else if (self.length == 0) {
        identifier = YES;
    } else if ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        identifier = YES;
    } else if ([self stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        identifier = YES;
    } else if ([self isEqual:[NSNull null]]) {
        identifier = YES;
    } else {
        identifier = NO;
    }
    return identifier;
}

+ (NSString*)queryUUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return result;
}

- (NSString *)utf8ToUnicode

{
    
    NSUInteger length = [self length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
        
    {
        
        unichar _char = [self characterAtIndex:i];
        
        //判断是否为英文和数字
        //
        //        if (_char <= '9' && _char >='0')
        //
        //        {
        //
        //            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i,1)]];
        //
        //        }
        //
        //        else if(_char >='a' && _char <= 'z')
        //
        //        {
        //
        //            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i,1)]];
        //
        //
        //
        //        }
        //
        //        else if(_char >='A' && _char <= 'Z')
        //
        //        {
        //
        //            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i,1)]];
        //
        //
        //
        //        }
        //
        //        else
        //
        //        {
        //
        //            [s appendFormat:@"\\u%x",[self characterAtIndex:i]];
        //
        //        }
        //
        
        if( _char > 0x4e00 && _char < 0x9fff)
        {
            [s appendFormat:@"\\u%x",[self characterAtIndex:i]];
        } else {
            
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i,1)]];
            
        }
        
    }
    
    return s;
    
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}
@end
