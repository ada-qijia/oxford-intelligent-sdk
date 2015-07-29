//
//  MOFImagesPickerController.h
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOFAssetSelectionDelegate.h"

@class MOFImagesPickerController;

@protocol MOFImagesPickerControllerDelegate <UINavigationControllerDelegate>

- (void)mofImagesPickerController:(MOFImagesPickerController *)picker didFinishPickingImages:(NSArray *)images;

@end

@interface MOFImagesPickerController : UINavigationController <MOFAssetSelectionDelegate>

@property (nonatomic, weak) id<MOFImagesPickerControllerDelegate> imagesPickerDelegate;

- (id)initImagesPicker;

@end
