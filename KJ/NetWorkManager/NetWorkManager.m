//
//  NetWorkManager.m
//  KJ

//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "NetWorkManager.h"
#import "AFURLRequestSerialization.h"
#import "OperationModel.h"
#import "TaskOperationManager.h"
#define BASEOLDURL @"http://192.168.120.122:8080/suny/"
//#define BASEOLDURL @"http://www.suny123.com/suny/"
#define BASEURL [NSString stringWithFormat:@"%@pjhsAppDataInteractionServlet",BASEOLDURL]
#define UPLOADURL [NSString stringWithFormat:@"%@pjhsAppUploadZipDataPjInteractionServlet",BASEOLDURL]


@interface NetWorkManager ()
{
    NSString *URLPath;
}
@property (nonatomic,strong) AFHTTPSessionManager *httpSessionManager;
//  保存上一个请一个对象
@property (nonatomic,strong) NSURLSessionDataTask *previousURLSessionDataTask;

@end

static NetWorkManager *thNetWorkManager = nil;
@implementation NetWorkManager
+ (id)shareNetWork
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thNetWorkManager = [[NetWorkManager alloc] init];
    });
    return thNetWorkManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thNetWorkManager = [super allocWithZone:zone];
    });
    return thNetWorkManager;
}

- (instancetype)init
{
    thNetWorkManager = [super init];
    if (thNetWorkManager) {
        
    }
    return thNetWorkManager;
}

- (id)copy
{
    return [[self class] shareNetWork];
}

- (id)mutableCopy
{
    return [[self class] shareNetWork];
}

- (AFHTTPSessionManager *)httpSessionManager
{
    if (!_httpSessionManager) {
        _httpSessionManager = [AFHTTPSessionManager manager];
        
        //返回json
        _httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //   配置响应序列化器的可接受内容类型acceptableContentTypes
        _httpSessionManager.responseSerializer.acceptableContentTypes = [_httpSessionManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"text/plain", @"text/html",@"application/json",@"text/javascript", nil]];
        _httpSessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _httpSessionManager.securityPolicy.allowInvalidCertificates = YES;//  不验证ssl证书
        
        _httpSessionManager.requestSerializer.timeoutInterval = 30;
        
    }
    return _httpSessionManager;
}

- (void)addHeadFieldParamsDic:(NSDictionary *)headerFieldParamsDic
{
    if (headerFieldParamsDic) {
        for (NSString *key in headerFieldParamsDic.allKeys) {
            [self.httpSessionManager.requestSerializer setValue:[headerFieldParamsDic stringForKey:key] forHTTPHeaderField:key];
        }
    }
}

- (NSDictionary *)defaultHeaderField
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil) {
        token = @"aaa";
    }
    return @{@"token":token,@"uuid":UUIDSTR};
}

//POST一个请求
- (void)POSTRequestOperationWithUrlPort:(NSString *)urlPort
                                 params:(NSDictionary *)params
                           successBlock:(CompletionBlockWithSuccess)successBlock
                           failureBlock:(FailureBlock)failureBlock
{
    NSString *urlPath = [thServerHost stringByAppendingString:urlPort];
    
    [self requestOperation:urlPath andParams:params andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask,HttpResponse *response){
        
        if (successBlock) {
            successBlock(urlSessionDataTask,response);
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask,NSError *error){
        if (failureBlock) {
            failureBlock(urlSessionDataTask,error);
        }
    }];
}

- (NSURLSessionDataTask *)requestOperation:(NSString *)requestUrl andParams:(NSDictionary *)paramDic andHeaderFieldParams:(NSDictionary *)headerFieldParamsDic andHttpRequestMethod:(HttpRequestMethod)httpRequestMethod andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
{
    
    //  添加header请求头
    if (headerFieldParamsDic) {
        [self addHeadFieldParamsDic:headerFieldParamsDic];
    }
    
    //  默认添加UUID和token参数
    [self addHeadFieldParamsDic:[self defaultHeaderField]];
    
    NSURLSessionDataTask *urlSessionDataTask = nil;
    if (httpRequestMethod == HttpRequestMethodPOST) {
        
        urlSessionDataTask = [self.httpSessionManager POST:requestUrl parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (success) {
                HttpResponse *response = [HttpResponse kyHttpResponseParse:responseObject];
//                WeakSelf(NetWorkManager);
                //访问所有接口，如果返回 {"data":"","info":"…","status":"-99"} status为 -99 则表示需要登录或重新登录
                
//                //所有鉴权接口，每次请求需要传入token参数。
//                if (response.responseCode == -99) {
//                    //  保存上一次请求
//                    self.previousURLSessionDataTask = urlSessionDataTask;
//                    
//                    [weakSelf getTokenForCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
//                        
//                        if (response.responseCode == 1 ) {
//                            [weakSelf.previousURLSessionDataTask resume];
//                        }
//                        self.previousURLSessionDataTask = nil;
//                        
//                    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
//                        if (failure) {
//                            failure(urlSessionDataTask,error);
//                        }
//                    }];
//                    return ;
//                    
//                }
                
                success(task,response);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure) {
                failure(task,error);
            }
        }];
        
    } else if (httpRequestMethod == HttpRequestMethodGET) {
        
        urlSessionDataTask = [self.httpSessionManager GET:requestUrl parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (success) {
                HttpResponse *response = [HttpResponse kyHttpResponseParse:responseObject];
                
//                WeakSelf(NetWorkManager);
                //访问所有接口，如果返回 {"data":"","info":"…","status":"-99"} status为 -99 则表示需要登录或重新登录
                
                //所有鉴权接口，每次请求需要传入token参数。
//                if (response.responseCode == -99) {
//                    //  保存上一次请求
//                    self.previousURLSessionDataTask = urlSessionDataTask;
//                    
//                    [weakSelf getTokenForCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
//                        
//                        if (response.responseCode == 1 ) {
//                            [weakSelf.previousURLSessionDataTask resume];
//                        }
//                        self.previousURLSessionDataTask = nil;
//                        
//                    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
//                        if (failure) {
//                            failure(urlSessionDataTask,error);
//                        }
//                    }];
//                    return ;
//                    
//                }
                success(task,response);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure) {
                failure(task,error);
            }
        }];
        
    }
    //  请求接口
    //    [urlSessionDataTask resume];
    
    return urlSessionDataTask;
    
}

- (void)getTokenForCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock)failure
{
    NSString *urlPath = [thServerHost stringByAppendingPathComponent:@"getToken.json"];
    
    NSDictionary *headDic = @{@"uuid":UUIDSTR};
    
    [self requestOperation:urlPath andParams:nil andHeaderFieldParams:headDic andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        
        //  保存访问token?""
        NSString *token = [response.dataDic objectForKey:@"token"];
        if (token.length>0) {
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (success) {
            success(urlSessionDataTask,response);
        }
        
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        if (failure) {
            failure(urlSessionDataTask,error);
        }
    }];
}


/// 转换枚举类型对应的请求方式
- (NSString *)convertHttpPostMethodEnum:(HttpRequestMethod) httpRequestMethod
{
    if (httpRequestMethod == HttpRequestMethodGET) {
        return @"GET";
    } else if (httpRequestMethod == HttpRequestMethodPOST) {
        return @"POST";
    }
    return @"GET";
}

//GET请求方式

- (void)GETRequestOperationWithUrlPort:(NSString *)urlPort
                                params:(NSDictionary *)params
                          successBlock:(CompletionBlockWithSuccess)successBlock
                          failureBlock:(FailureBlock)failureBlock
{
    NSString *urlPath = [thServerHost stringByAppendingString:urlPort];
    
    [self requestOperation:urlPath andParams:params andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodGET andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask,HttpResponse *response){
        
        if (successBlock) {
            successBlock(urlSessionDataTask,response);
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask,NSError *error){
        if (failureBlock) {
            failureBlock(urlSessionDataTask,error);
        }
    }];
}
- (NSMutableDictionary *)dataDicAndRequestCodeWithDic:(NSDictionary *)dataDic andRequestCode:(NSString *)requestCode andNetWorkType:(NetWorkType)netWorkType
{
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    if (netWorkType == NetWorkTypeHost) {
        [parmDic setObject:requestCode forKey:@"flag"];
        [parmDic setObject:dataDic forKey:@"data"];
    } else {
        [parmDic setObject:requestCode forKey:@"requestCode"];
        [parmDic setObject:[dataDic JSONString] forKey:@"data"];
    }
    
    return parmDic;
}
#pragma mark ------  网络请求
#pragma mark
//  登录
- (void)loginOperation:(NSDictionary *)dataDic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success
            andFailure:(FailureBlock)failure
{
    NSMutableDictionary *paramDic = [self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"0100" andNetWorkType:NetWorkTypeHost];
    [self requestOperation:BASEURL andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}

//  下载数据
- (void)getDownloadInfoCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:[CommUtil readDataWithFileName:@"userName"] forKey:@"username"];
    NSMutableDictionary *paramDic = [self dataDicAndRequestCodeWithDic:dict andRequestCode:@"0200" andNetWorkType:NetWorkTypeHost];
    [self requestOperation:BASEURL andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}

// 上传
- (void)getUploadInfoDict:(NSDictionary *)dict andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSMutableDictionary *paramDic = [self dataDicAndRequestCodeWithDic:dict andRequestCode:@"0300" andNetWorkType:NetWorkTypeHost];
    [self requestOperation:BASEURL andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}

#pragma mark --- 升级
- (void)upgradeInfo:(NSDictionary *)infoDict andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    [self requestOperation:@"http://api.fir.im/apps/latest/com.jingyoutimes.sunyu?api_token=955e8eb6b6da951d97cd675966bde685" andParams:nil andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodGET andCompletionBlockWithSuccess:success andFailure:failure];
}
#pragma mark --- 升级
- (void)getDownloadInfoDict:(NSDictionary *)dict andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSMutableDictionary *paramDic = [self dataDicAndRequestCodeWithDic:dict andRequestCode:@"0630" andNetWorkType:NetWorkTypeHost];
    [self requestOperation:BASEURL andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
- (void)newUpLoadStreamData:(NSData*)commitData andUploadProgressWithBlock:(uploadProgressBlock)uploadProgressBlock andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure
{
    NSURL *url = [NSURL URLWithString:[UPLOADURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    
    [urlRequest setHTTPMethod:@"POST"];
    //  上传文件格式
    [urlRequest setValue:[NSString stringWithFormat:@"multipart/form-data"] forHTTPHeaderField:@"Content-Type"];
    [urlRequest setTimeoutInterval:60];
    /*
     NSString *string=[[NSString alloc] initWithData:commitData encoding:NSUTF8StringEncoding];
     NSLog(@"请求参数:%@",string);
       gbk编码
     NSData *gbkData = [string dataUsingEncoding:-2147482062];
     */

    [urlRequest setHTTPBody:commitData];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:urlRequest progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
            if (failure) {
                failure(nil,error);
            }
        }
        else
        {
            NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:-2147482062];
            NSLog(@"返回New上传数据:%@", dataStr);
            NSDictionary *dic = [dataStr objectFromJSONString];
            HttpResponse *response = [HttpResponse kyHttpResponseParse:dic];
            success(nil,response);
        }
    }];
//    NSURLSessionUploadTask *uploadTask=[manager uploadTaskWithStreamedRequest:urlRequest progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (error)
//        {
//            NSLog(@"%@",error);
//            
//        }
//        else
//        {
//            NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:-2147482062];
//            NSLog(@"返回New上传数据:%@", dataStr);
//            NSDictionary *dic = [dataStr objectFromJSONString];
//            HttpResponse *response = [HttpResponse jyHttpResponseParse:dic andNetWorkType:NetWorkTypeHost];
//            success(nil,response);
//        }
//    }];
    [uploadTask resume];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    manager.requestSerializer.stringEncoding = -2147482062;
//    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
//    [[manager POST:[UPLOADURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:[NSDictionary dictionary] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFormData:commitData name:@""];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"***%lld",uploadProgress.totalUnitCount);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:-2147482062];
//        NSLog(@"返回New上传数据:%@", dataStr);
//        NSDictionary *dic = [dataStr objectFromJSONString];
//        NSLog(@"***%@",dic[@"data"][@"message"]);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"***%@",error);
//    }] resume];
}
// 查询二维码
- (void)selectQR:(NSDictionary *)dataDic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success
      andFailure:(FailureBlock)failure{
    NSMutableDictionary *paramDic = [self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"0640" andNetWorkType:NetWorkTypeHost];
    [self requestOperation:BASEURL andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
- (void)startNetQueue{
    NSArray * array = [CommUtil readDataWithFileName:@"aaaaa"];
    NSMutableArray * arr = [NSMutableArray array];
    if (array.count != 0) {
        for (OperationModel * item in [CommUtil readDataWithFileName:@"aaaaa"]) {
            if (item.uploadStatus == statusFailed) {
                [arr addObject:item];
            }
        }
        [[TaskOperationManager shared]addTaskModels:arr];
        for (OperationModel * model  in [TaskOperationManager shared].taskModels) {
            NSLog(@"-----123456");
            [[TaskOperationManager shared]startUploadWithTaskModel:model];
        }
    }
}
@end
