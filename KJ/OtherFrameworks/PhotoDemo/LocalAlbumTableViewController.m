//
//  LocalAlbumTableViewController.m
//  AlbumTest
//
//  Created by ejiang on 14-7-28.
//  Copyright (c) 2014年 daijier. All rights reserved.
//

#import "LocalAlbumTableViewController.h"
#import <Photos/Photos.h>

@interface LocalAlbumTableViewController ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *albums;
@end

@implementation LocalAlbumTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIBarButtonItem *cancle=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleAction)];
        self.navigationItem.rightBarButtonItem=cancle;
        self.title=@"选择相册";
        // self.navigationController=[[UINavigationController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
    //        self.edgesForExtendedLayout = UIRectEdgeNone;
    //        self.extendedLayoutIncludesOpaqueBars = NO;
    //        self.modalPresentationCapturesStatusBarAppearance = NO;
    //    }
    
    //    if (self.assetsLibrary == nil) {
    //        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    //    }
    if (self.albums == nil) {
        _albums = [[NSMutableArray alloc] init];
    } else {
        [self.albums removeAllObjects];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LocalAlbumCell" bundle:nil] forCellReuseIdentifier:@"AlbumCell"];
    // setup our failure view controller in case enumerateGroupsWithTypes fails
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
            
            NSString *errorMessage = nil;
            switch ([error code]) {
                case ALAssetsLibraryAccessUserDeniedError:
                case ALAssetsLibraryAccessGloballyDeniedError:
                    errorMessage = @"The user has declined access to it.";
                    break;
                default:
                    errorMessage = @"Reason unknown.";
                    break;
            }
            
        };
        
        // emumerate through our groups and only add groups that contain photos
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            if ([group numberOfAssets] > 0)
            {
                [self.albums addObject:group];
            }
            else
            {
                [self.tableView reloadData];
                //[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        };
        
        // enumerate only photos
        NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
        [[AssetHelper defaultAssetsLibrary] enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
    }else{
        _albums = [self GetPhotoListDatas];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cancleAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num=[_albums count];
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"AlbumCell";
    LocalAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        ALAssetsGroup *group=[_albums objectAtIndex:indexPath.row];
        CGImageRef posterImageRef=[group posterImage];
        UIImage *posterImage=[UIImage imageWithCGImage:posterImageRef];
        [cell.imgCover setImage:posterImage];
        cell.lbName.text = [group valueForProperty:ALAssetsGroupPropertyName];
        cell.lbCount.text = [@(group.numberOfAssets) stringValue];
    }else{
        PHAssetCollection * collectionItem = [self.albums objectAtIndex:indexPath.row];
        if ([collectionItem isKindOfClass:[PHAssetCollection class]]) {
            PHFetchResult *group = [PHAsset fetchAssetsInAssetCollection:collectionItem options:nil];
            [[PHImageManager defaultManager] requestImageForAsset:group.lastObject targetSize:CGSizeMake(200,200)contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                if (result == nil) {
                    cell.imgCover.image = [UIImage imageNamed:@""];
                }else{
                    cell.imgCover.image = result;
                }
            }];
            PHAssetCollection *titleAsset = collectionItem;
            
            if ([titleAsset.localizedTitle isEqualToString:@"All Photos"]) {
                cell.lbName.text = @"相机胶卷";
            }else{
                cell.lbName.text = [NSString stringWithFormat:@"%@",titleAsset.localizedTitle];
            }
            cell.lbCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)group.count];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if(self.delegate!=nil)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0){
            [self.delegate selectAlbum:self.albums[indexPath.row]];
        }else{
            [self.delegate selectPHAlbum:self.albums[indexPath.row]];
        }
    }
    
}
-(NSMutableArray *)GetPhotoListDatas
{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
    PHAssetCollection * phAsset = [[PHAssetCollection alloc]init];
    if (smartAlbumsFetchResult.count != 0) {
        phAsset = [smartAlbumsFetchResult objectAtIndex:0];
        [dataArray addObject:phAsset];
    }

    PHFetchResult *smartAlbumsFetchResult1 = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:fetchOptions];
    
    for (PHAssetCollection *sub in smartAlbumsFetchResult1)
    {
        [dataArray addObject:sub];
    }
    
    return dataArray;
}

@end
