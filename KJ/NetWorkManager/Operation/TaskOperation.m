//
//  TaskOperation.m
//  PartRecycle
//
//  Created by iOSDeveloper on 2016/11/8.
//  Copyright © 2016年 jingyoutimes. All rights reserved.
//

#import "TaskOperation.h"
#import "OperationModel.h"
#import <objc/runtime.h>
#import "NetWorkManager.h"


#define kKVOBlock(KEYPATH, BLOCK) \
[self willChangeValueForKey:KEYPATH]; \
BLOCK(); \
[self didChangeValueForKey:KEYPATH];

static NSTimeInterval kTimeoutInterval = 60.0;
@interface TaskOperation () {
    BOOL _finished;
    BOOL _executing;
}
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSURLSessionUploadTask * uploadTask;
@property (nonatomic, weak) NSURLSession *session;
@property (nonatomic, assign) TaskType taskType;
@end
@implementation TaskOperation
- (instancetype)initWithModel:(OperationModel *)model session:(NSURLSession *)session type:(TaskType)type{
    if (self = [super init]) {
        self.taskType = type;
        self.model = model;
        self.session = session;
        if (type == taskTypeDown) {
            [self statRequest];
        }else if(type == taskTypeUpload) {
            [self startUploadRequest];
        }
    }
    return self;
}

- (void)dealloc {
    self.task = nil;
    self.uploadTask = nil;
}
- (void)setUploadTask:(NSURLSessionUploadTask *)uploadTask{
    [_uploadTask removeObserver:self forKeyPath:@"state"];
    
    if (_uploadTask != uploadTask) {
        _uploadTask = uploadTask;
    }
    
    if (uploadTask != nil) {
        [uploadTask addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)setTask:(NSURLSessionDownloadTask *)task {
    [_task removeObserver:self forKeyPath:@"state"];
    
    if (_task != task) {
        _task = task;
    }
    
    if (task != nil) {
        [task addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)configTask {
    if (self.taskType == taskTypeDown) {
        self.task.task_newModel = self.model;
    }else{
        self.uploadTask.task_newModel = self.model;
    }
}

- (void)statRequest {
    NSURL *url = [NSURL URLWithString:self.model.downUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:kTimeoutInterval];
    self.task = [self.session downloadTaskWithRequest:request];
    [self configTask];
}
// 上传请求
- (void)startUploadRequest{
    NSURL *url = [NSURL URLWithString:[self.model.uplodeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:kTimeoutInterval];
    [urlRequest setHTTPMethod:@"POST"];
    //  上传文件格式
    [urlRequest setValue:[NSString stringWithFormat:@"multipart/form-data"] forHTTPHeaderField:@"Content-Type"];
    [urlRequest setTimeoutInterval:kTimeoutInterval];
    [urlRequest setHTTPBody:self.model.commitData];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    WeakSelf(TaskOperation);
    self.uploadTask = [manager uploadTaskWithStreamedRequest:urlRequest progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
            weakSelf.model.uploadStatus =  statusFailed;
            if (weakSelf.finishBlock) {
                weakSelf.finishBlock(1,weakSelf.model);
            }
        }
        else
        {
            NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:-2147482062];
            NSLog(@"返回New上传数据:%@", dataStr);
//            NSDictionary *dic = [dataStr objectFromJSONString];
//            HttpResponse *response = [HttpResponse kyHttpResponseParse:dic];
            weakSelf.model.uploadStatus = statusSuccessed;
            if (weakSelf.finishBlock) {
                weakSelf.finishBlock(0,weakSelf.model);
            }
        }
    }];
//    self.uploadTask = [self.session uploadTaskWithStreamedRequest:urlRequest];
    self.uploadTask.task_newModel = self.model;
}
- (void)start {
    if (self.isCancelled) {
        kKVOBlock(@"isFinished", ^{
            _finished = YES;
        });
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    if (self.model.resumeData) {
        [self resume];
    } else {
        if (self.taskType == taskTypeDown) {
            [self.task resume];
        }else{
            [self.uploadTask resume];
        }
        self.model.status = kOperationStatusRunning;
    }
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)suspend {
    if (self.taskType == taskTypeDown) {
        if (self.task) {
            __weak __typeof(self) weakSelf = self;
            __block NSURLSessionDownloadTask *weakTask = self.task;
            [self willChangeValueForKey:@"isExecuting"];
            __block BOOL isExecuting = _executing;
            
            [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                weakSelf.model.resumeData = resumeData;
                weakTask = nil;
                isExecuting = NO;
                [weakSelf didChangeValueForKey:@"isExecuting"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.model.status = kOperationStatusSuspended;
                });
            }];
            [self.task suspend];
        }
    }else{
        // 要修改
        if (self.uploadTask) {
            __weak __typeof(self) weakSelf = self;
            __block NSURLSessionUploadTask *weakTask = self.uploadTask;
            [self willChangeValueForKey:@"isExecuting"];
            __block BOOL isExecuting = _executing;
            [self.uploadTask cancel];
            weakSelf.model.resumeData = nil;
            weakTask = nil;
            isExecuting = NO;
            [weakSelf didChangeValueForKey:@"isExecuting"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.model.status = kOperationStatusSuspended;
            });
            [self.uploadTask suspend];
        }
    }
}

- (void)resume {
    if (self.taskType == taskTypeDown) {
        if (self.model.status == kOperationStatusCompleted) {
            return;
        }
        self.model.status = kOperationStatusRunning;
        
        if (self.model.resumeData) {
            self.task = [self.session downloadTaskWithResumeData:self.model.resumeData];
            [self configTask];
        } else if (self.task == nil|| (self.task.state == NSURLSessionTaskStateCompleted && self.model.progress < 1.0)) {
            [self statRequest];
        }
        
        [self willChangeValueForKey:@"isExecuting"];
        [self.task resume];
        _executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
    }else{
        if (self.model.status == kOperationStatusCompleted) {
            return;
        }
        self.model.status = kOperationStatusRunning;
        
        if (self.model.resumeData) {
            self.task = [self.session downloadTaskWithResumeData:self.model.resumeData];
            [self configTask];
        } else if (self.uploadTask == nil|| (self.uploadTask.state == NSURLSessionTaskStateCompleted && self.model.progress < 1.0)) {
            [self startUploadRequest];
        }
        
        [self willChangeValueForKey:@"isExecuting"];
        [self.uploadTask resume];
        _executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (NSURLSessionDownloadTask *)downloadTask {
    return self.task;
}

- (void)cancel {
    [self willChangeValueForKey:@"isCancelled"];
    [super cancel];
    if (self.taskType == taskTypeDown) {
        [self.task cancel];
        self.task = nil;
    }else{
        [self.uploadTask cancel];
        self.uploadTask = nil;
    }
    [self didChangeValueForKey:@"isCancelled"];
    
    [self completeOperation];
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if (self.taskType == taskTypeDown) {
        if ([keyPath isEqualToString:@"state"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (self.task.state) {
                    case NSURLSessionTaskStateSuspended: {
                        self.model.status = kOperationStatusSuspended;
                        break;
                    }
                    case NSURLSessionTaskStateCompleted:
                        if (self.model.progress >= 1.0) {
                            self.model.status = kOperationStatusCompleted;
                        } else {
                            self.model.status = kOperationStatusSuspended;
                        }
                    default:
                        break;
                }
            });
        }
    }else{
        if ([keyPath isEqualToString:@"state"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (self.uploadTask.state) {
                    case NSURLSessionTaskStateSuspended: {
                        self.model.status = kOperationStatusSuspended;
                        break;
                    }
                    case NSURLSessionTaskStateCompleted:
                        if (self.model.progress >= 1.0) {
                            self.model.status = kOperationStatusCompleted;
                        } else {
                            self.model.status = kOperationStatusSuspended;
                        }
                    default:
                        break;
                }
            });
        }
    }
}

- (void)downloadFinished {
    [self completeOperation];
}

@end


static const void *s_taskModelKey = "s_taskModelKey";

@implementation NSURLSessionTask (OperationModel)

- (void)setTask_newModel:(OperationModel *)task_newModel{
    objc_setAssociatedObject(self, s_taskModelKey, task_newModel, OBJC_ASSOCIATION_ASSIGN);
}
- (OperationModel *)task_newModel{
    return objc_getAssociatedObject(self, s_taskModelKey);
}
@end
