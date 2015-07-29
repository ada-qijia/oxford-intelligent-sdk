//
//  JSONValueTransformer+NSUUID.m
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "JSONValueTransformer+NSUUID.h"

@implementation JSONValueTransformer (NSUUID)

-(NSUUID*)NSUUIDFromNSString:(NSString*)string
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:string];
    return uuid;
}

-(id)JSONObjectFromNSUUID:(NSUUID*)uuid
{
    NSString *result = [[uuid UUIDString] lowercaseString];
    return result;
}

@end
