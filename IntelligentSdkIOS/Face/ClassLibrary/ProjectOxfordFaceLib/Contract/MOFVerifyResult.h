//
//  MOFVerifyResult.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface MOFVerifyResult : OptionalPropJSONModel

/** true if this instance is same; otherwise ,false. */
@property (nonatomic, assign) BOOL IsIdentical;

/** The confidence. */
@property (nonatomic, assign) double Confidence;

@end
