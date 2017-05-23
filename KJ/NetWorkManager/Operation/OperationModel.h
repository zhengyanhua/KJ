//
//  OperationModel.h
//  PartRecycle
//
//  Created by iOSDeveloper on 2016/11/8.
//  Copyright © 2016年 jingyoutimes. All rights reserved.
//

#import "MTLModel.h"
@class OperationModel;
@class TaskOperation;
typedef NS_ENUM(NSInteger, OperationStatus) {
    kOperationStatusNone = 0,       // 初始状态
    kOperationStatusRunning = 1,    // 下载中
    kOperationStatusSuspended = 2,  // 下载暂停
    kOperationStatusCompleted = 3,  // 下载完成
    kOperationStatusFailed  = 4,    // 下载失败
    kOperationStatusWaiting = 5    // 等待下载
    //  kOperationStatusCancel = 6      // 取消下载
};
typedef NS_ENUM(NSInteger, uploadStatus) {
    statusSuccessed = 0,       // 成功
    statusFailed = 1,    // 失败
};
typedef void(^StatusChanged)(OperationModel *model);
typedef void(^ProgressChanged)(OperationModel *model);

@interface OperationModel : MTLModel<MTLJSONSerializing>
// id 自动生成唯一标识
@property (nonatomic, copy) NSString *operationId;
// 下载URL
@property (nonatomic, copy) NSString *downUrl;
// 照片URL
@property (nonatomic, copy) NSString *imageUrl;
// 标题
@property (nonatomic, copy) NSString *title;
// 上传URL
@property (nonatomic, copy) NSString *uplodeUrl;
// 上传CODE
@property (nonatomic, copy) NSString *uplodeCode;
// 上传参数
@property (nonatomic, copy) NSMutableDictionary *uplodeDict;
// 上传状态
@property (nonatomic, assign) uploadStatus uploadStatus;
// 下载数据Data
@property (nonatomic, strong) NSData *resumeData;
// 上传数据Data
@property (nonatomic, strong) NSData *commitData;
// 下载后存储到此处
@property (nonatomic, copy) NSString *localPath;
@property (nonatomic, copy) NSString *progressText;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) OperationStatus status;
@property (nonatomic, strong) TaskOperation *operation;

@property (nonatomic, copy) StatusChanged onStatusChanged;
@property (nonatomic, copy) ProgressChanged onProgressChanged;
@property (nonatomic, readonly, copy) NSString *statusText;
@end
