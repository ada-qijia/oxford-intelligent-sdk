//
//  AnalysisResult.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MetaData.h"
#import "ImageType.h"
#import "Color.h"
#import "Adult.h"
#import "VisionCategory.h"
#import "Face.h"

#import "OptionalPropJSONModel.h"

@interface AnalysisResult : OptionalPropJSONModel

/** The request identifier. */
@property (nonatomic, strong) NSString * RequestId;

/** The metadata. */
@property (nonatomic, strong) Metadata * Metadata;

/** The type of the image. */
@property (nonatomic, strong) ImageType * ImageType;

/** The color. */
@property (nonatomic, strong) Color * Color;

/** The adult. */
@property (nonatomic, strong) Adult* Adult;

/** The categories. */
@property (nonatomic, strong) NSArray<VisionCategory> * Categories;

/** The faces. */
@property (nonatomic, strong) NSArray<Face> * Faces;

@end
