//
//  MOFGroupResult.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface MOFGroupResult : OptionalPropJSONModel

/** The groups. An array of NSString array. */
@property (nonatomic, strong) NSArray *Groups;

/** The messy group. An NSString array. */
@property (nonatomic, strong) NSArray *MessyGroup;

@end
