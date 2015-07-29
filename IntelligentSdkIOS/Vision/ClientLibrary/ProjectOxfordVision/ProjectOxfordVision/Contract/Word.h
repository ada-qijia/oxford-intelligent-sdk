//
//  Word.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rectangle.h"
#import "OptionalPropJSONModel.h"

@protocol Word<NSObject>
@end

@interface Word : OptionalPropJSONModel

@property (nonatomic, strong) NSString * BoundingBox;
@property (nonatomic, strong) NSString * Text;
@property (nonatomic, strong) Rectangle * Rectangle;

@end
