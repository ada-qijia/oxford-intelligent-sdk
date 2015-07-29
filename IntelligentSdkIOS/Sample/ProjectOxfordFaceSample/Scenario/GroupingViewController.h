//
//  GroupingViewController.h
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MOFImagesPickerController.h"

@interface GroupingViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MOFImagesPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *ImagesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *GroupCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *ResultTextView;

- (IBAction)ChooseImagesClicked:(id)sender;
- (IBAction)GroupClicked:(id)sender;

@end
