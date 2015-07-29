
//
//  LanguageCodes.m
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "LanguageCodes.h"

@implementation LanguageCodes

+(NSString*) languageCodeEnumToString:(LanguageCode)enumVal
{
    NSArray *languageCodeArray = [[NSArray alloc] initWithObjects:kLanguageCodeArray];
    return [languageCodeArray objectAtIndex:enumVal];
}

@end