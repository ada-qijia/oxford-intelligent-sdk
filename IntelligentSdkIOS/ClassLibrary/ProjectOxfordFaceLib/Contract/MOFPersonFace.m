
//
//  MOFPersonFace.m
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "MOFPersonFace.h"

@implementation MOFPersonFace

-(id)initWithId:(NSUUID *)faceId userData:(NSString *)userData
{
    self = [super init];
    
    if (self) {
        self.FaceId = faceId;
        self.UserData = userData;
    }
    return self;
}

@end
