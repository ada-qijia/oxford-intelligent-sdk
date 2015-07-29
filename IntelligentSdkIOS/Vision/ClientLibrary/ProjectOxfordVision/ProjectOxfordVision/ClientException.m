
//
//  ClientException.m
//  projectoxford.vision
//
//  Created by 贾倩 on 6/18/15.
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "ClientException.h"

@interface ClientException()

@property (nonatomic, assign, readwrite) NSInteger StatusCode;

@end


@implementation ClientException

-(instancetype) initWithMessage:(NSString *)message
{
    self = [super initWithName:nil reason:message userInfo:nil];
    if(self)
    {
        self.Error = [[ClientError alloc] init];
        self.Error.Code =[NSString stringWithFormat:@"%d", (int)kHttpStatusCodeInternalServerError];
        self.Error.Message = message;
    }
    return self;
}

-(instancetype) initWithMessage:(NSString *)message statusCode:(NSInteger)statusCode
{
    self = [super initWithName:nil reason:message userInfo:nil];
    if(self)
    {
        self.StatusCode = statusCode;
        self.Error = [[ClientError alloc] init];
        self.Error.Code =[NSString stringWithFormat:@"%ld", (long)statusCode];
        self.Error.Message = message;
    }
    return self;
}

-(instancetype) initWithMessage:(NSString *)message innerException:(NSException *)innerException
{
    self=[super initWithName:nil reason:message userInfo:nil];
    if(self)
    {
        self.Error = [[ClientError alloc] init];
        self.Error.Code =[NSString stringWithFormat:@"%d", (int)kHttpStatusCodeInternalServerError];
        self.Error.Message = message;
    }
    return self;
}

-(instancetype) initWithMessage:(NSString *)message errorCode:(NSString *)errorCode statusCode:(NSInteger)statusCode innerException:(NSException *)innerException
{
    self = [super initWithName:nil reason:message userInfo:nil];
    if(self)
    {
        self.StatusCode = statusCode;
        self.Error = [[ClientError alloc] init];
        self.Error.Code = errorCode;
        self.Error.Message = message;
    }
    return self;
}

-(instancetype) initWithClientError:(ClientError *)error statusCode:(NSInteger)statusCode
{
    self = [super initWithName:@"ClientError" reason:error.Message userInfo:nil];
    if(self)
    {
        self.Error = error;
        self.StatusCode = statusCode;
    }
    return self;
}

+(instancetype) BadRequest:(NSString *)message
{
    ClientError * error = [[ClientError alloc] init];
    error.Code = [NSString stringWithFormat:@"%d", (int)kHttpStatusCodeBadRequest];
    error.Message = message;
    
    ClientException *exception=[[self alloc] initWithClientError:error statusCode:kHttpStatusCodeBadRequest];
    
    return exception;
}

@end
