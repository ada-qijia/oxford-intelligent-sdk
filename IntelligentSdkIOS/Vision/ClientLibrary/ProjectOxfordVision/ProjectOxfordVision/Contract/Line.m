//
//  Line.m
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "Line.h"

@implementation Line

- (Rectangle *)Rectangle
{
    return [Rectangle FromString:self.BoundingBox];
}

+(BOOL)propertyIsIgnored:(NSString *)propertyName
{
    if([propertyName isEqualToString:@"Rectangle"])
    {
        return YES;
    }
    return NO;
}

@end
