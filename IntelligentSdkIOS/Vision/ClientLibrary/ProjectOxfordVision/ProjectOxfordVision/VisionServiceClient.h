//
//  VisionServiceClient.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VisionServiceClientProtocol.h"

/**
 * Custom method param error type.
 */
extern NSInteger const kVisionErrorInvalidParam;

/**
 * Error code in this demain includes kVisionErrorInvalidParam and Some http status code.
 */
extern NSString *const ProjectOxfordVisionErrorDomain;

@interface VisionServiceClient : NSObject <VisionServiceClientProtocol>

/**
 * Initializes and returns a newly allocated VisionServiceClient object.
 * @param key The subscription key.
 * @return The created VisionServiceClient object or nil if the object couldn't be created.
 */
-(instancetype) initWithSubscriptionKey:(NSString *)key;

@end
