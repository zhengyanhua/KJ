//
//  NetWorkManager.h
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "HttpResponse.h"

typedef NS_ENUM(NSUInteger, HttpRequestMethod) {
    HttpRequestMethodGET = 1,
    HttpRequestMethodPOST = 2
};

typedef void (^CompletionBlockWithSuccess) (NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response);

typedef void (^FailureBlock) (NSURLSessionDataTask *urlSessionDataTask, NSError *error);


/**
 *	网络上传进度
 *	@param bytesWritten              写入的字节
 *	@param totalBytesWritten         总写入的字节
 *	@param totalBytesExpectedToWrite 要写入的总字节
 */
typedef void (^uploadProgressBlock)(long long bytesSent, long long totalBytesSent, long long totalBytesExpectedToSend);
/// 网络请求类
@interface NetWorkManager : NSObject
+ (id)shareNetWork;

//  登录
- (void)loginOperation:(NSDictionary *)dataDic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success
            andFailure:(FailureBlock)failure;

//  下载数据
- (void)getDownloadInfoCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure;

// 上传
- (void)getUploadInfoDict:(NSDictionary *)dict andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure;

#pragma mark --- 升级
- (void)upgradeInfo:(NSDictionary *)infoDict andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure;

// 下载照片
- (void)getDownloadInfoDict:(NSDictionary *)dict andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure;
// 上传照片
- (void)newUpLoadStreamData:(NSData*)commitData andUploadProgressWithBlock:(uploadProgressBlock)uploadProgressBlock andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure;
// 查询二维码
- (void)selectQR:(NSDictionary *)dataDic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success
      andFailure:(FailureBlock)failure;

- (void)startNetQueue;
@end
