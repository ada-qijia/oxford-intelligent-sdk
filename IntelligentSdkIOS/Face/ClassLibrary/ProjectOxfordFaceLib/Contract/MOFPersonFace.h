//
//  MOFPersonFace.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@protocol MOFPersonFace <NSObject>

@end

@interface MOFPersonFace : OptionalPropJSONModel

/** The face identifier. */
@property (nonatomic, strong) NSUUID *FaceId;

/** The user data. */
@property (nonatomic, strong) NSString *UserData;

-(id)initWithId:(NSUUID *)faceId userData:(NSString *)userData;

@end
