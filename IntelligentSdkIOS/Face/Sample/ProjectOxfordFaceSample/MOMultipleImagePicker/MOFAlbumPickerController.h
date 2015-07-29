//
//  MOFAlbumPickerController.h
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MOFAssetSelectionDelegate.h"

@interface MOFAlbumPickerController : UITableViewController 

@property (nonatomic, weak) id<MOFAssetSelectionDelegate> parent;
@property (nonatomic, strong) NSMutableArray *assetGroups;

@end
