//
//  MOFFaceAttribute.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"
#import "MOFHeadPose.h"

@interface MOFFaceAttribute : OptionalPropJSONModel

/** The age of detected face. */
@property (nonatomic, assign) double Age;

/** The gender. */
@property (nonatomic, strong) NSString *Gender;

/** The head pose. */
@property (nonatomic, strong) MOFHeadPose *HeadPose;

@end
