//
//  TaskOperationManager.h
//  PartRecycle
//
//  Created by iOSDeveloper on 2016/11/8.
//  Copyright © 2016年 jingyoutimes. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OperationModel;

@interface TaskOperationManager : NSObject
@property (nonatomic, readonly, strong) NSArray *taskModels;
@property (nonatomic, strong) NSMutableArray *taskList;
+ (instancetype)shared;

- (void)addTaskModels:(NSArray<OperationModel *> *)taskModels;

- (void)startWithTaskModel:(OperationModel *)taskModel;
- (void)suspendWithTaskModel:(OperationModel *)taskModel;
- (void)resumeWithTaskModel:(OperationModel *)taskModel;
- (void)stopWithTaskModel:(OperationModel *)taskModel;

// 上传操作
- (void)startUploadWithTaskModel:(OperationModel *)taskModel;
@end
