//
//  MOFFeatureCoordinate.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface MOFFeatureCoordinate : OptionalPropJSONModel

/** The x of the feature coordinate. */
@property (nonatomic, assign) double X;

/** The y of the feature coordinate. */
@property (nonatomic, assign) double Y;

@end
