//
//  VerificationDetailViewController.m
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "VerificationViewController.h"
#import "AppDelegate.h"
#import "SampleCommon.h"

@interface VerificationViewController ()

@end

@implementation VerificationViewController
{
    BOOL isChoosingLeftImage;
    NSArray *leftFaces;
    NSArray *rightFaces;
    MOFFaceServiceClient *client;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Verification";
    
    //Modify DescriptionLabel top constraint to relative to topLayoutGuide
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.DescriptionLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.topLayoutGuide
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:8.0];
    [self.view removeConstraint:(NSLayoutConstraint *)self.view.constraints[0]];
    [self.view addConstraint:constraint];
    
    client=((AppDelegate *)[[UIApplication sharedApplication] delegate]).client;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - user interaction

- (IBAction)ChooseImageLeftClicked:(id)sender {
    isChoosingLeftImage = YES;
    [self ChooseImage];
}

- (IBAction)ChooseImageRightClicked:(id)sender {
    isChoosingLeftImage = NO;
    [self ChooseImage];
}

- (IBAction)VerifyClicked:(id)sender {
    self.ResultTextView.text = nil;
    
    //detect faces
    dispatch_group_t group = dispatch_group_create();

    if(leftFaces == nil)
    {
        [self detectFacesInImage:self.LeftImage.image isLeft:YES inGroup:group];
    }
    if(rightFaces == nil)
    {
        [self detectFacesInImage:self.RightImage.image isLeft:NO inGroup:group];
    }
   
    //verify faces
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_notify(group, defaultQueue, ^{
    if(leftFaces.count == 1 && rightFaces.count == 1)
    {
        [self updateStatus:@"Verifying..."];
        
        NSUUID *leftFaceUUID = ((MOFFace *)leftFaces[0]).FaceId;
        NSUUID *rightFaceUUID = ((MOFFace *)rightFaces[0]).FaceId;
        
        [self updateStatus:[NSString stringWithFormat:@"Verifying face %@ and %@...",[leftFaceUUID UUIDString], [rightFaceUUID UUIDString]]];
        [client verfifyFaceWithId:leftFaceUUID faceId2:rightFaceUUID completionHandler:^(MOFVerifyResult *result, NSError *error) {
                if(result)
                {
                    [self updateStatus:[NSString stringWithFormat:@"Two faces %@belong to the same person with confidence %.2f.", result.IsIdentical? @"" : @"not ", result.Confidence]];
                }
                else
                {
                    [self updateStatus:[NSString stringWithFormat:@"Detect Failed: %@", error]];
                }
        }];}
    else
    {
        [self updateStatus:@"Verification accepts two faces as input, please pick images with only one detectable face in it."];
    }
    });
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    if(isChoosingLeftImage)
    {
        self.LeftImage.image = image;
        [SampleCommon RemoveAllFaceRectsInImageView:self.LeftImage];
        leftFaces = nil;
    }
    else
    {
        self.RightImage.image = image;
        [SampleCommon RemoveAllFaceRectsInImageView:self.RightImage];
        rightFaces = nil;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - custom methods

-(void)ChooseImage{
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

-(void)detectFacesInImage:(UIImage *)image isLeft:(BOOL)isLeft inGroup:(dispatch_group_t)group{
    [self updateStatus:[NSString stringWithFormat:@"Detect faces in the %@ image...", isLeft? @"left" : @"right"]];
    
    dispatch_group_enter(group);
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    
    [client detectFacesWithImageData:imgData analyzesFacelandmarks:true analyzesAge:true analyzesGender:true analyzesHeadPose:true completionHandler:^(NSArray<MOFFace> *result, NSError *error) {
            if(result)
            {
                if(isLeft)
                {
                    leftFaces = result;
                    [SampleCommon AddFaceRectsToImageView:self.LeftImage faces:leftFaces];
                    [self updateStatus:[NSString stringWithFormat: @"%ld face(s) has been detected in the left image.", (unsigned long)result.count]];
                }
                else
                {
                    rightFaces = result;
                    [SampleCommon AddFaceRectsToImageView:self.RightImage faces:rightFaces];
                    [self updateStatus:[NSString stringWithFormat: @"%ld face(s) has been detected in the right image.", (unsigned long)result.count]];
                }}
            else
            {
                [self updateStatus:[NSString stringWithFormat:@"Detect Failed: %@", error]];
            }
        dispatch_group_leave(group);
    }];
}

-(void)updateStatus:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ResultTextView insertText:[NSString stringWithFormat:@"\n %@",message]];
    });
}

@end
