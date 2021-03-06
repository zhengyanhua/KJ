//
//  LocalAlbumTableViewController.h
//  AlbumTest
//
//  Created by ejiang on 14-7-28.
//  Copyright (c) 2014年 daijier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetHelper.h"
#import "LocalAlbumCell.h"
#import <Photos/Photos.h>

@protocol SelectAlbumDelegate<NSObject>
-(void)selectAlbum:(ALAssetsGroup *)album;
-(void)selectPHAlbum:(PHAssetCollection *)assetCollection;
@end

@interface LocalAlbumTableViewController : UITableViewController
@property(nonatomic,assign) id<SelectAlbumDelegate> delegate;
@end
