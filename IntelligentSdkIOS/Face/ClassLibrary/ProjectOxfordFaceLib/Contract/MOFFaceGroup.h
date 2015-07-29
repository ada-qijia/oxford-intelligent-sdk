//
//  MOFFaceGroup.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"
#import "MOFPersonFace.h"

@protocol MOFFaceGroup <NSObject>

@end

@interface MOFFaceGroup : OptionalPropJSONModel <MOFFaceGroup>

/** The face group identifier. */
@property (nonatomic, strong) NSString *FaceGroupId;

/** The name of the person group. */
@property (nonatomic, strong) NSString *Name;

/** The user data. */
@property (nonatomic, strong) NSString *UserData;

/** Faces in the group. */
@property (nonatomic, strong) NSArray<MOFPersonFace> *Faces;

@end
