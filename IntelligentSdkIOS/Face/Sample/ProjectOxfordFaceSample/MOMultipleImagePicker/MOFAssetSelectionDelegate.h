
//
//  MOFAssetSelectionDelegate.h
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MOFAssetSelectionDelegate <NSObject>

-(void)cancelPickImages;
-(void)finishPickImages:(NSArray *)images;

@end
