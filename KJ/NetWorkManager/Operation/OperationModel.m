//
//  OperationModel.m
//  PartRecycle
//
//  Created by iOSDeveloper on 2016/11/8.
//  Copyright © 2016年 jingyoutimes. All rights reserved.
//

#import "OperationModel.h"

@implementation OperationModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
- (NSString *)localPath {
    NSString *pathName = [NSString stringWithFormat:@"/Documents/HYBVideos/%@.mp4",self.operationId];
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:pathName];
    
    return filePath;
}

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
        
        if (self.onProgressChanged) {
            self.onProgressChanged(self);
        } else {
            NSLog(@"progress changed block is empty");
        }
    }
}

- (void)setStatus:(OperationStatus)status {
    if (_status != status) {
        _status = status;
        
        if (self.onStatusChanged) {
            self.onStatusChanged(self);
        }
    }
}

- (NSString *)statusText {
    switch (self.status) {
        case kOperationStatusNone: {
            return @"";
            break;
        }
        case kOperationStatusRunning: {
            return @"下载中";
            break;
        }
        case kOperationStatusSuspended: {
            return @"暂停下载";
            break;
        }
        case kOperationStatusCompleted: {
            return @"下载完成";
            break;
        }
        case kOperationStatusFailed: {
            return @"下载失败";
            break;
        }
        case kOperationStatusWaiting: {
            return @"等待下载";
            break;
        }
    }
}
@end
