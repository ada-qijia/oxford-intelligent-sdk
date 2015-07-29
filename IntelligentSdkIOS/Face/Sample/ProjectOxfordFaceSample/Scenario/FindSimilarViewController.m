//
//  FindSimilarViewController.m
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "FindSimilarViewController.h"
#import "AppDelegate.h"
#import "SampleCommon.h"

@interface FindSimilarViewController ()

@property NSMutableArray *candidateImages;
@property NSMutableDictionary *candidateFaces;//NSUUID(faceId) as key, cripped UIImage as value.
@property NSMutableArray *similarFaces; //NSUUID(faceId) array
@property NSMutableArray *queryFaces; //NSUUID(faceId) array

@end

static NSString * const reuseIdentifier = @"Cell";

@implementation FindSimilarViewController
{
    MOFFaceServiceClient *client;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Find Similar";
    
    //Modify DescriptionLabel top constraint to relative to topLayoutGuide
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.DescriptionLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.topLayoutGuide
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:8.0];
    [self.view removeConstraint:(NSLayoutConstraint *)self.view.constraints[2]];
    [self.view addConstraint:constraint];
    
    //initialize MOFFaceServiceClient
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    client = appDelegate.client;
    
    // Register cell classes
    [self.CandidatesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.SimilarCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //initialize property
    self.candidateFaces = [NSMutableDictionary dictionary];
    self.similarFaces = [NSMutableArray array];
    self.queryFaces = [NSMutableArray array];
    
    [self prepareCandidateImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Interaction

- (IBAction)ChooseCandidates:(id)sender {
    MOFImagesPickerController *imagesPicker = [[MOFImagesPickerController alloc] initImagesPicker];
    imagesPicker.imagesPickerDelegate = self;
    
    [self presentViewController:imagesPicker animated:YES completion:nil];
}

- (IBAction)ChooseQueryFace:(id)sender {
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

- (IBAction)FindSimilar:(id)sender {
    [self.similarFaces removeAllObjects];
    [self.SimilarCollectionView reloadData];
    [self.candidateFaces removeAllObjects];
    [self.queryFaces removeAllObjects];
    
    dispatch_group_t group = dispatch_group_create();
    
    //detect faces
    if(self.candidateImages.count>0)
    {
        [self DetectFaces:self.candidateImages isCandidates:YES inGroup:group];
    }
    [self DetectFaces:[NSArray arrayWithObject:self.QueryImageView.image] isCandidates:NO inGroup:group];
    
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_notify(group, defaultQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.CandidatesCollectionView reloadData];
            [self updateStatus:@"Detect faces complete."];
        });
        
        //find similar
        if(self.queryFaces.count == 1 && self.candidateFaces.count >0){
            [self updateStatus:@"Finding similar..."];
            [client findSimilarFacesWithFaceId:self.queryFaces[0] fromFaceIds:self.candidateFaces.allKeys completionHandler:^(NSArray<MOFSimilarFace> *result, NSError *error) {
                if(result)
                {
                    for (MOFSimilarFace *face in result) {
                        [self.similarFaces addObject:face.FaceId];
                    }
                }
                
                //update UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.SimilarCollectionView reloadData];
                });
                NSString *status= result? @"Find similar success.": [NSString stringWithFormat:@"Find similar failed: %@", error];
                [self updateStatus:status];
            }];
        }
        else
        {
            [self updateStatus:@"For this scenario Subject should contain one face. Candidate should contain at least one face."];
        }
    });
}

#pragma mark - MOFImagesPickerControllerDelegate Methods

- (void)mofImagesPickerController:(MOFImagesPickerController *)picker didFinishPickingImages:(NSArray *)images
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if(images.count >0)
    {
        [self.candidateImages removeAllObjects];
        for (ALAsset *asset in images) {
            //use thumbnail to detect
            UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
            
            //use original image to detect
            //            ALAssetRepresentation *rep = [asset defaultRepresentation];
            //            UIImage *image = [UIImage imageWithCGImage:[rep fullResolutionImage]];
            [self.candidateImages addObject:image];
        }
        
        [self.CandidatesCollectionView reloadData];
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    self.QueryImageView.image = image;
    [SampleCommon RemoveAllFaceRectsInImageView:self.QueryImageView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger num = collectionView == self.CandidatesCollectionView? self.candidateImages.count : self.similarFaces.count;
    return num;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
    [cell.contentView addSubview:imgView];
    
    if(collectionView == self.CandidatesCollectionView){
        imgView.image = self.candidateImages[indexPath.row];
    }
    else{
        NSUUID *faceId = (NSUUID *)self.similarFaces[indexPath.row];
        imgView.image = (UIImage *)[self.candidateFaces objectForKey:faceId];
    }
    
    return cell;
}

#pragma mark - Custom Methods

-(void)DetectFaces:(NSArray *)images isCandidates:(bool)isCandidates inGroup:(dispatch_group_t)group
{
    if(images.count == 0)
        return;
    
    self.StatusTextView.text = nil;
    for (UIImage *image in images) {
        NSInteger index = [images indexOfObject:image];
        [self updateStatus:[NSString stringWithFormat:@"Detect faces in image %ld of %@...", (long)index, isCandidates? @"Candidates":@"Subject"]];
        dispatch_group_enter(group);
        
        NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
        [client detectFacesWithImageData:imgData analyzesFacelandmarks:true analyzesAge:true analyzesGender:true analyzesHeadPose:true completionHandler:^(NSArray<MOFFace> *result, NSError *error) {
            if(result)
            {
                if(isCandidates){
                    for (MOFFace *face in result) {
                        if([self.candidateFaces objectForKey:face.FaceId] == nil)
                        {
                            CGRect rect = CGRectMake(face.FaceRectangle.Left, face.FaceRectangle.Top, face.FaceRectangle.Width, face.FaceRectangle.Height);
                            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
                            [self.candidateFaces setObject:[UIImage imageWithCGImage:imageRef] forKey:face.FaceId];
                        }
                    }}
                else{
                    for (MOFFace *face in result) {
                        [self.queryFaces addObject:face.FaceId];
                    }
                    [SampleCommon AddFaceRectsToImageView:self.QueryImageView faces:result];
                }
            }
            
            //update UI
            NSString *status= result? [NSString stringWithFormat:@"Detect %ld faces in image %ld",(long)result.count, (long)index]: [NSString stringWithFormat:@"Detect faces in image %ld failed: %@",(long)index, error];
            [self updateStatus:status];
            
            dispatch_group_leave(group);
        }];
    }
}

-(void)prepareCandidateImages{
    self.candidateImages=[NSMutableArray array];
    [self.candidateImages addObject:[UIImage imageNamed:@"Family1-Dad2.jpg"]];
    [self.candidateImages addObject:[UIImage imageNamed:@"Family1-Daughter1.jpg"]];
    [self.candidateImages addObject:[UIImage imageNamed:@"Family1.jpg"]];
}

-(void)updateStatus:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.StatusTextView insertText:[NSString stringWithFormat:@"\n %@",message]];
    });
}

@end
