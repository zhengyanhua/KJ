//
//  LocalPhotoViewController.h
//  AlbumTest
//
//  Created by ejiang on 14-7-28.
//  Copyright (c) 2014年 daijier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LocalPhotoCell.h"
#import "LocalAlbumTableViewController.h"
#import "AssetHelper.h"
@class ViewController;
@protocol SelectPhotoDelegate<NSObject>
-(void)getSelectedPhoto:(NSMutableArray *)photos;
@end
@interface LocalPhotoViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,SelectAlbumDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *toolView;

- (IBAction)btnConfirm:(id)sender;
@property (nonatomic,retain) id<SelectPhotoDelegate> selectPhotoDelegate;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) ALAssetsGroup *currentAlbum;
@property (nonatomic, strong) NSMutableArray *selectPhotos;
@end
