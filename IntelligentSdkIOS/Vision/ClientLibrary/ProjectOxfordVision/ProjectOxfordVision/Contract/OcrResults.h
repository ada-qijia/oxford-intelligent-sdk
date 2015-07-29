//
//  OcrResults.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Region.h"
#import "OptionalPropJSONModel.h"

@interface OcrResults : OptionalPropJSONModel

@property (nonatomic, strong) NSString * Language;
//nullable double
@property (nonatomic, strong) NSNumber * TextAngle;
@property (nonatomic, strong) NSString * Orientation;
@property (nonatomic, strong) NSArray<Region> * Regions;

@end
