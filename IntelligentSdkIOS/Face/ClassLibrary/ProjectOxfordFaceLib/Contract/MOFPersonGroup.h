//
//  MOFPersonGroup.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@protocol MOFPersonGroup <NSObject>

@end

@interface MOFPersonGroup : OptionalPropJSONModel <MOFPersonGroup>

/** The person group identifier. */
@property (nonatomic, strong) NSString *PersonGroupId;

/** The name of the person group. */
@property (nonatomic, strong) NSString *Name;

/** The user data. */
@property (nonatomic, strong) NSString *UserData;

@end
