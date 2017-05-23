//
//  NSString+Size.m
//  JRJNews
//
//  Created by Mr.Yang on 14-4-16.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithFont:(UIFont *)font
{
   return [self sizeWithFont:font maxSize:CGSizeMake(DeviceSize.width, NSIntegerMax)];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:dic
                              context:nil
            ].size;
}

- (CGFloat)getLabelHeightForFont:(UIFont *)font maxWidth:(CGFloat)labWidth{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [self boundingRectWithSize:CGSizeMake(labWidth, 0)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:dic
                              context:nil
            ].size.height;
}
@end
