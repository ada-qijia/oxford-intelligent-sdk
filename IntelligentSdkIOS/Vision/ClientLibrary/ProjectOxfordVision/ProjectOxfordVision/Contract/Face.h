//
//  Face.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceRectangle.h"
#import "OptionalPropJSONModel.h"

@protocol Face <NSObject>
@end

@interface Face : OptionalPropJSONModel

@property (nonatomic, assign) int Age;
@property (nonatomic, strong) NSString * Gender;
@property (nonatomic, strong) FaceRectangle * FaceRectangle;

@end
