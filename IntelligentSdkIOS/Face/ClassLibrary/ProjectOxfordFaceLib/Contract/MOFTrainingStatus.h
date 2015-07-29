//
//  MOFTrainingStatus.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface MOFTrainingStatus : OptionalPropJSONModel

/** The status. */
@property (nonatomic, strong) NSString *Status;

/** The start time. */
@property (nonatomic, strong) NSDate *StartTime;

/** The end time. */
@property (nonatomic, strong) NSDate *EndTime;

@end
