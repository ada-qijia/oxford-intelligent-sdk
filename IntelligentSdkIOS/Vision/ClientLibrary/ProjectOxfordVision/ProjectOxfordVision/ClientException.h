//
//  ClientException.h
//  projectoxford.vision
//
//  Created by 贾倩 on 6/18/15.
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientError.h"
#import "projectoxford_vision.h"

@interface ClientException : NSError

@property (nonatomic, assign, readonly) NSInteger StatusCode;
@property (nonatomic, strong) ClientError * Error;

/**
 * Initializes and returns a newly allocated client exception object.
 * @param message The error message.
 * @return The created ClientException object or nil if the object couldn't be created.
 */
-(instancetype) initWithMessage:(NSString *)message;

/**
 * Initializes and returns a newly allocated client exception object.
 * @param message The error message.
 * @param statusCode The http status code.
 * @return The created ClientException object or nil if the object couldn't be created.
 */
-(instancetype) initWithMessage:(NSString *)message statusCode:(NSInteger)statusCode;

/**
 * Initializes and returns a newly allocated client exception object.
 * @param message The error message.
 * @param innerException The inner exception.
 * @return The created ClientException object or nil if the object couldn't be created.
 */
-(instancetype) initWithMessage:(NSString *)message innerException:(NSException *)innerException;

/**
 * Initializes and returns a newly allocated client exception object.
 * @param message The error message.
 * @param errorCode The error code.
 * @param statusCode The http status code.
 * @return The created ClientException object or nil if the object couldn't be created.
 */
-(instancetype) initWithMessage:(NSString *)message errorCode:(NSString *)errorCode statusCode:(NSInteger)statusCode innerException:(NSException *)innerException;

/**
 * Initializes and returns a newly allocated client exception object.
 * @param error The error object.
 * @param statusCode The http status code.
 * @return The created ClientException object or nil if the object couldn't be created.
 */
-(instancetype) initWithClientError:(ClientError *)error statusCode:(NSInteger)statusCode;

/**
 * Initializes and returns a client exception object of bad request.
 * @param message The error message.
 * @return The created ClientException object or nil if the object couldn't be created.
 */
+(instancetype) BadRequest:(NSString *)message;

@end
