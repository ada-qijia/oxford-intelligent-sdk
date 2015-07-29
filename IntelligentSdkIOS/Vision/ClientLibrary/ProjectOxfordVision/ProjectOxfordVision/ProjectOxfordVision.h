//
//  ProjectOxfordVision.h
//  ProjectOxfordVision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "Adult.h"
#import "AnalysisResult.h"
#import "VisionCategory.h"
#import "Color.h"
#import "Face.h"
#import "FaceRectangle.h"
#import "ImageType.h"
#import "LanguageCodes.h"
#import "Line.h"
#import "MetaData.h"
#import "OcrResults.h"
#import "Rectangle.h"
#import "Region.h"
#import "Word.h"
#import "ClientError.h"
#import "VisionServiceClient.h"

static NSString * const kVisionClientErrorDomain = @"http://api.projectoxford.ai/vision/v1";
/**
 * Contains some of the values of status codes defined for HTTP.
 * @constant kHttpStatusCodeOK Indicates that the request succeeded and that th requested information is in the response.
 * @constant kHttpStatusCodeCreated Indicates that the request resulted in a new resource created before the response was sent.
 * @constant kHttpStatusCodeAccepted Indicates that the request has been accepted for futher processing.
 * @constant kHttpStatusCodeBadRequest Indicates that the request could not be understood by the server.
 * @constant kHttpStatusCodeUnsupportedMediaType Indicates that the request is an unsupported type.
 * @constant kHttpStatusCodeInternalServerError Indicates that a generic error has occured on the server.
 */
typedef NS_ENUM(NSInteger, HttpStatusCode) {
    kHttpStatusCodeOK = 200,
    kHttpStatusCodeCreated = 201,
    kHttpStatusCodeAccepted = 202,
    
    kHttpStatusCodeBadRequest = 400,
    kHttpStatusCodeUnsupportedMediaType = 415,
    kHttpStatusCodeInternalServerError = 500,
};