//
//  LoginViewController.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/25.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "LoginViewController.h"
#import "TitleView.h"
#import "LoginView.h"
#import "MainViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) UIImageView * imgLogo;
@property (nonatomic, strong) TitleView * titleView;
@property (nonatomic, strong) LoginView * loginView;
@property (nonatomic, strong) UIButton * btnLogin;

@end

@implementation LoginViewController
- (void)loadView{
    [super loadView];
    self.view = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceSize.width, DeviceSize.height)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imgLogo];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.btnLogin];
}

#pragma mark ------
#pragma mark 标题view
- (UIImageView *)imgLogo{
    if (!_imgLogo) {
        _imgLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, ( 200 * DeviceSize.width / 375))];
        _imgLogo.image = [UIImage imageNamed:@"logo"];
    }
    return _imgLogo;
}

- (TitleView *)titleView{
    if (!_titleView) {
        _titleView = [[TitleView alloc]initWithFrame:CGRectMake(0,self.imgLogo.bottom , DeviceSize.width, 40)];
        _titleView.labTitle.text = @"损益物资数据采集系统";
    }
    return _titleView;
}
- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, self.titleView.bottom + 40, DeviceSize.width, 90)];
        if ([CommUtil readDataWithFileName:@"userName"]) {
            self.loginView.textName.text = [CommUtil readDataWithFileName:@"userName"];
        }
        if ([CommUtil readDataWithFileName:@"password"]) {
            self.loginView.textPwd.text = [CommUtil readDataWithFileName:@"password"];
        }
    }
    return _loginView;
}
- (UIButton *)btnLogin{
    if (!_btnLogin) {
        _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLogin.frame = CGRectMake(20, self.loginView.bottom + 20, DeviceSize.width - 40,45);
        [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        _btnLogin.backgroundColor = [UIColor colorWithHEX:0x20c6c6];
        _btnLogin.layer.cornerRadius = 8.0f;
        _btnLogin.layer.masksToBounds = YES;
        [_btnLogin addTarget:self action:@selector(btnLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLogin;
}
- (void)btnLoginClick:(UIButton *)button{
    [self.view endEditing:YES];
    NSString *userName = self.loginView.textName.text;
    NSString *userPassword = self.loginView.textPwd.text;
    if ([userName isNULL]) {
        [self showHudAuto:@"请输入用户名"];
    } else if ([userPassword isNULL]) {
        [self showHudAuto:@"请输入密码"];
    } else {
        NSString *password = [NSString stringWithFormat:@"%@%@",userPassword,userName];
        
        NSDictionary *dataDic = @{@"username":userName,@"password":[password toMD5]};
        
        [self showHudWaitingView:WaitPrompt];
        WeakSelf(LoginViewController);
        [[NetWorkManager shareNetWork] loginOperation:dataDic andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
            [weakSelf removeMBProgressHudInManaual];
            if (response.responseCode == 101) {
                [CommUtil saveData:userName andSaveFileName:@"userName"];
                [CommUtil saveData:userPassword andSaveFileName:@"password"];
                [weakSelf mainVCOperation];
            } else {
                NSLog(@"%@",response.dataDic[@"message"]);
                [weakSelf showHudAuto:response.dataDic[@"message"] andDuration:@"2"];
            }
            
        } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
            
            [weakSelf showHudAuto:InternetFailerPrompt];
        }];
        
    }
    
}
//  进去基础信息页面
- (void)mainVCOperation
{
    MainViewController * mvc = [[MainViewController alloc]init];
    UINavigationController * navc = [[UINavigationController alloc]initWithRootViewController:mvc];
    [self presentViewController:navc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
