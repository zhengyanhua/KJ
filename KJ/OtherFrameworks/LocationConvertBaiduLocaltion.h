//
//  LocationConvertBaiduLocaltion.h
//  Claim
//
//  Created by JY on 15/8/27.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationConvertBaiduLocaltion : NSObject

//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
