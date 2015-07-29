//
//  SampleCommon.h
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ProjectOxfordFaceLib/ProjectOxfordFaceLib.h>

@interface SampleCommon : NSObject

+(void)AddFaceRectsToImageView:(UIImageView *)imageView faces:(NSArray *)faces;
+(void)RemoveAllFaceRectsInImageView:(UIImageView *)imageView;
+(CGRect)getAspectTargetRect:(CGSize)realSize targetSize:(CGSize)targetSize realRect:(CGRect)realRect;

@end
