//
//  FindSimilarViewController.h
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MOFImagesPickerController.h"

@interface FindSimilarViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MOFImagesPickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *CandidatesCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *QueryImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *SimilarCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *StatusTextView;

- (IBAction)ChooseCandidates:(id)sender;
- (IBAction)ChooseQueryFace:(id)sender;
- (IBAction)FindSimilar:(id)sender;
@end
