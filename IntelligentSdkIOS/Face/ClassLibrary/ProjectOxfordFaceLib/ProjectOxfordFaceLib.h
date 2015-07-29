//
//  ProjectOxfordFaceLib.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MOFCandidate.h"
#import "MOFCreatePersonResult.h"
#import "MOFFace.h"
#import "MOFFaceAttribute.h"
#import "MOFFaceLandmarks.h"
#import "MOFFaceRectangle.h"
#import "MOFFeatureCoordinate.h"
#import "MOFGroupResult.h"
#import "MOFGroupResult.h"
#import "MOFHeadPose.h"
#import "MOFIdentifyResult.h"
#import "MOFPerson.h"
#import "MOFPersonFace.h"
#import "MOFPersonGroup.h"
#import "MOFSimilarFace.h"
#import "MOFTrainingStatus.h"
#import "MOFVerifyResult.h"
#import "MOFFaceGroup.h"

#import "ClientError.h"
#import "MOFFaceServiceClientProtocol.h"
#import "MOFFaceServiceClient.h"

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