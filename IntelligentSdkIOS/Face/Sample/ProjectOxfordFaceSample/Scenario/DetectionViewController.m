//
//  DetectionDetailViewController.m
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "DetectionViewController.h"
#import "AppDelegate.h"
#import "LooseTableViewCell.h"
#import "SampleCommon.h"

@interface DetectionViewController ()

@property NSArray *faces;

@end

@implementation DetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Detection";
    self.FacesTable.contentInset = UIEdgeInsetsMake(0, -15, 0, -15);
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - user interaction

//present image picker.
- (IBAction)ChooseImageClicked:(id)sender {
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

- (IBAction)DetectClicked:(id)sender {
    [self detectFaces];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    self.ImageView.image=image;
    [self clearUI];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.faces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell)
    {
        cell = [[LooseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    MOFFace *face = (MOFFace *)self.faces[indexPath.row];
    cell.textLabel.text = face.Attributes.Gender;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f years old", face.Attributes.Age];
    
    CGRect rect = CGRectMake(face.FaceRectangle.Left, face.FaceRectangle.Top, face.FaceRectangle.Width, face.FaceRectangle.Height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.ImageView.image CGImage], rect);
    cell.imageView.image =[UIImage imageWithCGImage:imageRef];
    return cell;
}

#pragma mark - custom methods

-(void)clearUI{
    self.ResultLabel.text = nil;
    self.StatusTextView.text = nil;
    self.faces = nil;
    [self.FacesTable reloadData];
    
    [SampleCommon RemoveAllFaceRectsInImageView:self.ImageView];
}

-(void)detectFaces{
    self.StatusTextView.text = nil;
    [self updateStatus: @"Detecting..."];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MOFFaceServiceClient *client = appDelegate.client;
    
    NSData *imgData = UIImageJPEGRepresentation(self.ImageView.image, 1.0);
    [client detectFacesWithImageData:imgData analyzesFacelandmarks:true analyzesAge:true analyzesGender:true analyzesHeadPose:true completionHandler:^(NSArray<MOFFace> *result, NSError *error) {
        if(result) {self.faces = result;}
        
        //update UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if(result)
            {
                self.ResultLabel.text = [NSString stringWithFormat: @"%ld face(s) detected", (unsigned long)result.count];
                
                [self.FacesTable reloadData];
                [self updateStatus: @"Detect Success."];
                
                [SampleCommon AddFaceRectsToImageView:self.ImageView faces:self.faces];
            }
            else
            {
                [self updateStatus:[NSString stringWithFormat:@"Detect Failed: %@", error]];
            }
        });
    }];
}


-(void)updateStatus:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.StatusTextView insertText:[NSString stringWithFormat:@"\n %@",message]];
    });
}

@end
