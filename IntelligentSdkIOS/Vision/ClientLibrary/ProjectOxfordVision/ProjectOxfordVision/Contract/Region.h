//
//  Region.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Line.h"
#import "Rectangle.h"

#import "OptionalPropJSONModel.h"

@protocol Region <NSObject>

@end

@interface Region : OptionalPropJSONModel

@property (nonatomic, strong) NSString* BoundingBox;
@property (nonatomic, strong) NSArray<Line>* Lines;
@property (nonatomic, readonly) Rectangle* Rectangle;

@end
