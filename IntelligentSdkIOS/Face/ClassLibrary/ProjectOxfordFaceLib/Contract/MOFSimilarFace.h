//
//  MOFSimilarFace.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@protocol MOFSimilarFace <NSObject>

@end

@interface MOFSimilarFace : OptionalPropJSONModel <MOFSimilarFace>

/** The face identifier. */
@property (nonatomic, strong) NSUUID *FaceId;

/** The confidence. */
@property (nonatomic, assign) double Confidence;

@end
