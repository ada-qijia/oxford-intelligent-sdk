//
//  ViewController.m
//  projectoxford.visionExample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "ViewController.h"
#import <ProjectOxfordVision/ProjectOxfordVision.h>

static NSString * const kSubscriptionKey = @"";

@interface ViewController ()

@end

@implementation ViewController
{
    VisionServiceClient *client;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    client=[[VisionServiceClient alloc] initWithSubscriptionKey:kSubscriptionKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//dismiss the keyborad
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UI Interaction

- (IBAction)InputTypeChanged:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    BOOL isUrl = segment.selectedSegmentIndex == 0;
    self.UrlTextField.hidden = !isUrl;
    self.ChooseImageButton.hidden = isUrl;
    self.SourceImage.hidden = isUrl;
}

- (IBAction)ChooseImage:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Invalid Operation" message:@"SourceType is not supported!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
        [alert show];
    }
}

- (IBAction)AnalyzeImage:(id)sender {
    [self resetResultUI:NO];
    
    if(self.InputTypeSegment.selectedSegmentIndex == 0)
    {
        NSString *url = self.UrlTextField.text;
        [client AnalyzeImageFromUrl:url visualFeatures:nil completionHandler:^(AnalysisResult *result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ResultTextView.text = [NSString stringWithFormat:@"%@", error == nil? result:error];
            });
        }];
    }
    else
    {
        NSData *imageData = UIImageJPEGRepresentation(self.SourceImage.image, 1.0);
        [client AnalyzeImageWithData:imageData visualFeatures:nil completionHandler:^(AnalysisResult *result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ResultTextView.text = [NSString stringWithFormat:@"%@", error == nil? result:error];
            });
        }];
    }
}

- (IBAction)GetThumbnail:(id)sender {
    [self resetResultUI:YES];
    
    int width = [self.WidthTextField.text intValue];
    int height = [self.HeightTextField.text intValue];
    BOOL smartCropping = self.SmartCroppingSwitch.isOn;
    
    if(width == 0 || height == 0)
    {
        [self resetResultUI:NO];
        self.ResultTextView.text = @"Error: Both width and height should be int value.";
        return;
    }
    
    if(self.InputTypeSegment.selectedSegmentIndex == 0)
    {
        NSString *url = self.UrlTextField.text;
        [client GetThumbnailFromUrl:url width:width height:height smartCropping:smartCropping completionHandler:^(NSData *thumbnailData, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if(error)
                 {
                     [self showError:error];
                 }
                 else
                 {
                     self.ResultImage.image=[UIImage imageWithData:thumbnailData];
                 }
             });
         }];
    }
    else
    {
        NSData *imageData = UIImageJPEGRepresentation(self.SourceImage.image, 1.0);
        [client GetThumbnailWithData:imageData width:width height:height smartCropping:smartCropping completionHandler:^(NSData *thumbnailData, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if(error)
                 {
                     [self showError:error];
                 }
                 else
                 {
                     self.ResultImage.image=[UIImage imageWithData:thumbnailData];
                 }
             });
         }];
    }
}

- (IBAction)RecognizeText:(id)sender {
    [self resetResultUI:NO];
    
    if(self.InputTypeSegment.selectedSegmentIndex == 0)
    {
        NSString *url = self.UrlTextField.text;
        [client RecognizeTextFromUrl:url completionHandler:^(OcrResults *result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ResultTextView.text = [NSString stringWithFormat:@"%@", error == nil? result:error];
            });
        }];
    }
    else
    {
        NSData *imageData = UIImageJPEGRepresentation(self.SourceImage.image, 1.0);
        [client RecognizeTextWithData:imageData completionHandler:^(OcrResults *result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ResultTextView.text = [NSString stringWithFormat:@"%@", error == nil? result:error];
            });
        }];
    }
}

-(void)resetResultUI:(BOOL)isImageData
{
    self.ResultTextView.hidden = isImageData;
    self.ResultImage.hidden = !isImageData;
    self.ResultImage.image = nil;
    self.ResultTextView.text = @"...";
}

-(void)showError:(NSError *)error
{
    [self resetResultUI:NO];
    self.ResultTextView.text = [NSString stringWithFormat:@"%@", error];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    self.SourceImage.image=image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
