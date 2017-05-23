//
//  PhotoViewCell.h
//  KJ
//
//  Created by iOSDeveloper on 16/7/4.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView * imgView;
- (void)configWithModel:(NSDictionary *)dict;
@end
