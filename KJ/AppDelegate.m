//
//  AppDelegate.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "OperationModel.h"
#import "TaskOperationManager.h"
#import "AFNetworkReachabilityManager.h"
#import "NetWorkManager.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSString *updateUrl;
@property (nonatomic, strong) UIAlertView *alert;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                [[NetWorkManager shareNetWork]startNetQueue];
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                [[NetWorkManager shareNetWork]startNetQueue];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                [[NetWorkManager shareNetWork]startNetQueue];
                break;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
    
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = loginVC;
    [self setAppStyle];
    [self.window makeKeyAndVisible];
    [self upgradeInfoNetWork];
    return YES;
}
- (void)setAppStyle
{
    //  在general 勾选了hide status bar 隐藏了状态栏，启动后显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //  设置info.plist文件中View controller-based status bar appearance设为NO才起作用
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHEX:0x20c6c6]];
    
    //  设置选中图片的tintcolor
    [[UITabBar appearance] setTintColor:[UIColor colorWithHEX:0x20c6c6]];
    //  设置UITabBarItem的选中文字颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithHEX:0x20c6c6], NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateSelected];
}

- (UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}

- (void)upgradeInfoNetWork{
    NSDictionary * dict = @{@"id":@"com.jingyoutimes.sunyu",@"api_token":@"955e8eb6b6da951d97cd675966bde685"};
    WeakSelf(AppDelegate);
    [[NetWorkManager shareNetWork]upgradeInfo:dict andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        
        NSString *version = [response.uploadDic objectForKey:@"version"];
        NSString *update_url = [response.uploadDic objectForKey:@"update_url"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
        if ([version doubleValue]>[app_Version doubleValue]) {
            weakSelf.updateUrl = update_url;
            [weakSelf showAlert:0];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (UIAlertView *)alert{
    if (!_alert) {
        _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新的版本更新，是否前往更新" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消",nil];
        _alert.tag = 10000;
    }
    return _alert;
}
-(void)showAlert:(int)count
{
    if (count == 1) {
        [self.alert show];
    }
    else
    {
        [self.alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex == 0) {
            NSURL *url = [NSURL URLWithString:self.updateUrl];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
