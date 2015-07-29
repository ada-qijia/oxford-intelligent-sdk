//
//  Rectangle.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OptionalPropJSONModel.h"

@interface Rectangle:  OptionalPropJSONModel

@property (nonatomic, assign) int Left;
@property (nonatomic, assign) int Top;
@property (nonatomic, assign) int Width;
@property (nonatomic, assign) int Height;

+(instancetype) FromString:(NSString*) str;

@end
