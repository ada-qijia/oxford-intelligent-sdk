//
//  MOFFace.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"
#import "MOFFaceRectangle.h"
#import "MOFFaceLandmarks.h"
#import "MOFFaceAttribute.h"

@protocol MOFFace <NSObject>

@end

@interface MOFFace : OptionalPropJSONModel <MOFFace>

/** The face identifier. */
@property (nonatomic, strong) NSUUID *FaceId;

/** The face rectangle. */
@property (nonatomic, strong) MOFFaceRectangle *FaceRectangle;

/** The face landmarks. */
@property (nonatomic, strong) MOFFaceLandmarks *FaceLandmarks;

/** The attributes. */
@property (nonatomic, strong) MOFFaceAttribute *Attributes;

@end
