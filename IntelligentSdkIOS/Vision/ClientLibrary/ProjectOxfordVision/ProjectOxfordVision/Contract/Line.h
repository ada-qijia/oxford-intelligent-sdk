//
//  Line.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"
#import "Rectangle.h"
#import "OptionalPropJSONModel.h"

@protocol Line <NSObject>

@end
@interface Line : OptionalPropJSONModel

@property (nonatomic, strong) NSString * BoundingBox;
@property (nonatomic, strong) NSArray<Word> * Words;
@property (nonatomic, strong) Rectangle * Rectangle;

@end
