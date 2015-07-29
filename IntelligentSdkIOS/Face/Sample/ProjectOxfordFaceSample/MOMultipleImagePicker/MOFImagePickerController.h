//
//  MOFImagePickerController.h
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MOFAssetSelectionDelegate.h"

@interface MOFImagePickerController : UICollectionViewController

@property (nonatomic, weak) id<MOFAssetSelectionDelegate> parent;
@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, strong) NSMutableArray *selectedImages;

@end
