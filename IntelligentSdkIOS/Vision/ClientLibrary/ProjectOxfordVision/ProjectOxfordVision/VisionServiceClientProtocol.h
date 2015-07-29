//
//  VisionServiceClientProtocol.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#ifndef projectoxford_vision_VisionServiceClientProtocol_h
#define projectoxford_vision_VisionServiceClientProtocol_h

#import <Foundation/Foundation.h>
#import "AnalysisResult.h"
#import "OcrResults.h"
#import "LanguageCodes.h"

/**
 * @discussion vision service client protocol.
 */
@protocol VisionServiceClientProtocol <NSObject>

/**
 * Analyzes the image.
 * @param imageUrl The image URL.
 * @param visualFeatures The visual features. NSString array. Default is nil.
 * @param completionHandler The block to execute upon completion which returns AnalysisResult object.
 */
-(void)AnalyzeImageFromUrl:(NSString *)imageUrl visualFeatures:(NSArray *)visualFeatures completionHandler:(void (^)(AnalysisResult *result, NSError *error))completionHandler;

/**
 * Analyzes the image.
 * @param imageData The image data.
 * @param visualFeatures The visual features. NSString array. Default is nil.
 * @param completionHandler The block to execute upon completion which returns AnalysisResult object.
 */
-(void)AnalyzeImageWithData:(NSData *)imageData visualFeatures:(NSArray *)visualFeatures completionHandler:(void (^)(AnalysisResult *result, NSError *error))completionHandler;

/**
 * Gets the thumbnail with smartcropping.
 * @param imageUrl The image URL.
 * @param width The width of the thumbnail to be generated.
 * @param height The height of the thumbnail to be generated.
 * @param completionHandler The block to execute upon completion which returns thumbnail data.
 */
-(void)GetThumbnailFromUrl:(NSString *) imageUrl width:(int)width height:(int)height completionHandler:(void (^)(NSData *thumbnailData, NSError *error))completionHandler;

/**
 * Gets the thumbnail.
 * @param imageUrl The image URL.
 * @param width The width of the thumbnail to be generated.
 * @param height The height of the thumbnail to be generated.
 * @param smartCropping If true, smart cropping the image when genrate thumbnail.
 * @param completionHandler The block to execute upon completion which returns thumbnail data.
 */
-(void)GetThumbnailFromUrl:(NSString *) imageUrl width:(int)width height:(int)height smartCropping:(BOOL)smartCropping completionHandler:(void (^)(NSData *thumbnailData, NSError *error))completionHandler;

/**
 * Gets the thumbnail with smartcropping.
 * @param imageData The image data.
 * @param width The width of the thumbnail to be generated.
 * @param height The height of the thumbnail to be generated.
 * @param completionHandler The block to execute upon completion which returns thumbnail data.
 */
-(void)GetThumbnailWithData:(NSData *) imageData width:(int)width height:(int)height completionHandler:(void (^)(NSData *thumbnailData, NSError *error))completionHandler;

/**
 * Gets the thumbnail.
 * @param imageData The image data.
 * @param width The width of the thumbnail to be generated.
 * @param height The height of the thumbnail to be generated.
 * @param smartCropping If true, smart cropping the image when genrate thumbnail.
 * @param completionHandler The block to execute upon completion which returns thumbnail data.
 */
-(void)GetThumbnailWithData:(NSData *) imageData width:(int)width height:(int)height smartCropping:(BOOL)smartCropping completionHandler:(void (^)(NSData *thumbnailData, NSError *error))completionHandler;

/**
 * Recognizes text in the image with language auto-detected and text orientation detected.
 * @param imageUrl The image URL.
 * @param completionHandler The block to execute upon completion which returns OcrResults object.
 */
-(void)RecognizeTextFromUrl:(NSString *)imageUrl completionHandler:(void (^)(OcrResults *result, NSError *error))completionHandler;

/**
 * Recognizes text in the image with language auto-detected.
 * @param imageUrl The image URL.
 * @param detectOrientation If true, detect text orientation.
 * @param completionHandler The block to execute upon completion which returns OcrResults object.
 */
-(void)RecognizeTextFromUrl:(NSString *)imageUrl detectOrientation:(BOOL)detectOrientation completionHandler:(void (^)(OcrResults *result, NSError *error))completionHandler;

/**
 * Recognizes text in the image.
 * @param imageUrl The image URL.
 * @param languageCode The language code defined in LanguageCodes.h.
 * @param detectOrientation If true, detect text orientation.
 * @param completionHandler The block to execute upon completion which returns OcrResults object.
 */
-(void)RecognizeTextFromUrl:(NSString *)imageUrl languageCode:(LanguageCode)languageCode detectOrientation:(BOOL)detectOrientation completionHandler:(void (^)(OcrResults *result, NSError *error))completionHandler;

/**
 * Recognizes text in the image with language auto-detected and text orientation detected.
 * @param imageData The image data.
 * @param completionHandler The block to execute upon completion which returns OcrResults object.
 */
-(void)RecognizeTextWithData:(NSData *)imageData completionHandler:(void (^)(OcrResults *result, NSError *error))completionHandler;

/**
 * Recognizes text in the image with language auto-detected.
 * @param imageData The image data.
 * @param detectOrientation If true, detect text orientation.
 * @param completionHandler The block to execute upon completion which returns OcrResults object.
 */
-(void)RecognizeTextWithData:(NSData *)imageData detectOrientation:(BOOL)detectOrientation completionHandler:(void (^)(OcrResults *result, NSError *error))completionHandler;

/**
 * Recognizes text in the image.
 * @param imageData The image data.
 * @param languageCode The language code defined in LanguageCodes.h.
 * @param detectOrientation If true, detect text orientation.
 * @param completionHandler The block to execute upon completion which returns OcrResults object.
 */
-(void)RecognizeTextWithData:(NSData *)imageData languageCode:(LanguageCode)languageCode detectOrientation:(BOOL)detectOrientation completionHandler:(void (^)(OcrResults *result, NSError *error))completionHandler;

@end

#endif
