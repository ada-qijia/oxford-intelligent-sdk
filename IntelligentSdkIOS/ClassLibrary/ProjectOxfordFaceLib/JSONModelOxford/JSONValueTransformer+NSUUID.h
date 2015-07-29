//
//  JSONValueTransformer+NSUUID.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "JSONValueTransformer.h"

@interface JSONValueTransformer (NSUUID)

-(NSUUID*)NSUUIDFromNSString:(NSString*)string;
-(id)JSONObjectFromNSUUID:(NSUUID*)uuid;

@end
