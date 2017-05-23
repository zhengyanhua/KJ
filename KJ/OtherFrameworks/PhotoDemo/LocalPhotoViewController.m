//
//  LocalPhotoViewController.m
//  AlbumTest
//
//  Created by ejiang on 14-7-28.
//  Copyright (c) 2014年 daijier. All rights reserved.
//

#import "LocalPhotoViewController.h"
#import <Photos/Photos.h>

@interface LocalPhotoViewController ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property(strong,nonatomic) PHFetchResult *fetch;
@end

@implementation LocalPhotoViewController{
    UIBarButtonItem *btnDone;
    NSMutableArray *selectPhotoNames;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clearData)];
    self.title = @"选择照片";
    if (self.selectPhotos.count == 0) {
        self.confirmButton.userInteractionEnabled = NO;
        self.confirmButton.alpha = 0.4;
    }
    
    if(self.selectPhotos==nil)
    {
        self.selectPhotos = [[NSMutableArray alloc] init];
        selectPhotoNames = [[NSMutableArray alloc] init];
    }else{
        selectPhotoNames = [[NSMutableArray alloc] init];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
            for (ALAsset *asset in self.selectPhotos ) {
                //NSLog(@"%@",[asset valueForProperty:ALAssetPropertyAssetURL]);
                [selectPhotoNames addObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
            }
        }else{
            for (PHAsset *asset in self.selectPhotos) {
                [selectPhotoNames addObject:[asset localIdentifier]];
            }
        }
        self.lbAlert.text=[NSString stringWithFormat:@"已经选择%lu张照片",(unsigned long)self.selectPhotos.count];
    }
    
    self.collection.dataSource = self;
    self.collection.delegate = self;
    [self.collection registerNib:[UINib nibWithNibName:@"LocalPhotoCell" bundle:nil]  forCellWithReuseIdentifier: @"cellIdentifier"];
    //self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    btnDone=[[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(albumAction)];
    self.navigationItem.rightBarButtonItem = btnDone;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0){
        NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            
            if ([group numberOfAssets] > 0)
            {
                [self showPhoto:group];
            }
            else
            {
                NSLog(@"读取相册完毕");
                //[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        };
        
        [[AssetHelper defaultAssetsLibrary] enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock                                    failureBlock:nil];
    }else{
    
        if (!self.photos) {
            _photos = [[NSMutableArray alloc] init];
        } else {
            [self.photos removeAllObjects];
            
        }
        self.photos = [self GetPhotoAssets:[self GetCameraRollFetchResul]];
    }
    self.toolView.backgroundColor = [UIColor grayColor];
}
- (PHFetchResult *)GetCameraRollFetchResul
{
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
    
    PHAssetCollection * phAsset = [[PHAssetCollection alloc]init];
    if (smartAlbumsFetchResult.count != 0) {
        phAsset = [smartAlbumsFetchResult objectAtIndex:0];
    }
    PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:phAsset options:nil];
    return fetch;
}
- (NSMutableArray *)GetPhotoAssets:(PHFetchResult *)fetchResult
{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult) {
        //只添加图片类型资源，去除视频类型资源
        //当mediaType == 2时，这个资源则为视频资源
        if (asset.mediaType == 1) {
            [dataArray insertObject:asset atIndex:0];
        }
        
    }
    return dataArray;
}
- (void)clearData
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearData" object:nil];
//    DLog(@"返回-------");
}


- (void)albumAction{
    [self.selectPhotos removeAllObjects];
    [selectPhotoNames removeAllObjects];
    LocalAlbumTableViewController *album=[[LocalAlbumTableViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:album];
    album.delegate=self;
    [self.navigationController presentViewController:nvc animated:YES completion:^(void){
        NSLog(@"开始");
    }];
    // [self.navigationController pushViewController:album animated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LocalPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"cellIdentifier" forIndexPath:indexPath];
    // load the asset for this cell
    cell.backgroundColor = [UIColor greenColor];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0){
        ALAsset *asset=self.photos[indexPath.row];
        CGImageRef thumbnailImageRef = [asset thumbnail];
        UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
        [cell.img setImage:thumbnail];
        NSString *url=[asset valueForProperty:ALAssetPropertyAssetURL];
        [cell.btnSelect setHidden:[selectPhotoNames indexOfObject:url]==NSNotFound];
    }else{
        PHAsset *phAsset = [self.photos objectAtIndex:indexPath.row];
        if ([[self.photos objectAtIndex:indexPath.row] isKindOfClass:[PHAsset class]]) {
            
            
            [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info){
                cell.img.image = result;
                
            }];
            
        }
        NSString *url=[phAsset localIdentifier];
        [cell.btnSelect setHidden:[selectPhotoNames indexOfObject:url]==NSNotFound];
    }
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = (DeviceSize.width - 40)/4;
    return CGSizeMake(size, size);
}
//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LocalPhotoCell *cell=(LocalPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(cell.btnSelect.hidden)
    {
        if (self.selectPhotos.count < 9) {
            [cell.btnSelect setHidden:NO];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0){
                ALAsset *asset=self.photos[indexPath.row];
                [self.selectPhotos addObject:asset];
                [selectPhotoNames addObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
            }else{
                PHAsset *asset = self.photos[indexPath.row];
                [self.selectPhotos addObject:asset];
                [selectPhotoNames addObject:asset.localIdentifier];
            }
        }else{
            [self showHudAuto:@"最多只能选择9张照片"];
        }
    }else{
        [cell.btnSelect setHidden:YES];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
            ALAsset *asset=self.photos[indexPath.row];
            for (ALAsset *a in self.selectPhotos) {
                //            NSLog(@"%@-----%@",[asset valueForProperty:ALAssetPropertyAssetURL],[a valueForProperty:ALAssetPropertyAssetURL]);
                NSString *str1=[asset valueForProperty:ALAssetPropertyAssetURL];
                NSString *str2=[a valueForProperty:ALAssetPropertyAssetURL];
                if([str1 isEqual:str2])
                {
                    [self.selectPhotos removeObject:a];
                    break;
                }
            }
            
            [selectPhotoNames removeObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
        }else{
            PHAsset *asset=self.photos[indexPath.row];
            for (PHAsset *a in self.selectPhotos) {
                //            NSLog(@"%@-----%@",[asset valueForProperty:ALAssetPropertyAssetURL],[a valueForProperty:ALAssetPropertyAssetURL]);
                NSString *str1=[asset localIdentifier];
                NSString *str2=[a localIdentifier];
                if([str1 isEqual:str2])
                {
                    [self.selectPhotos removeObject:a];
                    break;
                }
            }
            
            [selectPhotoNames removeObject:[asset localIdentifier]];
        }
    }
    
    if(self.selectPhotos.count==0)
    {
        self.lbAlert.text=@"请选择照片";
        self.confirmButton.userInteractionEnabled = NO;
        self.confirmButton.alpha = 0.4;
    }
    else{
        if (self.selectPhotos.count != 0) {
            self.confirmButton.userInteractionEnabled = YES;
            self.confirmButton.alpha = 1.0;
        }
        self.lbAlert.text=[NSString stringWithFormat:@"已经选择%lu张照片",(unsigned long)self.selectPhotos.count];
//        DLog(@"self.selectPhotos.count %lu --------",(unsigned long)self.selectPhotos.count);

    }
}

- (IBAction)btnConfirm:(id)sender {
    if (self.selectPhotoDelegate!=nil) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0){
            [self.selectPhotoDelegate getSelectedPhoto:self.selectPhotos];
        }else{
            NSMutableArray *photos = [NSMutableArray array];
            WeakSelf(LocalPhotoViewController);
            for (int i = 0; i < self.selectPhotos.count; i++) {
                id asset = [self.selectPhotos objectAtIndex:i];
                [self GetImageObject:asset complection:^(UIImage *photo ,BOOL isDegradedResult) {
                    if (isDegradedResult) {
                        return;
                    }
                    if (photo){
                        [photos addObject:photo];
                    }
                    if (photos.count < self.selectPhotos.count){
                        return;
                    }
                    if (photos.count == self.selectPhotos.count){
                        [weakSelf.selectPhotoDelegate getSelectedPhoto:photos];
                        
                    }
                }];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) showPhoto:(ALAssetsGroup *)album
{
    if(album!=nil)
    {
        if(self.currentAlbum==nil||![[self.currentAlbum valueForProperty:ALAssetsGroupPropertyName] isEqualToString:[album valueForProperty:ALAssetsGroupPropertyName]])
        {
            self.currentAlbum=album;
            if (!self.photos) {
                _photos = [[NSMutableArray alloc] init];
            } else {
                [self.photos removeAllObjects];
                
            }
            ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [self.photos insertObject:result atIndex:0];
                }else{
                }
            };
            
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [self.currentAlbum setAssetsFilter:onlyPhotosFilter];
            [self.currentAlbum enumerateAssetsUsingBlock:assetsEnumerationBlock];
            self.title = [self.currentAlbum valueForProperty:ALAssetsGroupPropertyName];
            [self.collection reloadData];
        }
    }
}
- (void)GetImageObject:(id)asset complection:(void (^)(UIImage *, BOOL isDegraded))complection
{
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        
        CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined) {
                if (complection) complection(result,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
        }];
        
    }
    
}

- (void)selectAlbum:(ALAssetsGroup *)album{
    [self showPhoto:album];
}
- (void)selectPHAlbum:(PHAssetCollection *)assetCollection{
    
    self.photos = [self GetPhotoAssets:[self GetFetchResult:assetCollection]];
    self.title = assetCollection.localizedTitle;
    [self.collection reloadData];
}
- (PHFetchResult *)GetFetchResult:(PHAssetCollection *)assetCollection
{
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    return fetchResult;
    
}
@end
