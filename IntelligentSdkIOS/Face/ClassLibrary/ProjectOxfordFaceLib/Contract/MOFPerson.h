//
//  MOFPerson.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@protocol MOFPerson <NSObject>

@end

@interface MOFPerson : OptionalPropJSONModel <MOFPerson>

/** The person identifier. */
@property (nonatomic, strong) NSUUID *PersonId;

/** The face ids. An NSUUID array. */
@property (nonatomic, strong) NSArray *FaceIds;

/** The name of the person. */
@property (nonatomic, strong) NSString *Name;

/** The profile. */
@property (nonatomic, strong) NSString *UserData;

@end
