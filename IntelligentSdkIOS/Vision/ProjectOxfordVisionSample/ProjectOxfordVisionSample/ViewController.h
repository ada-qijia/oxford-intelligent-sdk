//
//  ViewController.h
//  projectoxford.visionExample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *InputTypeSegment;
@property (weak, nonatomic) IBOutlet UITextField *UrlTextField;
@property (weak, nonatomic) IBOutlet UIButton *ChooseImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *SourceImage;
@property (weak, nonatomic) IBOutlet UIImageView *ResultImage;
@property (weak, nonatomic) IBOutlet UITextView *ResultTextView;
@property (weak, nonatomic) IBOutlet UITextField *WidthTextField;
@property (weak, nonatomic) IBOutlet UITextField *HeightTextField;
@property (weak, nonatomic) IBOutlet UISwitch *SmartCroppingSwitch;

- (IBAction)InputTypeChanged:(id)sender;
- (IBAction)ChooseImage:(id)sender;
- (IBAction)AnalyzeImage:(id)sender;
- (IBAction)GetThumbnail:(id)sender;
- (IBAction)RecognizeText:(id)sender;

@end

