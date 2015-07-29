//
//  ClientError.h
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"

@interface ClientError : OptionalPropJSONModel

/** The error code. */
@property (nonatomic, strong) NSString * Code;

/** The message. */
@property (nonatomic, strong) NSString * Message;

/** The request identifier. */
@property (nonatomic, strong) NSString * RequestId;

@end
