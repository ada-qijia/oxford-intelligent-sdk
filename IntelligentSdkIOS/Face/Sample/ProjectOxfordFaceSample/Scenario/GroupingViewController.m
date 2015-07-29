//
//  GroupingViewController.m
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "GroupingViewController.h"
#import "AppDelegate.h"

@interface GroupingViewController ()

@property NSMutableArray *selectedImages; //array of UIImage.

@end

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseHeaderIdentifier = @"Header";

@implementation GroupingViewController
{
    NSMutableDictionary *faces; //NSUUID(faceId) as key, cripped UIImage as value.
    NSMutableArray *faceGroups; //array of nsstring(faceId) array
    BOOL hasMessyGroup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Grouping";
    
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
    
    // Register cell classes
    [self.ImagesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.GroupCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.GroupCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.GroupCollectionView.collectionViewLayout;
    flowLayout.headerReferenceSize = CGSizeMake(self.GroupCollectionView.frame.size.width, 30.f);
    
    //initialize variable
    faces = [NSMutableDictionary dictionary];
    faceGroups = [NSMutableArray array];
    
    [self prepareSelectedImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI interaction

- (IBAction)ChooseImagesClicked:(id)sender {
    MOFImagesPickerController *imagesPicker = [[MOFImagesPickerController alloc] initImagesPicker];
    imagesPicker.imagesPickerDelegate = self;
    
    [self presentViewController:imagesPicker animated:YES completion:nil];
}

- (IBAction)GroupClicked:(id)sender {
    if(self.selectedImages.count > 0)
    {
        [self GroupFacesInImages:self.selectedImages];
    }
    else
    {
        [self updateStatus:@"please select images first."];
    }
}

#pragma mark - MOFImagesPickerControllerDelegate Methods

- (void)mofImagesPickerController:(MOFImagesPickerController *)picker didFinishPickingImages:(NSArray *)images
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if(images.count >0)
    {
        self.selectedImages = [NSMutableArray array];
        for (ALAsset *asset in images) {
            //use thumbnail to detect
            UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
            [self.selectedImages addObject:image];
            
            /*
             //use original image to detect
             ALAssetRepresentation *rep = [asset defaultRepresentation];
             UIImage *image = [UIImage imageWithCGImage:[rep fullResolutionImage]];
             [self.selectedImages addObject:image];*/
        }
        [self.ImagesCollectionView reloadData];
    }
}

#pragma mark -  UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.ImagesCollectionView)
    {
        return self.selectedImages.count;
    }
    else
    {
        NSArray *array = (NSArray *)faceGroups[section];
        return array.count;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger num = collectionView == self.ImagesCollectionView? 1 : faceGroups.count;
    return num;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:3];
    if(imgView == nil)
    {
        imgView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
        imgView.tag = 3;
        [cell.contentView addSubview:imgView];
    }
    
    if(collectionView == self.ImagesCollectionView){
        imgView.image =(UIImage *)self.selectedImages[indexPath.row];
    }
    else{
        NSArray *faceGroup = (NSArray *)faceGroups[indexPath.section];
        NSString *faceId = (NSString *)faceGroup[indexPath.row];
        imgView.image = (UIImage *)[faces objectForKey:[[NSUUID alloc] initWithUUIDString:faceId]];
    }
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.GroupCollectionView && kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView* cell = [self.GroupCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                      withReuseIdentifier:reuseHeaderIdentifier
                                                                                             forIndexPath:indexPath];
        UILabel *titleLabel =(UILabel *)[cell viewWithTag:3];
        if(titleLabel == nil)
        {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            titleLabel.tag =3;
            [cell addSubview:titleLabel];
        }
        
        if(hasMessyGroup && indexPath.section == faceGroups.count-1) {
            titleLabel.text = @"Messy Group";
        }
        else {
            titleLabel.text = [NSString stringWithFormat:@"Group %ld", (long)indexPath.section +1];
        }
        return cell;
    }
    return nil;
}

#pragma mark - custom methods

/**
 * @param images UIImage array.
 */
- (void) GroupFacesInImages:(NSArray *)images
{
    [faces removeAllObjects];
    [faceGroups removeAllObjects];
    [self.GroupCollectionView reloadData];
    
    hasMessyGroup = NO;
    
    if(images.count > 0)
    {
        self.ResultTextView.text = nil;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MOFFaceServiceClient *client = appDelegate.client;
        
        //detect faces
        dispatch_group_t group = dispatch_group_create();
        for (UIImage *image in images) {
            NSInteger index=[images indexOfObject:image];
            [self updateStatus:[NSString stringWithFormat:@"Detect faces in image %ld...", (long)index]];
            
            dispatch_group_enter(group);
            
            NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
            [client detectFacesWithImageData:imgData analyzesFacelandmarks:true analyzesAge:true analyzesGender:true analyzesHeadPose:true completionHandler:^(NSArray<MOFFace> *result, NSError *error) {
                if(result)
                {
                    for (MOFFace *face in result) {
                        if([faces objectForKey:face.FaceId] == nil)
                        {
                            CGRect rect = CGRectMake(face.FaceRectangle.Left, face.FaceRectangle.Top, face.FaceRectangle.Width, face.FaceRectangle.Height);
                            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
                            [faces setObject:[UIImage imageWithCGImage:imageRef] forKey:face.FaceId];
                        }
                    }
                }
                
                //update UI
                NSString *status= result? [NSString stringWithFormat:@"Detect %ld faces in image %ld",(long)result.count, (long)index]: [NSString stringWithFormat:@"Detect faces in image %ld failed: %@",(long)index, error];
                [self updateStatus:status];
                
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_notify(group, defaultQueue, ^{
            [self updateStatus:@"Grouping faces..."];
            
            //group faces
            [client groupFaces:[faces allKeys] completionHandler:^(MOFGroupResult *result, NSError *error) {
                //handle the result
                if(result)
                {
                    for (NSArray *faceGroup in result.Groups) {
                        [faceGroups addObject:faceGroup];
                    }
                    
                    hasMessyGroup = result.MessyGroup.count >0;
                    if(hasMessyGroup)
                    {
                        [faceGroups addObject:result.MessyGroup];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.GroupCollectionView reloadData];
                    NSString *status = result? @"Group success": [NSString stringWithFormat:@"Group failed: %@", error];
                    [self updateStatus:status];
                });
            }];
        });
    }
}

-(void)updateStatus:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ResultTextView insertText:[NSString stringWithFormat:@"\n %@",message]];
    });
}

-(void)prepareSelectedImages{
    self.selectedImages=[NSMutableArray array];
    [self.selectedImages addObject:[UIImage imageNamed:@"Family1-Dad1.jpg"]];
    [self.selectedImages addObject:[UIImage imageNamed:@"Family1-Dad2.jpg"]];
    [self.selectedImages addObject:[UIImage imageNamed:@"Family1-Daughter1.jpg"]];
    [self.selectedImages addObject:[UIImage imageNamed:@"Family1.jpg"]];
}
@end