//
//  MOFCandidate.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@protocol MOFCandidate <NSObject>

@end

@interface MOFCandidate : OptionalPropJSONModel <MOFCandidate>

/** The person identifier. */
@property (nonatomic, strong) NSUUID *PersonId;

/** The confidence. */
@property (nonatomic, assign) double Confidence;

@end
