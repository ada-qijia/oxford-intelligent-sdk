//
//  OthersViewController.h
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OthersViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *MethodsPikcerView;
@property (weak, nonatomic) IBOutlet UITextView *ResultTextView;

- (IBAction)GoClicked:(id)sender;

@end
