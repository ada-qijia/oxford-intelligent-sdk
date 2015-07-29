//
//  MOFCreatePersonResult.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface MOFCreatePersonResult : OptionalPropJSONModel

/** The person Identifier. */
@property (nonatomic, strong) NSUUID *PersonId;

@end
