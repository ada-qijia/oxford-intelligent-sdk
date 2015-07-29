//
//  JSONKeyMapper+CamelCase.h
//  ProjectOxfordVision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKeyMapper.h"

@interface JSONKeyMapper (CamelCase)

+(instancetype)mapperFromUpperCamelCaseToLowerCamelCase;

@end
