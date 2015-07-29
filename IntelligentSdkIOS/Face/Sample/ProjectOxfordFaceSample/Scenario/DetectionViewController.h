//
//  DetectionDetailViewController.h
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ProjectOxfordFaceLib/ProjectOxfordFaceLib.h>

@interface DetectionViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *ResultLabel;
@property (weak, nonatomic) IBOutlet UITextView *StatusTextView;
@property (weak, nonatomic) IBOutlet UITableView *FacesTable;

- (IBAction)ChooseImageClicked:(id)sender;
- (IBAction)DetectClicked:(id)sender;

@end
