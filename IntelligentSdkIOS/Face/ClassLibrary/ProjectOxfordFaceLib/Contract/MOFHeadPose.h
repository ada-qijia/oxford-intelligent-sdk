//
//  MOFHeadPose.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface MOFHeadPose : OptionalPropJSONModel

/** The roll of the face pose. */
@property (nonatomic, assign) float Roll;

/** The yaw of the face pose. */
@property (nonatomic, assign) float Yaw;

/** The pitch of the face pose. */
@property (nonatomic, assign) float Pitch;

@end
