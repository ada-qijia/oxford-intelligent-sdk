//
//  MOFImagePickerController.m
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "MOFImagePickerController.h"

@interface MOFImagePickerController ()

@property (nonatomic, strong) NSMutableArray *assets;

@end

@implementation MOFImagePickerController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];    
    self.collectionView.allowsMultipleSelection = YES;
    
    [self.navigationItem setTitle:@"Albums"];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    [self.navigationItem setRightBarButtonItem:doneButtonItem];
    
    self.assets = [NSMutableArray array];
    [self PrepareAssets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)PrepareAssets{
    [self.assets removeAllObjects];
    
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result == nil) {
            return;
        }
        
        if([result valueForProperty:ALAssetPropertyType] == ALAssetTypePhoto){
            [self.assets addObject:result];
        }
    }];
    
    [self.collectionView reloadData];
}

- (void)doneAction:(id)sender
{
    self.selectedImages = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        [self.selectedImages addObject:self.assets[indexPath.row]];
    }
    
    if([self.parent respondsToSelector:@selector(finishPickImages:)])
    {
        [self.parent finishPickImages:self.selectedImages];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.assets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if(cell.selectedBackgroundView == nil)
    {
        UIView *view =[[UIView alloc] init];
        view.backgroundColor = [UIColor blueColor];
        cell.selectedBackgroundView = view;
    }
    
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:3];
    if(imgView == nil)
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectInset(cell.contentView.frame, 3, 3)];
        imgView.tag = 3;
        [cell.contentView addSubview:imgView];
    }

    ALAsset * asset = self.assets[indexPath.row];
    imgView.image = [UIImage imageWithCGImage:asset.thumbnail];

    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
@end
