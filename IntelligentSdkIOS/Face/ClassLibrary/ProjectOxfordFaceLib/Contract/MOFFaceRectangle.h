//
//  MOFFaceRectangle.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface MOFFaceRectangle : OptionalPropJSONModel

/** The width of the face rectangle. */
@property (nonatomic, assign) int Width;

/** The height of the face rectangle. */
@property (nonatomic, assign) int Height;

/** The left of the face rectangle. */
@property (nonatomic, assign) int Left;

/** The top of the face rectangle. */
@property (nonatomic, assign) int Top;

@end
