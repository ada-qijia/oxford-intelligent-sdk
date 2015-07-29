//
//  MetaData.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface Metadata : OptionalPropJSONModel

@property (nonatomic, assign) int Height;
@property (nonatomic, assign) int Width;
@property (nonatomic, strong) NSString* Format;

@end
