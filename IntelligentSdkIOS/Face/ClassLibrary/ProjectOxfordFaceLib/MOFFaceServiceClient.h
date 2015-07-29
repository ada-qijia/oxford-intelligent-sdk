//
//  MOFFaceServiceClient.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectOxfordFaceLib.h"

@interface MOFFaceServiceClient : NSObject <MOFFaceServiceClientProtocol>

/**
 * Initializes and returns a newly allocated MOFFaceServiceClient object.
 * @param key The subscription key.
 * @return The created MOFFaceServiceClient object or nil if the object couldn't be created.
 */
-(instancetype) initWithSubscriptionKey:(NSString *)key;

@end
