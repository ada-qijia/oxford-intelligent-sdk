//
//  Color.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface Color : OptionalPropJSONModel

@property (nonatomic, strong) NSString* AccentColor;
@property (nonatomic, strong) NSString* DominantColorForeground;
@property (nonatomic, strong) NSString* DominantColorBackground;
@property (nonatomic, strong) NSArray * DominantColors;

/** A value indicating whether this instance is binary image. */
@property (nonatomic, assign) BOOL IsBWImg;

@end
