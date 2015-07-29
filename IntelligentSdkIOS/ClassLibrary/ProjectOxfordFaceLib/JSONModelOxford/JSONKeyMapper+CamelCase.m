//
//  JSONKeyMapper+CamelCase.m
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "JSONKeyMapper+CamelCase.h"
#import "JSONKeyMapper.h"

@implementation JSONKeyMapper (CamelCase)

+(instancetype)mapperFromUpperCamelCaseToLowerCamelCase
{
    JSONModelKeyMapBlock toModel = ^ NSString* (NSString* keyName) {
        NSString*uppercaseString =[NSString stringWithFormat:@"%@%@",[[keyName substringToIndex:1] uppercaseString],[keyName substringFromIndex:1]];
        
        return uppercaseString;
    };
    
    JSONModelKeyMapBlock toJSON = ^ NSString* (NSString* keyName) {
        
        NSString *lowercaseString =[NSString stringWithFormat:@"%@%@",[[keyName substringToIndex:1] lowercaseString],[keyName substringFromIndex:1]];
        
        return lowercaseString;
    };
    
    return [[self alloc] initWithJSONToModelBlock:toModel
                                 modelToJSONBlock:toJSON];
}


@end
