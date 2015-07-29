//
//  FaceRectangle.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface FaceRectangle : OptionalPropJSONModel

@property (nonatomic, assign) int Width;
@property (nonatomic, assign) int Height;
@property (nonatomic, assign) int Left;
@property (nonatomic, assign) int Top;

@end
