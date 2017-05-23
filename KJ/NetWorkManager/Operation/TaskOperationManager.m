//
//  TaskOperationManager.m
//  PartRecycle
//
//  Created by iOSDeveloper on 2016/11/8.
//  Copyright © 2016年 jingyoutimes. All rights reserved.
//

#import "TaskOperationManager.h"
#import "OperationModel.h"
#import "TaskOperation.h"

static TaskOperationManager *_sg_videoManager = nil;

@interface TaskOperationManager () <NSURLSessionDownloadDelegate> {
    NSMutableArray *_taskModels;
}

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSURLSession *session;

@end
@implementation TaskOperationManager
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sg_videoManager = [[self alloc] init];
    });
    
    return _sg_videoManager;
}
- (NSMutableArray *)taskList{
    if (!_taskList) {
        _taskList = [NSMutableArray array];
    }
    return _taskList;
}
- (instancetype)init {
    if (self = [super init]) {
        _taskModels = [[NSMutableArray alloc] init];
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 4;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 不能传self.queue
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return self;
}

- (NSArray *)taskModels {
    return _taskModels;
}
- (void)addTaskModels:(NSArray<OperationModel *> *)taskModels{
    if ([taskModels isKindOfClass:[NSArray class]]) {
        _taskModels = [NSMutableArray arrayWithArray:taskModels];
//        [_taskModels addObjectsFromArray:taskModels];
    }
}

- (void)startWithTaskModel:(OperationModel *)taskModel{
    if (taskModel.status != kOperationStatusCompleted) {
        taskModel.status = kOperationStatusRunning;
        if (taskModel.operation == nil) {
            taskModel.operation = [[TaskOperation alloc] initWithModel:taskModel session:self.session type:taskTypeDown];
            [self.queue addOperation:taskModel.operation];
            [taskModel.operation start];
        } else {
            [taskModel.operation resume];
        }
    }
}
// 上传操作
- (void)startUploadWithTaskModel:(OperationModel *)taskModel{
    if (taskModel.status != kOperationStatusCompleted) {
        taskModel.status = kOperationStatusRunning;
        if (taskModel.operation == nil) {
            taskModel.operation = [[TaskOperation alloc] initWithModel:taskModel session:self.session type:taskTypeUpload];
            if (taskModel.uploadStatus == statusFailed) {
                [self.queue addOperation:taskModel.operation];
                [taskModel.operation start];
                [taskModel.operation setFinishBlock:^(NSInteger status,OperationModel * item) {
                    if (status == 0) {
                        NSArray * a = [CommUtil readDataWithFileName:@"aaaaa"];
                        NSMutableArray * b = [NSMutableArray arrayWithArray:a];
                        for (OperationModel * model in a) {
                            if ([item.operationId isEqualToString:model.operationId]) {
                                [b removeObject:model];
                            }
                        }
                        [CommUtil saveData:b andSaveFileName:@"aaaaa"];
                        item.uploadStatus = statusSuccessed;
                        [item.operation downloadFinished];
                    }else{
                        item.uploadStatus = statusFailed;
                    }
                }];
            }
        } else {
            [taskModel.operation resume];
        }
    }
}
- (void)suspendWithTaskModel:(OperationModel *)taskModel{
    if (taskModel.status != kOperationStatusCompleted) {
        [taskModel.operation suspend];
    }
}

- (void)resumeWithTaskModel:(OperationModel *)taskModel{
    if (taskModel.status != kOperationStatusCompleted) {
        [taskModel.operation resume];
    }
}

- (void)stopWithTaskModel:(OperationModel *)taskModel{
    if (taskModel.operation) {
        [taskModel.operation cancel];
    }
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    //本地的文件路径，使用fileURLWithPath:来创建
    if (downloadTask.task_newModel.localPath) {
        NSURL *toURL = [NSURL fileURLWithPath:downloadTask.task_newModel.localPath];
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager moveItemAtURL:location toURL:toURL error:nil];
    }
    
    [downloadTask.task_newModel.operation downloadFinished];
    NSLog(@"path = %@", downloadTask.task_newModel.localPath);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error == nil) {
            task.task_newModel.status = kOperationStatusCompleted;
            [task.task_newModel.operation downloadFinished];
        } else if (task.task_newModel.status == kOperationStatusSuspended) {
            task.task_newModel.status = kOperationStatusSuspended;
        } else if ([error code] < 0) {
            // 网络异常
            task.task_newModel.status = kOperationStatusFailed;
        }
    });
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    double byts =  totalBytesWritten * 1.0 / 1024 / 1024;
    double total = totalBytesExpectedToWrite * 1.0 / 1024 / 1024;
    NSString *text = [NSString stringWithFormat:@"%.1lfMB/%.1fMB",byts,total];
    CGFloat progress = totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        downloadTask.task_newModel.progressText = text;
        downloadTask.task_newModel.progress = progress;
    });
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    double byts =  fileOffset * 1.0 / 1024 / 1024;
    double total = expectedTotalBytes * 1.0 / 1024 / 1024;
    NSString *text = [NSString stringWithFormat:@"%.1lfMB/%.1fMB",byts,total];
    CGFloat progress = fileOffset / (CGFloat)expectedTotalBytes;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        downloadTask.task_newModel.progressText = text;
        downloadTask.task_newModel.progress = progress;
    });
}
@end
