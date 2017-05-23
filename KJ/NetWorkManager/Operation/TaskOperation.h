//
//  TaskOperation.h
//  PartRecycle
//
//  Created by iOSDeveloper on 2016/11/8.
//  Copyright © 2016年 jingyoutimes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TaskType) {
    taskTypeDown = 0,       // DOWN
    taskTypeUpload = 1,    // UPLODE
};

@class OperationModel;
@interface NSURLSessionTask (OperationModel)
// 为了更方便去获取，而不需要遍历，采用扩展的方式，可直接提取，提高效率
@property (nonatomic, weak) OperationModel *task_newModel;
@end
@interface TaskOperation : NSOperation

- (instancetype)initWithModel:(OperationModel *)model session:(NSURLSession *)session type:(TaskType)type;

@property (nonatomic, weak) OperationModel *model;
@property (nonatomic, strong, readonly) NSURLSessionDownloadTask *downloadTask;

- (void)suspend;
- (void)resume;
- (void)downloadFinished;
// 结束 回调  0 成功  1 失败
@property (nonatomic, copy)void (^finishBlock)(NSInteger status,OperationModel *model);
@end
