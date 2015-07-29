//
//  Category.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@protocol VisionCategory<NSObject>

@end

@interface VisionCategory : OptionalPropJSONModel

@property (nonatomic, strong) NSString* Name;
@property (nonatomic, assign) double Score;

@end
