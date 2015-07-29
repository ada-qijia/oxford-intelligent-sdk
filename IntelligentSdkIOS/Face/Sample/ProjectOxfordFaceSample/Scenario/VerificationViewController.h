//
//  VerificationDetailViewController.h
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *LeftImage;
@property (weak, nonatomic) IBOutlet UIImageView *RightImage;
@property (weak, nonatomic) IBOutlet UITextView *ResultTextView;

- (IBAction)ChooseImageLeftClicked:(id)sender;
- (IBAction)ChooseImageRightClicked:(id)sender;
- (IBAction)VerifyClicked:(id)sender;

@end
