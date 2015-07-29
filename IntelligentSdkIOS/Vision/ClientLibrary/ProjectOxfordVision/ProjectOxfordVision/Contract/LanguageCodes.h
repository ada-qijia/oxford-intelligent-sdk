//
//  LanguageCodes.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LanguageCode){
    LanguageCodeAutoDetect,
    LanguageCodeChineseSimplified,
    LanguageCodeChineseTraditional,
    LanguageCodeCzech,
    LanguageCodeDanish,
    LanguageCodeDutch,
    LanguageCodeEnglish,
    LanguageCodeFinnish,
    LanguageCodeFrench,
    LanguageCodeGerman,
    LanguageCodeGreek,
    LanguageCodeHungarian,
    LanguageCodeItalian,
    LanguageCodeJapanese,
    LanguageCodeKorean,
    LanguageCodeNorwegian,
    LanguageCodePolish,
    LanguageCodePortuguese,
    LanguageCodeRussian,
    LanguageCodeSpanish,
    LanguageCodeSwedish,
    LanguageCodeTurkish
};

#define  kLanguageCodeArray @"unk", @"zh-Hans", @"zh-Hant",@"cs",@"da",@"nl",@"en",@"fi",@"fr",@"de", @"el", @"hu", @"it", @"ja", @"ko",@"nb",@"pl",@"pt", @"ru", @"es", @"sv", @"tr", nil

@interface LanguageCodes : NSObject

+(NSString*) languageCodeEnumToString:(LanguageCode)enumVal;

@end
