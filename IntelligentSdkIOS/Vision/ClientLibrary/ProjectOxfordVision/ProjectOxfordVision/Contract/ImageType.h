//
//  ImageType.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface ImageType : OptionalPropJSONModel

@property (nonatomic, assign) int ClipArtType;
@property (nonatomic, assign) int LineDrawingType;

@end
