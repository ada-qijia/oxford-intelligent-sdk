
//
//  MOFImagesPickerController.m
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "MOFImagesPickerController.h"
#import "MOFAlbumPickerController.h"
#import "MOFImagePickerController.h"

@interface MOFImagesPickerController ()

@end

@implementation MOFImagesPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

- (id)initImagesPicker
{
    MOFAlbumPickerController *albumPicker = [[MOFAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    albumPicker.parent = self;
    
    self = [super initWithRootViewController:albumPicker];
    return self;
}

#pragma mark - MOFAssetSelectionDelegate

-(void)cancelPickImages
{
    if ([self.imagesPickerDelegate respondsToSelector:@selector(mofImagesPickerController:didFinishPickingImages:)]) {
        [self.imagesPickerDelegate mofImagesPickerController:self didFinishPickingImages:nil];
    }
    else {
        [self popToRootViewControllerAnimated:NO];
    }
}

-(void)finishPickImages:(NSArray *)images
{
    if ([self.imagesPickerDelegate respondsToSelector:@selector(mofImagesPickerController:didFinishPickingImages:)]) {
        [self.imagesPickerDelegate mofImagesPickerController:self didFinishPickingImages:images];
    }
    else {
        [self popToRootViewControllerAnimated:NO];
    }
}

@end
