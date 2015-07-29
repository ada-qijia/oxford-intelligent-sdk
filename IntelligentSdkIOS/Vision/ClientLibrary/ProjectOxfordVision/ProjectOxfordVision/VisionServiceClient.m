//
//  VisionServiceClient.m
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "VisionServiceClient.h"
#import "AnalysisResult.h"
#import "JSONKeyMapper+CamelCase.h"
#import "ProjectOxfordVision.h"

NSInteger const kVisionErrorInvalidParam = 10000;
NSString* const ProjectOxfordVisionErrorDomain = @"ProjectOxfordVisionErrorDomain";

@implementation VisionServiceClient
{
    NSString * subscriptionKey;
}

static NSString * const ServiceHost = @"http://api.projectoxford.ai/vision/v1";
static NSString * const AnalyzeQuery = @"analyses";
static NSString * const SubscriptionKeyName = @"subscription-key";
static NSString * const ContentTypeJson = @"application/json";
static NSString * const ContentTypeStream = @"application/octet-stream";

-(instancetype) initWithSubscriptionKey:(NSString *)key
{
    //json key mapper
    [JSONModel setGlobalKeyMapper:[JSONKeyMapper mapperFromUpperCamelCaseToLowerCamelCase]];
    
    self = [super init];
    if(self)
    {
        subscriptionKey = key;
    }
    return self;
}

#pragma mark - VisionServiceClientProtocol Implementation

-(void)AnalyzeImageFromUrl:(NSString *)imageUrl visualFeatures:(NSArray *)visualFeatures completionHandler:(void (^)(AnalysisResult *result, NSError *error))completionHandler
{
    NSError *error = nil;
    
    if(![self validateUrlString:imageUrl])
    {
        error = [NSError errorWithDomain:ProjectOxfordVisionErrorDomain code:kVisionErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:@"Invalid param imageUrl."}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        return;
    }
    
    NSString *features = [self visualFeaturesToString:visualFeatures];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?visualFeatures=%@&%@=%@", ServiceHost, AnalyzeQuery, features, SubscriptionKeyName, subscriptionKey];
    
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObject:imageUrl forKey:@"Url"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self postToUrl:requestUrl data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            AnalysisResult *result = nil;
            NSDictionary *jsonDict = (NSDictionary *)data;
            if(jsonDict && err == nil)
            {
                result=[[AnalysisResult alloc] initWithDictionary:jsonDict error:&err];
            }
            
            if(completionHandler!=nil)
            {
                completionHandler(result, err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
    }
}

-(void)AnalyzeImageWithData:(NSData *)imageData visualFeatures:(NSArray *)visualFeatures completionHandler:(void (^)(AnalysisResult *result, NSError *error))completionHandler
{
    NSError *error = nil;
    
    //validate params.
    if(imageData.length == 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordVisionErrorDomain code:kVisionErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:@"Invalid param imageData. imageData cannot be empty."}];
        
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        return;
    }
    
    NSString *features=[self visualFeaturesToString:visualFeatures];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?visualFeatures=%@&%@=%@", ServiceHost, AnalyzeQuery, features, SubscriptionKeyName, subscriptionKey];
    
    [self postToUrl:requestUrl data:imageData contentType:ContentTypeStream completionHandler:^(NSObject *data, NSError *err){
        AnalysisResult *result = nil;
        NSDictionary *jsonDict = (NSDictionary *)data;
        if(jsonDict && err == nil)
        {
            result = [[AnalysisResult alloc] initWithDictionary:jsonDict error:&err];
        }
        
        if(completionHandler != nil)
        {
            completionHandler(result, err);
        }
    }];
}

-(void)GetThumbnailFromUrl:(NSString *) imageUrl width:(int)width height:(int)height completionHandler:(void (^)(NSData *thumbnailData, NSError *error))completionHandler
{
    [self GetThumbnailFromUrl:imageUrl width:width height:height smartCropping:true completionHandler:completionHandler];
}

-(void)GetThumbnailFromUrl:(NSString *)imageUrl width:(int)width height:(int)height smartCropping:(BOOL)smartCropping completionHandler:(void (^)(NSData *, NSError *))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateUrlString:imageUrl])
    {
        errorDesc = @"Invalid param imageUrl.";
    }
    else if(width <= 0)
    {
        errorDesc = @"Invalid param width. width must be positive.";
    }
    else if(height <= 0)
    {
        errorDesc = @"Invalid param height. height must be positive.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordVisionErrorDomain code:kVisionErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *isSmartCropping=(smartCropping)? @"true":@"false";
    NSString *requestUrl = [NSString stringWithFormat:@"%@/thumbnails?width=%d&height=%d&smartCropping=%@&%@=%@", ServiceHost, width, height, isSmartCropping, SubscriptionKeyName, subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObject:imageUrl forKey:@"Url"];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self postToUrl:requestUrl data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            NSData *resultData = (NSData *)data;
            if(completionHandler != nil)
            {
                completionHandler(resultData, err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
    }
}

-(void)GetThumbnailWithData:(NSData *)imageData width:(int)width height:(int)height completionHandler:(void (^)(NSData *, NSError *))completionHandler
{
    [self GetThumbnailWithData:imageData width:width height:height smartCropping:true completionHandler:completionHandler];
}

-(void)GetThumbnailWithData:(NSData *)imageData width:(int)width height:(int)height smartCropping:(BOOL)smartCropping completionHandler:(void (^)(NSData *, NSError *))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(imageData.length == 0)
    {
        errorDesc = @"Invalid param imageData. imageData cannot be empty.";
    }
    else if(width <= 0)
    {
        errorDesc = @"Invalid param width. width must be positive.";
    }
    else if(height <= 0)
    {
        errorDesc = @"Invalid param height. height must be positive.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordVisionErrorDomain code:kVisionErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    NSString *isSmartCropping=(smartCropping)? @"true":@"false";
    NSString *requestUrl = [NSString stringWithFormat:@"%@/thumbnails?width=%d&height=%d&smartCropping=%@&%@=%@", ServiceHost, width, height, isSmartCropping, SubscriptionKeyName, subscriptionKey];
    
    [self postToUrl:requestUrl data:imageData contentType:ContentTypeStream completionHandler:^(NSObject *data, NSError *error){
        NSData *resultData=(NSData *)data;
        
        if(completionHandler!=nil)
        {
            completionHandler(resultData, error);
        }
    }];
}

-(void)RecognizeTextFromUrl:(NSString *)imageUrl completionHandler:(void (^)(OcrResults *result, NSError *error))completionHandler
{
    [self RecognizeTextFromUrl:imageUrl languageCode:LanguageCodeAutoDetect detectOrientation:true completionHandler:completionHandler];
}

-(void)RecognizeTextFromUrl:(NSString *)imageUrl detectOrientation:(BOOL)detectOrientation completionHandler:(void (^)(OcrResults *result, NSError *error))completionHandler
{
    [self RecognizeTextFromUrl:imageUrl languageCode:LanguageCodeAutoDetect detectOrientation:detectOrientation completionHandler:completionHandler];
}

-(void)RecognizeTextFromUrl:(NSString *)imageUrl languageCode:(LanguageCode)languageCode detectOrientation:(BOOL)detectOrientation completionHandler:(void (^)(OcrResults *, NSError *))completionHandler
{
    NSError *error = nil;
    
    if(![self validateUrlString:imageUrl])
    {
        error = [NSError errorWithDomain:ProjectOxfordVisionErrorDomain code:kVisionErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:@"Invalid param imageUrl."}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        return;
    }

    NSString *shouldDetectOrientation = detectOrientation ? @"true" : @"false";
    NSString *languageCodeStr = [LanguageCodes languageCodeEnumToString:languageCode];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/ocr?language=%@&detectOrientation=%@&%@=%@", ServiceHost, languageCodeStr, shouldDetectOrientation, SubscriptionKeyName, subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObject:imageUrl forKey:@"Url"];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self postToUrl:requestUrl data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            OcrResults *result = nil;
            NSDictionary *jsonDict = (NSDictionary *)data;
            if(jsonDict)
            {
                result=[[OcrResults alloc] initWithDictionary:jsonDict error:&err];
            }
            
            if(completionHandler!=nil)
            {
                completionHandler(result, err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
    }
}

-(void)RecognizeTextWithData:(NSData *)imageData completionHandler:(void (^)(OcrResults *result, NSError *error))completionHandler
{
    [self RecognizeTextWithData:imageData languageCode:LanguageCodeAutoDetect detectOrientation:true completionHandler:completionHandler];
}

-(void)RecognizeTextWithData:(NSData *)imageData detectOrientation:(BOOL)detectOrientation completionHandler:(void (^)(OcrResults *result, NSError *error))completionHandler
{
    [self RecognizeTextWithData:imageData languageCode:LanguageCodeAutoDetect detectOrientation:detectOrientation completionHandler:completionHandler];
}

-(void)RecognizeTextWithData:(NSData *)imageData languageCode:(LanguageCode)languageCode detectOrientation:(BOOL)detectOrientation completionHandler:(void (^)(OcrResults *, NSError *))completionHandler
{
    NSError *error = nil;
    
    //validate params.
    if(imageData.length == 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordVisionErrorDomain code:kVisionErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:@"Invalid param imageData. imageData cannot be empty."}];
        
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        return;
    }

    NSString *shouldDetectOrientation = detectOrientation ? @"true" : @"false";
    NSString *languageCodeStr = [LanguageCodes languageCodeEnumToString:languageCode];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/ocr?language=%@&detectOrientation=%@&%@=%@", ServiceHost, languageCodeStr, shouldDetectOrientation, SubscriptionKeyName, subscriptionKey];
    
    [self postToUrl:requestUrl data:imageData contentType:ContentTypeStream completionHandler:^(NSObject *data, NSError *err){
        OcrResults *result;
        NSDictionary *jsonDict = (NSDictionary *)data;
        if(jsonDict)
        {
            result=[[OcrResults alloc] initWithDictionary:jsonDict error:&err];
        }
        
        if(completionHandler!=nil)
        {
            completionHandler(result, err);
        }
    }];
}

#pragma mark - private methods

/**
 * Post data to url.
 */
-(void) postToUrl:(NSString *)url data:(NSData *)data contentType:(NSString *)contentType completionHandler:(void (^)(NSObject *data, NSError *error))completionHandler
{
    NSURLSessionConfiguration *defaultConfiguration=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    if(contentType)
    {
        [request addValue:contentType forHTTPHeaderField:@"content-type"];
    }
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
        if(httpResp)
        {
            if(httpResp.statusCode == kHttpStatusCodeOK || httpResp.statusCode == kHttpStatusCodeCreated || httpResp.statusCode == kHttpStatusCodeAccepted)
            {
                NSString *contentType = httpResp.allHeaderFields[@"Content-Type"];
                if([contentType isEqualToString:@"image/jpeg"]||[contentType isEqualToString:@"image/png"])
                {
                    //return data
                    if(completionHandler!=nil)
                    {
                        completionHandler(data,nil);
                    }
                }
                else
                {
                    NSError *jsonError;
                    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    //return json result
                    if(completionHandler != nil)
                    {
                        completionHandler(jsonResult, jsonError);
                    }
                }
            }
            else
            {
                NSString *errorDesc = [NSString stringWithFormat:@"Http Response status code: %ld", (long)httpResp.statusCode];
                ClientError *clientError = [[ClientError alloc] initWithData:data error:&error];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorDesc, NSLocalizedDescriptionKey, clientError, @"ClientError", nil];
                error = [NSError errorWithDomain:ProjectOxfordVisionErrorDomain code:httpResp.statusCode userInfo:userInfo];
                
                //return error
                if(completionHandler != nil)
                {
                    completionHandler(nil,error);
                }
            }
        }
        else
        {
            //return error
            if(completionHandler != nil)
            {
                completionHandler(nil,error);
            }
        }
    }];
    
    [uploadTask resume];
}

-(NSString *)visualFeaturesToString:(NSArray *)visualFeatures
{
    if(visualFeatures.count == 0)
    {
        return @"All";
    }
    else
    {
        return [visualFeatures componentsJoinedByString:@","];
    }
}

-(BOOL)validateUrlString: (NSString *)candidate
{
    NSURL* url = [NSURL URLWithString:candidate];
    if (url) {
        NSString *scheme = [url.scheme lowercaseString];
        if([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]){
            return YES;
        }
    }
    return NO;
}

@end
