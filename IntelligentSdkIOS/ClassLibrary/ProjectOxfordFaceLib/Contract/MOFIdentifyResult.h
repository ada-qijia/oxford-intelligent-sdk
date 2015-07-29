//
//  MOFIdentifyResult.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"
#import "MOFCandidate.h"

@protocol MOFIdentifyResult <NSObject>

@end

@interface MOFIdentifyResult : OptionalPropJSONModel <MOFIdentifyResult>

/** The face identifier. */
@property (nonatomic, strong) NSUUID *FaceId;

/** The candidates. */
@property (nonatomic, strong) NSArray<MOFCandidate> *Candidates;

@end
