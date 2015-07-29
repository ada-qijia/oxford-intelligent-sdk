//
//  Adult.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface Adult :OptionalPropJSONModel

/** A value indicating whether this instance is adult content. */
@property (nonatomic, assign) BOOL IsAdultContent;

/** A value indicating whether this instance is racy content. */
@property (nonatomic, assign) BOOL IsRacyContent;

/** The adult score. */
@property (nonatomic, assign) double AdultScore;

/** The racy score. */
@property (nonatomic, assign) double RacyScore;

@end
