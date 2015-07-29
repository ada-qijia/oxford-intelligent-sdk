//
//  JSONValueTransformer+NSDate.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "JSONValueTransformer.h"

@interface JSONValueTransformer (NSDate)

-(NSDate*)NSDateFromNSString:(NSString*)string;
-(id)JSONObjectFromNSDate:(NSDate*)date;

@end
