//
//  PhotoViewController.m
//  KJ
//
//  Created by iOSDeveloper on 16/7/4.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//
NSInteger indexCount;
#import "PhotoViewController.h"
#import "PhotoViewCell.h"
#import "ZipArchive.h"
#import "OperationModel.h"
#import "TaskOperationManager.h"
#import "LocalPhotoViewController.h"



#define BASEOLDURL @"http://192.168.120.122:8080/suny/"
//#define BASEOLDURL @"http://www.suny123.com/suny/"
#define BASEURL [NSString stringWithFormat:@"%@pjhsAppDataInteractionServlet",BASEOLDURL]
#define UPLOADURL [NSString stringWithFormat:@"%@pjhsAppUploadZipDataPjInteractionServlet",BASEOLDURL]

@interface PhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,SelectPhotoDelegate>
@property (nonatomic, strong) UICollectionView * myCollectionView;
@property (nonatomic, strong) NSMutableArray * imagesArrays;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) CLLocationManager *locationManager;
//toolBar
@property (nonatomic, strong) UIView * toolBarView;
@property (nonatomic, strong) UIButton * btnUpload;

//  经度
@property (nonatomic, assign) float jyLongitude;
//  纬度
@property (nonatomic, assign) float jyLatitude;

@property (nonatomic, copy) NSString *photoAddress;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItemExtension leftBackButtonItem:@selector(backAciton) andTarget:self],[UIBarButtonItemExtension leftTitleItem:@"浏览照片"]];
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItemExtension rightButtonItem:@selector(right1) andTarget:self andButtonTitle:@"拍照"]];
    self.imagesArrays = [NSMutableArray array];
    if ([CommUtil readDataWithFileName:[NSString stringWithFormat:@"dataArray%@",self.id]]) {
        self.dataArray = [NSMutableArray arrayWithArray:[CommUtil readDataWithFileName:[NSString stringWithFormat:@"dataArray%@",self.id]]];
    }else{
        self.dataArray = [NSMutableArray array];
    }
    [self.view addSubview:self.toolBarView];
    [self.toolBarView addSubview:self.btnUpload];
    [self.view addSubview:self.myCollectionView];
    [self getNetWork];
    [self locationManagerOperation];
    // Do any additional setup after loading the view.
}
- (void)backAciton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)right1{
    
    [self localPhoto];
}
//从相册选择
-(void)localPhoto{
    LocalPhotoViewController *pick=[[LocalPhotoViewController alloc] init];
    pick.selectPhotoDelegate=self;
    //        pick.selectPhotos = _selectPhotosArray;
    [self.navigationController pushViewController:pick animated:YES];
    //        [self.evaluationPhotosArray removeAllObjects];
}
- (void)openCamera{
    //  是否支持打开相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
    }else{
        [self alertView:@"您没有摄像头"];
    }
}
- (UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, DeviceSize.width, DeviceSize.height - 49 - 64) collectionViewLayout:flowLayout];
        _myCollectionView.backgroundColor = [UIColor colorWithHEX:0xcccccc];
        [_myCollectionView registerClass:[PhotoViewCell class] forCellWithReuseIdentifier:@"myCell"];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
    }
    return _myCollectionView;
}
- (UIView *)toolBarView{
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceSize.height - 49, DeviceSize.width, 49)];
    }
    return _toolBarView;
}
- (UIButton *)btnUpload{
    if (!_btnUpload) {
        _btnUpload = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnUpload.frame = CGRectMake(15, (self.toolBarView.height - 40)/2, self.toolBarView.width - 30, 40);
        _btnUpload.layer.cornerRadius = 6.0f;
        _btnUpload.layer.masksToBounds = YES;
        _btnUpload.backgroundColor = [UIColor colorWithHEX:0x20c6c6];
        [_btnUpload setTitle:@"上传照片" forState:UIControlStateNormal];
        [_btnUpload addTarget:self action:@selector(btnUploadClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnUpload;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArr.count;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DeviceSize.width - 30)/3, (DeviceSize.width - 30)/3);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoViewCell *cell = (PhotoViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    [cell configWithModel:self.photoArr[indexPath.row]];
    [self.imagesArrays addObject:cell.imgView];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.myCollectionView; // 原图的父控件
    browser.imageCount = self.photoArr.count; // 图片总数
    browser.currentImageIndex = indexPath.row;
    browser.delegate = self;
    WeakSelf(PhotoViewController);
    [browser setDeletePhotoBlock:^(NSInteger index){
        if (index < weakSelf.photoArr.count) {
            [weakSelf.photoArr removeObjectAtIndex:index];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString * picName = self.dataArray[index - indexCount];
            if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",ImagesPath,picName]]) {
                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",ImagesPath,picName] error:nil];
            }
            [self.dataArray removeObjectAtIndex:index - indexCount];
            [self.imagesArrays removeAllObjects];
            [CommUtil saveData:self.dataArray andSaveFileName:[NSString stringWithFormat:@"dataArray%@",self.id]];
            [self.myCollectionView reloadData];
            
        }
    }];
    [browser show];
}
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    UIImageView * imgView = self.imagesArrays[index];
    return imgView.image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSRange range = [[self.photoArr[index] objectForKey:@"url"] rangeOfString:@"http"];
    if (range.location != NSNotFound) {
        NSString *urlStr = [self.photoArr[index] objectForKey:@"url"];
        return [NSURL URLWithString:urlStr];
    }
    NSString *urlStr = [self.photoArr[index] objectForKey:@"url"];
    return [NSURL URLWithString:urlStr];
}
- (void)getNetWork{
    WeakSelf(PhotoViewController);
    if (!self.id) {
        [self showHudAuto:@"数据不完整" andDuration:@"2"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self showHudWaitingView:WaitPrompt];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:[CommUtil readDataWithFileName:@"userName"] forKey:@"username"];
    [dict setObject:self.id forKey:@"remid"];
    [[NetWorkManager shareNetWork]getDownloadInfoDict:dict andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if (response.responseCode == 631) {
            weakSelf.photoArr = [NSMutableArray arrayWithArray:response.dataDic[@"piclist"]];
            for (NSString * name in weakSelf.dataArray) {
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                [dict setObject:name forKey:@"url"];
                [weakSelf.photoArr addObject:dict];
            }
            indexCount = weakSelf.photoArr.count - weakSelf.dataArray.count;
            [weakSelf.myCollectionView reloadData];
        }else{
            [weakSelf showHudAuto:response.message andDuration:@"2"];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf showHudAuto:InternetFailerPrompt];
    }];
}
- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera
        ;
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            //bug：Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates. 解决
            _imagePicker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }
        
    }
    return _imagePicker;
}
#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获得编辑过的图片
    UIImage* image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
        //判断图片是不是png格式的文件
        /*
         if (UIImagePNGRepresentation(image)) {
         //返回为png图像。
         data = UIImagePNGRepresentation(image);
         }else {
         //返回为JPEG图像。
         data = UIImageJPEGRepresentation(image, 1.0);
         }
         */
        image = [image imageZoomToSize_Ext:CGSizeMake(280*2,320*2)];
        //  给图片添加文字描述
        NSDate *date = [NSDate date];
        NSString *dateStr = [date dateString:@"yyyy-MM-dd HH:mm:ss"];
        if (!self.photoAddress) {
             self.photoAddress = @"";
        }
        NSString *address = self.photoAddress;
        
        if ([address rangeOfString:@","].location != NSNotFound) {
            address = [address substringToIndex:[address rangeOfString:@","].location];
        }
        
        image = [image drawStringForImage:image andDescription:[NSString stringWithFormat:@"%@\n%@\n%@\n%@",self.ljbzmc,address,self.cph,dateStr]];
        
        data = UIImageJPEGRepresentation(image, 0.5);
        NSLog(@"data:%lu",(unsigned long)data.length);
        
        NSString *dateString = [date dateString:@"yyyy-MM-dd_HHmmssSSSSSS"];
        //  uuid
        NSString *partId = self.id;
        //  图片名称
        NSString *picName = [NSString stringWithFormat:@"%@_%@.jpg",dateString,partId];
        //  判断路径是否存在，不存在创建指定路径
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //  图片路径
        NSString *picNamePath = @"";
        if (![fileManager fileExistsAtPath:ImagesPath]) {
            [fileManager createDirectoryAtPath:ImagesPath withIntermediateDirectories:YES attributes:nil error:nil];
            
        }
        picNamePath = [NSString stringWithFormat:@"%@/%@",ImagesPath,picName];
        //  图片写入沙河路径
        BOOL isOk = [data writeToFile:picNamePath atomically:YES];
        //  保存沙盒图片路径
        if (isOk) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setObject:picName forKey:@"url"];
            //  修改零件图片标记和图片
            [self.photoArr addObject:dict];
            
            [self.dataArray addObject:picName];
            //  重新加载数据
            [self.imagesArrays removeAllObjects];
            [CommUtil saveData:self.dataArray andSaveFileName:[NSString stringWithFormat:@"dataArray%@",self.id]];
            [self.myCollectionView reloadData];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)locationManagerOperation{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        [self alertView:@"定位服务当前可能尚未打开，请设置打开!"];
        
        return;
    }
    // 1. 实例化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 2. 设置代理
    _locationManager.delegate = self;
    // 3. 定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    _locationManager.distanceFilter = 5;
    // 4.请求用户权限：分为：?只在前台开启定位?在后台也可定位，
    //注意：建议只请求?和?中的一个，如果两个权限都需要，只请求?即可，
    //??这样的顺序，将导致bug：第一次启动程序后，系统将只请求?的权限，?的权限系统不会请求，只会在下一次启动应用时请求?
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [_locationManager requestWhenInUseAuthorization];//?只在前台开启定位
    }
    // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。
    /*
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
     _locationManager.allowsBackgroundLocationUpdates = YES;
     }
     */
    // 6. 更新用户位置
    [_locationManager startUpdatingLocation];
}

- (void)reverseGeocodeWithLongitude:(float)logitude andLatitude:(float)latitude
{
    CLLocation *reverseLocation = [[CLLocation alloc] initWithLatitude:self.jyLatitude longitude:self.jyLongitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    WeakSelf(PhotoViewController);
    [geocoder reverseGeocodeLocation:reverseLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            weakSelf.photoAddress = placemark.name;
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            
        }
    }];
}

#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations lastObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    // NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //如果不需要实时定位，使用完即使关闭定位服务
    self.jyLongitude = coordinate.longitude;
    self.jyLatitude = coordinate.latitude;
    //    NSString *urlString=[NSString stringWithFormat:kGetReverseGeocode,location_.coordinate.longitude,location_.coordinate.latitude];
    if (![LocationConvertBaiduLocaltion isLocationOutOfChina:coordinate]) {
        //转换后的coord
        CLLocationCoordinate2D revereCoord = [LocationConvertBaiduLocaltion transformFromWGSToGCJ:coordinate];
        self.jyLongitude = revereCoord.longitude;
        self.jyLatitude = revereCoord.latitude;
        [self reverseGeocodeWithLongitude:revereCoord.longitude andLatitude:revereCoord.latitude];
        
    }else {
        //    [self reverseGeocodeWithlocation:self.lastLocation];
        [self reverseGeocodeWithLongitude:self.jyLongitude andLatitude:self.jyLatitude];
    }
    //  两种方式获取位置
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    //  没有开启定位服务的判断，自己app的定位服务
    if (status<=2) {
        //  判断是不是第一次定位
        static NSInteger notDeterminedCount  = 0;
        
        notDeterminedCount ++;
        if (notDeterminedCount > 2) {
            [self alertView:@"定位服务关闭"];
        }
        
    }
}
#pragma mark ------
#pragma mark 上传照片点击事件
- (void)btnUploadClick:(UIButton *)button{
    if (self.dataArray.count == 0) {
        [self showHudAuto:@"未进行拍照不能上传"];
        return;
    }
//    [self showHudWaitingView:@"正在上传照片..."];
    NSMutableDictionary * commitDic = [NSMutableDictionary dictionary];
    [commitDic setObject:[CommUtil readDataWithFileName:@"userName"] forKey:@"username"];
    [commitDic setObject:self.id forKey:@"goodListId"];
    [commitDic setObject:self.ghdh forKey:@"goodNo"];
    NSString *commitJson = [commitDic JSONString];
    //  文件写入用gbk
    NSLog(@"%@",ImagesPath);
    BOOL isok =[commitJson writeToFile:[ImagesPath stringByAppendingPathComponent:@"fitAppTempFile2015.json"] atomically:YES encoding:-2147482062 error:nil];
    if (isok) {
        NSLog(@"写入成功");
    } else {
        NSLog(@"写入失败");
    }
    //  压缩文件也放到图片的那个文件夹里面，提交后一起删除文件夹
    ZipArchive *archiveTrailer = [[ZipArchive alloc] initWithFileManager:[NSFileManager defaultManager]];
    [archiveTrailer CreateZipFile2:[ImagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",@"fitAppTempFile2015"]]];
    [archiveTrailer addFileToZip:[ImagesPath stringByAppendingPathComponent:@"fitAppTempFile2015.json"] newname:@"fitAppTempFile2015.json"];
    
    for (NSString *picName in self.dataArray) {
        //  获取路径的文件名
        NSString *imageNamePath = [NSString stringWithFormat:@"%@/%@",ImagesPath,picName];
        //  把文件添加到压缩包里面
        [archiveTrailer addFileToZip:imageNamePath newname:picName];
    }
    [archiveTrailer CloseZipFile2];
    
    //  读取数据进行上传
    NSData *commitData = [self readCommitData];
    WeakSelf(PhotoViewController);
//    OperationModel * model = [[OperationModel alloc]init];
//    model.uplodeUrl = UPLOADURL;
//    model.commitData = commitData;
//    model.uploadStatus = statusFailed;
//    model.operationId = [NSString queryUUID];
//    NSMutableArray * arr = [NSMutableArray array];
//    [arr addObject:model];
//    [CommUtil saveData:arr andSaveFileName:@"aaaaa"];
//    [[TaskOperationManager shared] addTaskModels:[CommUtil readDataWithFileName:@"aaaaa"]];
//    OperationModel * item = [TaskOperationManager shared] .taskModels[0];
//    [[TaskOperationManager shared] startUploadWithTaskModel:item];

    [[NetWorkManager shareNetWork]newUpLoadStreamData:commitData andUploadProgressWithBlock:^(long long bytesSent, long long totalBytesSent, long long totalBytesExpectedToSend) {
        
    } andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if (response.responseCode == 310) {
            [weakSelf showHudAuto:response.dataDic[@"message"]];
            [weakSelf performSelector:@selector(uploadFinish) withObject:nil afterDelay:0.15];
        } else {
            [weakSelf showHudAuto:response.dataDic[@"message"]];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf showHudAuto:InternetFailerPrompt];
    }];
}
- (void)uploadFinish
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:ImagesPath]){
        if ([fileManager removeItemAtPath:ImagesPath error:nil]){                                                                                                                   NSLog(@"remove success");
            [CommUtil deleteDateWithFileName:[NSString stringWithFormat:@"dataArray%@",self.id]];
//            NSInteger count = self.photoArr.count - 1;
//            for (int i = 0; i < self.dataArray.count; i++) {
//                [self.photoArr removeObjectAtIndex:count - i];
//            }
//            [self.dataArray removeAllObjects];
//            //  重新加载数据
//            [self.imagesArrays removeAllObjects];
//            
//            [self.myCollectionView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
//  读取提交数据
- (NSData *)readCommitData
{
    NSString *commitZipPath = [ImagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",@"fitAppTempFile2015"]];
    NSData *bodyData = [NSData dataWithContentsOfFile:commitZipPath];
    return bodyData;
    
}
- (void)getSelectedPhoto:(NSMutableArray *)photos{
    [self showHudWaitingView:@"正在加载请稍后"];
    NSLog(@" photos.count %lu",(unsigned long)photos.count);
    //    self.selectPhotosArray = photos; // 用来再次进入相册时显示已选照片
    for (int i = 0; i < photos.count; i ++) {
        id asset;
        CGImageRef posterImageRef;
        UIImage *image;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
            //        [self.evaluationPhotosArray addObject:posterImage];
            asset = (ALAsset *)[photos objectAtIndex:i];
            posterImageRef = [asset aspectRatioThumbnail];
            image = [UIImage imageWithCGImage:posterImageRef];
        }else{
            image = (UIImage *)[photos objectAtIndex:i];
        }
        [self getLibImage:image];
    }
    [self removeMBProgressHudInManaual];
    [self.myCollectionView reloadData];
}
- (void)getLibImage:(UIImage *)image{
    //获得编辑过的图片

    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
        //判断图片是不是png格式的文件
        /*
         if (UIImagePNGRepresentation(image)) {
         //返回为png图像。
         data = UIImagePNGRepresentation(image);
         }else {
         //返回为JPEG图像。
         data = UIImageJPEGRepresentation(image, 1.0);
         }
         */
        image = [image imageZoomToSize_Ext:CGSizeMake(280*2,320*2)];
        //  给图片添加文字描述
        NSDate *date = [NSDate date];
        NSString *dateStr = [date dateString:@"yyyy-MM-dd HH:mm:ss"];
        if (!self.photoAddress) {
            self.photoAddress = @"";
        }
        NSString *address = self.photoAddress;
        
        if ([address rangeOfString:@","].location != NSNotFound) {
            address = [address substringToIndex:[address rangeOfString:@","].location];
        }
        
        image = [image drawStringForImage:image andDescription:[NSString stringWithFormat:@"%@\n%@\n%@\n%@",self.ljbzmc,address,self.cph,dateStr]];
        
        data = UIImageJPEGRepresentation(image, 0.5);
        NSLog(@"data:%lu",(unsigned long)data.length);
        
        NSString *dateString = [date dateString:@"yyyy-MM-dd_HHmmssSSSSSS"];
        //  uuid
        NSString *partId = self.id;
        //  图片名称
        NSString *picName = [NSString stringWithFormat:@"%@_%@.jpg",dateString,partId];
        //  判断路径是否存在，不存在创建指定路径
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //  图片路径
        NSString *picNamePath = @"";
        if (![fileManager fileExistsAtPath:ImagesPath]) {
            [fileManager createDirectoryAtPath:ImagesPath withIntermediateDirectories:YES attributes:nil error:nil];
            
        }
        picNamePath = [NSString stringWithFormat:@"%@/%@",ImagesPath,picName];
        //  图片写入沙河路径
        BOOL isOk = [data writeToFile:picNamePath atomically:YES];
        //  保存沙盒图片路径
        if (isOk) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setObject:picName forKey:@"url"];
            //  修改零件图片标记和图片
            [self.photoArr addObject:dict];
            
            [self.dataArray addObject:picName];
            //  重新加载数据
            [self.imagesArrays removeAllObjects];
            [CommUtil saveData:self.dataArray andSaveFileName:[NSString stringWithFormat:@"dataArray%@",self.id]];
            [self.myCollectionView reloadData];
        }
    }
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
