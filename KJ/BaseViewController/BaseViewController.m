//
//  BaseViewController.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupModel.h"
#import "DownloadListModel.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHEX:0xf5f5f5];
    // 导航栏设置成不透明的，兼容有导航控制器和没有导航控制器的显示问题
    if (self.navigationController) {
        _frameTopHeight = 64;   //  导航栏+状态栏 = 64
        _viewTop = 0;           //  导航栏设置不透明的所以top = 0
    } else {
        _frameTopHeight = 20;   //  状态栏 = 20
        _viewTop = 20;          //  没有导航控制器top 需要加上20高度的导航栏，要不然状态栏会被状态栏挡住
    }
}
- (BOOL)equalInfoArray:(NSMutableArray *)array obj:(NSString *)obj{
    NSInteger i = 0;
    self.arrIndex = 0;
    for (GroupModel * item in array) {
        if ([item.GD isEqualToString:obj]) {
            self.arrIndex = i;
            return YES;
        }
        i++;
    }
    return NO;
}

- (NSMutableArray *)getGroupInfoArray:(NSMutableArray *)array{
    NSMutableArray * ar = [NSMutableArray array];
    for (int i=0; i<[array count]; i++) {
        GroupModel * item = [[GroupModel alloc]init];
        item.list = [NSMutableArray array];
        item.GD = [array[i] ghdh];
        item.cph = [array[i] cph];
        [item.list addObject:array[i]];
        for (int j = i + 1; j<[array count]; j++) {
            if ([[[array objectAtIndex:i] ghdh] isEqualToString:[[array objectAtIndex:j] ghdh]]) {
                [item.list addObject:[array objectAtIndex:j]];
            }
        }
        if ([item.list count] > 0) {
            item.count = item.list.count;
            [ar addObject:item];
            [array removeObjectsInArray:item.list];
            i -= 1;    //去除重复数据 新数组开始遍历位置不变
        }
    }
    return ar;
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
