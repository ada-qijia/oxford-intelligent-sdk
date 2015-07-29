
//
//  MOFFaceServiceClient.m
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "MOFFaceServiceClient.h"
#import "JSONKeyMapper+CamelCase.h"
#import "JSONModelLib.h"

NSInteger const kFaceErrorInvalidParam = 10000;
NSString* const ProjectOxfordFaceErrorDomain = @"ProjectOxfordFaceErrorDomain";

#pragma mark - associated consts

static NSString * const ServiceHost = @"https://api.projectoxford.ai/face/v0";
static NSString * const SubscriptionKeyName = @"subscription-key";
static NSString * const DetectionsQuery = @"detections";
static NSString * const VerificationsQuery = @"verifications";
static NSString * const TrainingQuery = @"training";
static NSString * const PersonGroupsQuery = @"persongroups";
static NSString * const PersonsQuery = @"persons";
static NSString * const FacesQuery = @"faces";
static NSString * const FaceGroupsQuery = @"facegroups";
static NSString * const IdentificationsQuery = @"identifications";
static NSString * const ContentTypeJson = @"application/json";
static NSString * const ContentTypeStream = @"application/octet-stream";
static NSString * const ContentTypeUrlencoded = @"application/x-www-form-urlencoded";

#pragma mark - MOFFaceServiceClient implementation

@implementation MOFFaceServiceClient
{
    NSString * subscriptionKey;
}

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

#pragma mark - MOFFaceServiceClientProtocol Implementation Face

-(void)detectFacesFromImageUrl:(NSString *)imageUrl analyzesFacelandmarks:(BOOL)analyzesFacelandmarks analyzesAge:(BOOL)analyzesAge analyzesGender:(BOOL)analyzesGender analyzesHeadPose:(BOOL)analyzesHeadPose completionHandler:(void (^)(NSArray<MOFFace> *result, NSError *error))completionHandler;
{
    NSError *error = nil;
    
    //validate params.
    if(![self validateUrlString:imageUrl])
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:@"Invalid param imageUrl."}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        return;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?analyzesFaceLandmarks=%@&analyzesAge=%@&analyzesGender=%@&analyzesHeadPose=%@&%@=%@", ServiceHost, DetectionsQuery, [self boolToString:analyzesFacelandmarks],[self boolToString:analyzesAge], [self boolToString:analyzesGender], [self boolToString:analyzesHeadPose], SubscriptionKeyName, subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObject:imageUrl forKey:@"Url"];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"POST" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            NSArray<MOFFace> *result = nil;
            if([data isKindOfClass:[NSArray class]])
            {
                result = (NSArray<MOFFace> *)[[JSONModelArray alloc] initWithArray:(NSArray *)data modelClass:[MOFFace class]];
            }
            
            if(completionHandler != nil)
            {
                completionHandler(result, err);
            }
            
        }];
    }
    else
    {
        if(completionHandler != nil)
        {
            completionHandler(nil, error);
        }
    }
}

-(void)detectFacesWithImageData:(NSData *)imageData analyzesFacelandmarks:(BOOL)analyzesFacelandmarks analyzesAge:(BOOL)analyzesAge analyzesGender:(BOOL)analyzesGender analyzesHeadPose:(BOOL)analyzesHeadPose completionHandler:(void (^)(NSArray<MOFFace> *, NSError *))completionHandler
{
    NSError *error = nil;
    
    //validate params.
    if(imageData.length == 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:@"Invalid param imageData. imageData cannot be empty."}];
        
        if(completionHandler != nil)
        {
            completionHandler(nil, error);
        }
        return;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?analyzesFaceLandmarks=%@&analyzesAge=%@&analyzesGender=%@&analyzesHeadPose=%@&%@=%@", ServiceHost, DetectionsQuery, [self boolToString:analyzesFacelandmarks],[self boolToString:analyzesAge], [self boolToString:analyzesGender], [self boolToString:analyzesHeadPose], SubscriptionKeyName, subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"POST" data:imageData contentType:ContentTypeStream completionHandler:^(NSObject *data, NSError *err) {
        NSArray<MOFFace> *result = nil;
        if([data isKindOfClass:[NSArray class]])
        {
            result = (NSArray<MOFFace> *)[[JSONModelArray alloc] initWithArray:(NSArray *)data modelClass:[MOFFace class]];
        }
        
        if(completionHandler!=nil)
        {
            completionHandler(result, err);
        }
    }];
}

-(void)verfifyFaceWithId:(NSUUID *)faceId1 faceId2:(NSUUID *)faceId2 completionHandler:(void (^)(MOFVerifyResult *result, NSError *error))completionHandler
{
    NSError *error = nil;
    
    if(faceId1 == nil || faceId2 == nil)
    {
        NSString *errorDesc =[self paramNilMessage: faceId1? @"faceId2": @"faceId1"];
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        
        if(completionHandler != nil)
        {
            completionHandler(nil, error);
        }
        return;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?%@=%@", ServiceHost, VerificationsQuery, SubscriptionKeyName,subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys:[faceId1 UUIDString], @"faceId1",
                            [faceId2 UUIDString], @"faceId2", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"POST" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            MOFVerifyResult *result = nil;
            if([data isKindOfClass:[NSDictionary class]])
            {
                result = [[MOFVerifyResult alloc] initWithDictionary:(NSDictionary *)data error:&err];
            }
            
            if(completionHandler != nil)
            {
                completionHandler(result, err);
            }
        }];
    }
    else
    {
        if(completionHandler != nil)
        {
            completionHandler(nil, error);
        }
    }
}

-(void)identifyFacesInGroup:(NSString *)personGroupId faceIds:(NSArray *)faceIds completionHandler:(void (^)(NSArray<MOFIdentifyResult> *result, NSError *error))completionHandler
{
    [self identifyFacesInGroup:personGroupId faceIds:faceIds maxNumOfCandidatesReturned:1 completionHandler:completionHandler];
}

-(void)identifyFacesInGroup:(NSString *)personGroupId faceIds:(NSArray *)faceIds maxNumOfCandidatesReturned:(int) maxNumOfCandidatesReturned completionHandler:(void (^)(NSArray<MOFIdentifyResult> *result, NSError *error))completionHandler
{
    NSArray *faceIdStrs = nil;
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(personGroupId.length == 0)
    {
        errorDesc = [self stringNilOrEmptyMessage:@"personGroupId"];
    }
    else if((faceIdStrs = [self NSUUIDArrayToNSStringArray:faceIds]).count <1 || faceIdStrs.count >10)
    {
        errorDesc = [self arrayInvalidLengthMessage:@"faceIds(Array of NSUUID)" minLength:1 maxLength:10];
    }
    else if(maxNumOfCandidatesReturned <1 || maxNumOfCandidatesReturned >5)
    {
        errorDesc = [self paramOutOfRangeMessage:@"maxNumOfCandidatesReturned" rangeLower:@"1" rangeUpper:@"5"];
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?%@=%@", ServiceHost, IdentificationsQuery, SubscriptionKeyName,subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys:personGroupId, @"personGroupId",
                            faceIdStrs, @"faceIds",
                            [NSNumber numberWithInt:maxNumOfCandidatesReturned], @"maxNumOfCandidatesReturned", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"POST" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            NSArray<MOFIdentifyResult> *result = nil;
            if([data isKindOfClass:[NSArray class]])
            {
                result = (NSArray<MOFIdentifyResult> *)[[JSONModelArray alloc] initWithArray:(NSArray *)data modelClass:[MOFIdentifyResult class]];
            }
            
            if(completionHandler!=nil)
            {
                completionHandler(result, err);
            }
        }];
    }
    else
    {
        if(completionHandler != nil)
        {
            completionHandler(nil, error);
        }
    }
}

-(void)findSimilarFacesWithFaceId:(NSUUID *)faceId fromFaceIds:(NSArray *)faceIds completionHandler:(void (^)(NSArray<MOFSimilarFace> *result,NSError *error))completionHandler
{
    [self findSimilarFacesWithFaceId:faceId fromFaceIds:faceIds maxNumOfCandidatesReturned:20 completionHandler:completionHandler];
}

-(void)findSimilarFacesWithFaceId:(NSUUID *)faceId fromFaceIds:(NSArray *)faceIds maxNumOfCandidatesReturned:(int)maxNumOfCandidatesReturned completionHandler:(void (^)(NSArray<MOFSimilarFace> *result,NSError *error))completionHandler
{
    NSArray *faceIdStrs = nil;
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(faceId == nil)
    {
        errorDesc = [self paramNilMessage:@"faceId"];
    }
    else if((faceIdStrs = [self NSUUIDArrayToNSStringArray:faceIds]).count <1 || faceIdStrs.count >100)
    {
        errorDesc = [self arrayInvalidLengthMessage:@"faceIds(Array of NSUUID)" minLength:1 maxLength:10];
    }
    else if(maxNumOfCandidatesReturned <1 || maxNumOfCandidatesReturned >20)
    {
        errorDesc = [self paramOutOfRangeMessage:@"maxNumOfCandidatesReturned" rangeLower:@"1" rangeUpper:@"20"];
    }
    
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl=[NSString stringWithFormat:@"%@/findsimilars?%@=%@",ServiceHost, SubscriptionKeyName, subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys:[faceId UUIDString], @"faceId",
                            faceIdStrs, @"faceIds",
                            [NSNumber numberWithInt:maxNumOfCandidatesReturned], @"maxNumOfCandidatesReturned", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"POST" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            NSArray<MOFSimilarFace> *result = nil;
            if([data isKindOfClass:[NSArray class]])
            {
                result = (NSArray<MOFSimilarFace> *)[[JSONModelArray alloc] initWithArray:(NSArray *)data modelClass:[MOFSimilarFace class]];
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

-(void)findSimilarFacesWithFaceId:(NSUUID *)faceId fromGroupId:(NSString *)faceGroupId completionHandler:(void (^)(NSArray<MOFSimilarFace> *, NSError *))completionHandler
{
    [self findSimilarFacesWithFaceId:faceId fromGroupId:faceGroupId maxNumOfCandidatesReturned:20 completionHandler:completionHandler];
}

-(void)findSimilarFacesWithFaceId:(NSUUID *)faceId fromGroupId:(NSString *)faceGroupId maxNumOfCandidatesReturned:(int)maxNumOfCandidatesReturned completionHandler:(void (^)(NSArray<MOFSimilarFace> *, NSError *))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(faceId == nil)
    {
        errorDesc = [self paramNilMessage:@"faceId"];
    }
    else if(faceGroupId.length == 0)
    {
        errorDesc = [self stringNilOrEmptyMessage:@"faceGroupId"];
    }
    else if(maxNumOfCandidatesReturned <1 || maxNumOfCandidatesReturned >20)
    {
        errorDesc = [self paramOutOfRangeMessage:@"maxNumOfCandidatesReturned" rangeLower:@"1" rangeUpper:@"20"];
    }
    
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl=[NSString stringWithFormat:@"%@/findsimilars?%@=%@",ServiceHost, SubscriptionKeyName, subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys:[faceId UUIDString], @"faceId",
                            faceGroupId, @"faceGroupId",
                            [NSNumber numberWithInt:maxNumOfCandidatesReturned], @"maxNumOfCandidatesReturned", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"POST" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            NSArray<MOFSimilarFace> *result = nil;
            if([data isKindOfClass:[NSArray class]])
            {
                result = (NSArray<MOFSimilarFace> *)[[JSONModelArray alloc] initWithArray:(NSArray *)data modelClass:[MOFSimilarFace class]];
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

-(void)groupFaces:(NSArray *)faceIds completionHandler:(void (^)(MOFGroupResult *result,NSError *error))completionHandler
{
    NSArray *faceIdStrs = nil;
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if((faceIdStrs = [self NSUUIDArrayToNSStringArray:faceIds]).count <2 || faceIdStrs.count >100)
    {
        errorDesc = [self arrayInvalidLengthMessage:@"faceIds(Array of NSUUID)" minLength:2 maxLength:100];
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl=[NSString stringWithFormat:@"%@/groupings?%@=%@",ServiceHost, SubscriptionKeyName, subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObject:faceIdStrs forKey:@"faceIds"];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"POST" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            MOFGroupResult *result = nil;
            if([data isKindOfClass:[NSDictionary class]])
            {
                result = [[MOFGroupResult alloc] initWithDictionary:(NSDictionary *)data error:&err];
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

#pragma mark - MOFFaceServiceClientProtocol Implementation PersonGroup

-(void)createPersonGroup:(NSString *)personGroupId groupName:(NSString *)groupName userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if(groupName.length == 0 || groupName.length > 128)
    {
        errorDesc = @"Invalid param groupName. The length of groupName should >0 and <=128.";
    }
    else if([self stringLengthInBytes:userData] > 1024*16)
    {
        errorDesc = @"Invalid param userData. The length of userData should <=16k.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, SubscriptionKeyName,subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys:groupName, @"name",
                            [self emptyStringForNil:userData], @"userData", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"PUT" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            if(completionHandler!=nil)
            {
                completionHandler(err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
    }
}

-(void)getPersonGroupWithId:(NSString *)personGroupId completionHandler:(void (^)(MOFPersonGroup *result, NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, SubscriptionKeyName,subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"GET" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        MOFPersonGroup *result = nil;
        if([data isKindOfClass:[NSDictionary class]])
        {
            result = [[MOFPersonGroup alloc] initWithDictionary:(NSDictionary *)data error: &err];
        }
        
        if(completionHandler!=nil)
        {
            completionHandler(result, err);
        }
    }];
}

-(void)updatePersonGroupWithId:(NSString *)personGroupId groupName:(NSString *)groupName userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if(groupName.length == 0 || groupName.length > 128)
    {
        errorDesc = @"Invalid param groupName. The length of groupName should >0 and <=128.";
    }
    else if([self stringLengthInBytes:userData] > 1024*16)
    {
        errorDesc = @"Invalid param userData. The length of userData should <=16k.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, SubscriptionKeyName,subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys:groupName, @"name",
                            [self emptyStringForNil:userData], @"userData", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"PATCH" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            if(completionHandler!=nil)
            {
                completionHandler(err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
    }
}

-(void)deletePersonGroupWithId:(NSString *)personGroupId completionHandler:(void (^)(NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, SubscriptionKeyName,subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"DELETE" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        if(completionHandler!=nil)
        {
            completionHandler(err);
        }
    }];
}

-(void)getPersonGroups:(void (^)(NSArray<MOFPersonGroup> *result, NSError *error))completionHandler
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, SubscriptionKeyName,subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"GET" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        NSArray<MOFPersonGroup> *result = nil;
        if([data isKindOfClass:[NSArray class]])
        {
            result = (NSArray<MOFPersonGroup> *)[[JSONModelArray alloc] initWithArray:(NSArray *)data modelClass:[MOFPersonGroup class]];
        }
        
        if(completionHandler!=nil)
        {
            completionHandler(result, err);
        }
    }];
}

-(void)trainPersonGroupWithId:(NSString *)personGroupId completionHandler:(void (^)(MOFTrainingStatus *result, NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil,error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, TrainingQuery, SubscriptionKeyName, subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"POST" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        MOFTrainingStatus *result = nil;
        if([data isKindOfClass:[NSDictionary class]])
        {
            result = [[MOFTrainingStatus alloc] initWithDictionary:(NSDictionary *)data error: &err];
        }
        
        if(completionHandler!=nil)
        {
            completionHandler(result,err);
        }
    }];
}

-(void)getPersonGroupTrainingStatusWithId:(NSString *)personGroupId completionHandler:(void (^)(MOFTrainingStatus *result, NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, TrainingQuery, SubscriptionKeyName, subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"GET" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        MOFTrainingStatus *result = nil;
        if([data isKindOfClass:[NSDictionary class]])
        {
            result = [[MOFTrainingStatus alloc] initWithDictionary:(NSDictionary *)data error: &err];
        }
        
        if(completionHandler!=nil)
        {
            completionHandler(result,err);
        }
    }];
}

#pragma mark - MOFFaceServiceClientProtocol Implementation Person

-(void)createPersonWithGroupId:(NSString *)personGroupId faceIds:(NSArray *)faceIds name:(NSString *)name userData:(NSString *)userData completionHandler:(void (^)(MOFCreatePersonResult *result, NSError *error))completionHandler
{
    NSArray *faceIdStrs = nil;
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if((faceIdStrs = [self NSUUIDArrayToNSStringArray:faceIds]).count > 32)
    {
        errorDesc = [self arrayInvalidLengthMessage:@"faceIds(Array of NSUUID)" minLength:0 maxLength:10];
    }
    else if(name.length == 0 || name.length > 128)
    {
        errorDesc = @"Invalid param name. The length of name should >0 and <=128.";
    }
    else if([self stringLengthInBytes:userData] > 1024*16)
    {
        errorDesc = @"Invalid param userData. The length of userData should <=16k.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, SubscriptionKeyName, subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys: name, @"name",
                            [self emptyStringForNil:faceIdStrs], @"faceIds",
                            [self emptyStringForNil:userData], @"userData", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"POST" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            MOFCreatePersonResult *result = nil;
            if([data isKindOfClass:[NSDictionary class]])
            {
                result = [[MOFCreatePersonResult alloc] initWithDictionary:(NSDictionary *)data error: &err];
            }
            
            if(completionHandler!=nil)
            {
                completionHandler(result,err);
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

-(void)getPersonWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId completionHandler:(void (^)(MOFPerson *result, NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if(personId == nil)
    {
        errorDesc = [self paramNilMessage:@"personId"];
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, [personId UUIDString], SubscriptionKeyName, subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"GET" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        MOFPerson *result = nil;
        if([data isKindOfClass:[NSDictionary class]])
        {
            result = [[MOFPerson alloc] initWithDictionary: (NSDictionary *)data error: &err];
        }
        
        if(completionHandler!=nil)
        {
            completionHandler(result,err);
        }
    }];
}

-(void)updatePersonwithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId faceIds:(NSArray *)faceIds name:(NSString *)name userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler
{
    NSArray *faceIdStrs = nil;
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if((faceIdStrs = [self NSUUIDArrayToNSStringArray:faceIds]).count > 32)
    {
        errorDesc = [self arrayInvalidLengthMessage:@"faceIds(Array of NSUUID)" minLength:0 maxLength:10];
    }
    else if(name.length == 0 || name.length > 128)
    {
        errorDesc = @"Invalid param name. The length of name should >0 and <=128.";
    }
    else if([self stringLengthInBytes:userData] > 1024*16)
    {
        errorDesc = @"Invalid param userData. The length of userData should <=16k.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, [personId UUIDString], SubscriptionKeyName, subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys: name, @"name",
                            [self emptyStringForNil:faceIdStrs], @"faceIds",
                            [self emptyStringForNil:userData], @"userData", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"PATCH" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            if(completionHandler!=nil)
            {
                completionHandler(err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
    }
}

-(void)deletePersonWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId completionHandler:(void (^)(NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if(personId == nil)
    {
        errorDesc = [self paramNilMessage:@"personId"];
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, [personId UUIDString], SubscriptionKeyName, subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"DELETE" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        if(completionHandler!=nil)
        {
            completionHandler(err);
        }
    }];
}

-(void)getPersonsWithGroupId:(NSString *)personGroupId completionHandler:(void (^)(NSArray<MOFPerson> *result,NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, SubscriptionKeyName, subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"GET" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        NSArray<MOFPerson> *result = nil;
        if([data isKindOfClass:[NSArray class]])
        {
            result = (NSArray<MOFPerson> *)[[JSONModelArray alloc] initWithArray:(NSArray *)data modelClass:[MOFPerson class]];
        }
        
        if(completionHandler!=nil)
        {
            completionHandler(result, err);
        }
    }];
}

-(void)addPersonFaceWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId faceId:(NSUUID *)faceId userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if(personId == nil)
    {
        errorDesc = [self paramNilMessage:@"personId"];
    }
    else if(faceId == nil)
    {
        errorDesc = [self paramNilMessage:@"faceId"];
    }
    else if([self stringLengthInBytes:userData] > 1024)
    {
        errorDesc = @"Invalid param userData. The length of userData should <=1k.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, [personId UUIDString], FacesQuery, [faceId UUIDString], SubscriptionKeyName, subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys:[self emptyStringForNil:userData], @"userData", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"PUT" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            if(completionHandler!=nil)
            {
                completionHandler(err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
    }
}

-(void)getPersonFaceWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId faceId:(NSUUID *)faceId completionHandler:(void (^)(MOFPersonFace *result, NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if(personId == nil)
    {
        errorDesc = [self paramNilMessage:@"personId"];
    }
    else if(faceId == nil)
    {
        errorDesc = [self paramNilMessage:@"faceId"];
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, [personId UUIDString], FacesQuery, [faceId UUIDString], SubscriptionKeyName, subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"GET" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        MOFPersonFace *result = nil;
        if([data isKindOfClass:[NSDictionary class]])
        {
            result = [[MOFPersonFace alloc] initWithDictionary:(NSDictionary *)data error: &err];
        }
        
        if(completionHandler!=nil)
        {
            completionHandler(result,err);
        }
    }];
}

-(void)updatePersonFaceWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId faceId:(NSUUID *)faceId userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if(personId == nil)
    {
        errorDesc = [self paramNilMessage:@"personId"];
    }
    else if(faceId == nil)
    {
        errorDesc = [self paramNilMessage:@"faceId"];
    }
    else if([self stringLengthInBytes:userData] > 1024)
    {
        errorDesc = @"Invalid param userData. The length of userData should <=1k.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, [personId UUIDString], FacesQuery, [faceId UUIDString], SubscriptionKeyName, subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys:[self emptyStringForNil:userData], @"userData", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"PATCH" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            if(completionHandler!=nil)
            {
                completionHandler(err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
    }
}

-(void)deletePersonFaceWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId faceId:(NSUUID *)faceId completionHandler:(void (^)(NSError *error))completionHandler
{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:personGroupId])
    {
        errorDesc = @"Invalid param personGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if(personId == nil)
    {
        errorDesc = [self paramNilMessage:@"personId"];
    }
    else if(faceId == nil)
    {
        errorDesc = [self paramNilMessage:@"faceId"];
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@?%@=%@", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, [personId UUIDString], FacesQuery, [faceId UUIDString], SubscriptionKeyName, subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"DELETE" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        if(completionHandler!=nil)
        {
            completionHandler(err);
        }
    }];
}

#pragma mark - MOFFaceServiceClientProtocol Implementation FaceGroup

-(void)createFaceGroupWithGroupId:(NSString *)faceGroupId groupName:(NSString *)groupName faces:(NSArray<MOFPersonFace> *)faces userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:faceGroupId])
    {
        errorDesc = @"Invalid param faceGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if(groupName.length == 0 || groupName.length > 128)
    {
        errorDesc = @"Invalid param groupName. The length of groupName should >0 and <=128.";
    }
    else if([self stringLengthInBytes:userData] > 1024*16)
    {
        errorDesc = @"Invalid param userData. The length of userData should <=16k.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@?%@=%@", ServiceHost, FaceGroupsQuery, faceGroupId, SubscriptionKeyName,subscriptionKey];
    
    NSArray *faceObjects = [self facesToJsonObjects:faces];
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys:groupName, @"name",
                            [self emptyStringForNil:userData], @"userData",
                            [self emptyStringForNil:faceObjects], @"faces", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"PUT" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            if(completionHandler!=nil)
            {
                completionHandler(err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
    }
}

-(void)getFaceGroupWithId:(NSString *)faceGroupId completionHandler:(void (^)(MOFFaceGroup *result, NSError *error))completionHandler{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:faceGroupId])
    {
        errorDesc = @"Invalid param faceGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(nil, error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@?%@=%@", ServiceHost, FaceGroupsQuery, faceGroupId, SubscriptionKeyName,subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"GET" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        MOFFaceGroup *result = nil;
        if([data isKindOfClass:[NSDictionary class]])
        {
            result = [[MOFFaceGroup alloc] initWithDictionary:(NSDictionary *)data error: &err];
        }
        
        if(completionHandler!=nil)
        {
            completionHandler(result, err);
        }
    }];
}

-(void)getFaceGroups:(void (^)(NSArray<MOFFaceGroup> *result, NSError *error))completionHandler{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?%@=%@", ServiceHost, FaceGroupsQuery, SubscriptionKeyName,subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"GET" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        NSArray<MOFFaceGroup> *result = nil;
        if([data isKindOfClass:[NSArray class]])
        {
            result = (NSArray<MOFFaceGroup> *)[[JSONModelArray alloc] initWithArray:(NSArray *)data modelClass:[MOFFaceGroup class]];
        }
        
        if(completionHandler!=nil)
        {
            completionHandler(result, err);
        }
    }];
}

-(void)updateFaceGroupWithId:(NSString *)faceGroupId groupName:(NSString *)groupName userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:faceGroupId])
    {
        errorDesc = @"Invalid param faceGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    else if(groupName.length == 0 || groupName.length > 128)
    {
        errorDesc = @"Invalid param groupName. The length of groupName should >0 and <=128.";
    }
    else if([self stringLengthInBytes:userData] > 1024*16)
    {
        errorDesc = @"Invalid param userData. The length of userData should <=16k.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@?%@=%@", ServiceHost, FaceGroupsQuery, faceGroupId, SubscriptionKeyName,subscriptionKey];
    
    NSDictionary *bodyDict=[NSDictionary dictionaryWithObjectsAndKeys:groupName, @"name",
                            [self emptyStringForNil:userData], @"userData", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"PATCH" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            if(completionHandler!=nil)
            {
                completionHandler(err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
    }
}

-(void)deleteFaceGroupWithId:(NSString *)faceGroupId completionHandler:(void (^)(NSError *error))completionHandler{
    NSError *error = nil;
    NSString *errorDesc = nil;
    
    //validate params
    if(![self validateGroupId:faceGroupId])
    {
        errorDesc = @"Invalid param faceGroupId. Valid character is letter in lower case or digit or '-' or '_', length <=64.";
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@?%@=%@", ServiceHost, FaceGroupsQuery, faceGroupId, SubscriptionKeyName,subscriptionKey];
    
    [self sendToUrl:requestUrl httpMethod:@"DELETE" data:nil contentType:nil completionHandler:^(NSObject *data, NSError *err) {
        if(completionHandler!=nil)
        {
            completionHandler(err);
        }
    }];
}

-(void)addFacesToFaceGroupWithId:(NSString *)faceGroupId faces:(NSArray<MOFPersonFace> *)faces completionHandler:(void (^)(NSError *error))completionHandler{
    NSError *error = nil;
    NSString *errorDesc = nil;
    NSArray *faceObjects = [self facesToJsonObjects:faces];
    
    //validate params
    if(faceObjects.count <1 || faceObjects.count >1000)
    {
        errorDesc =[self arrayInvalidLengthMessage:@"faces(NSArray of MOFPersonFace)" minLength:1 maxLength:1000];
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@?%@=%@", ServiceHost, FaceGroupsQuery, faceGroupId, FacesQuery, SubscriptionKeyName,subscriptionKey];
    
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:faceObjects, @"faces", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"PUT" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            if(completionHandler!=nil)
            {
                completionHandler(err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
    }
}

-(void)deleteFacesFromFaceGroupWithId:(NSString *)faceGroupId faceIds:(NSArray *)faceIds completionHandler:(void (^)(NSError *error))completionHandler{
    NSError *error = nil;
    NSString *errorDesc = nil;
    NSArray *faceIdStrs = [self NSUUIDArrayToNSStringArray:faceIds];
    
    //validate params
    if(faceIdStrs.count <1 || faceIdStrs.count >1000)
    {
        errorDesc = [self arrayInvalidLengthMessage:@"faceIds(Array of NSUUID)" minLength:1 maxLength:1000];
    }
    
    if(errorDesc.length > 0)
    {
        error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:kFaceErrorInvalidParam userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
        
        return;
    }
    
    //request
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@?%@=%@", ServiceHost, FaceGroupsQuery, faceGroupId, FacesQuery, SubscriptionKeyName,subscriptionKey];
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObject:faceIdStrs forKey:@"faceIds"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    if(jsonData)
    {
        [self sendToUrl:requestUrl httpMethod:@"DELETE" data:jsonData contentType:ContentTypeJson completionHandler:^(NSObject *data, NSError *err) {
            if(completionHandler!=nil)
            {
                completionHandler(err);
            }
        }];
    }
    else
    {
        if(completionHandler!=nil)
        {
            completionHandler(error);
        }
    }
}

#pragma mark - param validation error message

-(NSString *)stringNilOrEmptyMessage:(NSString *)paramName
{
    return [NSString stringWithFormat:@"Invalid param %@. %@ can't be nil or empty.", paramName, paramName];
}

-(NSString *)paramNilMessage:(NSString *)paramName
{
    return [NSString stringWithFormat:@"Invalid param %@. %@ can't be nil.", paramName, paramName];
}

-(NSString *)paramOutOfRangeMessage:(NSString *)paramName rangeLower:(NSString *)rangeLower rangeUpper:(NSString *)rangeUpper
{
    return [NSString stringWithFormat:@"Invalid param %@. %@ should be between %@ and %@.", paramName, paramName, rangeLower, rangeUpper];
}

-(NSString *)arrayInvalidLengthMessage:(NSString *)paramName minLength:(int)minLength maxLength:(int)maxLength
{
    return [NSString stringWithFormat:@"Invalid param %@. The length of %@ should be between %d and %d.", paramName, paramName, minLength, maxLength];
}

-(NSString *)UUIDArrayInvalidMessage:(NSString *)paramName
{
    return [NSString stringWithFormat:@"Invalid param %@. %@ isn't a valid NSUUID array.", paramName, paramName];
}

#pragma mark - custom methods

-(NSString *)boolToString:(BOOL) value
{
    return value? @"true" : @"false";
}

-(NSUInteger)stringLengthInBytes:(NSString *)candidate
{
    if(candidate == nil){
        return 0;
    }
    else{
        return [candidate dataUsingEncoding:NSUTF8StringEncoding].length;
    }
}

/**
 * Determine whether a string is a validate url string.
 * @param candidate The string to be detected.
 */
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

/**
 * Determine whether a string is a validate personGroupId.
 * @param candidate The string to be detected.
 */
-(BOOL)validateGroupId: (NSString *)candidate
{
    NSString *regex = @"^[a-z0-9_-]+$";
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL match = [predicate evaluateWithObject:candidate];
    BOOL valid = match && candidate.length <= 64;
    return valid;
}

/**
 * Convert a MOFPersonFace array to JSON objects array.
 */
-(NSArray *)facesToJsonObjects:(NSArray<MOFPersonFace> *)faces
{
    if(faces.count >0)
    {
        NSArray* jsonObjects = [MOFPersonFace arrayOfDictionariesFromModels: faces];
        return jsonObjects;
    }
    else
    {
        return nil;
    }
}

/**
 * Replace nil with empty string
 */
-(NSString *)emptyStringForNil:(id)str
{
    return str==nil? @"":str;
}

/**
 * Check and convert NSUUID array.
 * @return converted NSString array if all items are NSUUID, otherwise nil.
 */
-(NSArray *)NSUUIDArrayToNSStringArray:(NSArray *)uuidArray
{
    if(uuidArray.count == 0)
        return nil;
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSUUID *uuid in uuidArray) {
        if([uuid isKindOfClass:[NSUUID class]])
        {
            [result addObject:[[uuid UUIDString] lowercaseString]];
        }
        else
        {
            result = nil;
            break;
        }
    }
    return result;
}

/**
 * Send http request to the specified URL. Supported Http methods include GET, POST, PUT, DELETE and PATCH.
 * @param url The request url.
 * @param httpMethod The http request method.
 * @param data The http request body is there is.
 * @param contentType The http request header content-type.
 * @param completionHandler The block to execute upon completion which returns result data.
 */
-(void) sendToUrl:(NSString *)url httpMethod:(NSString *)httpMethod data:(NSData *)data contentType:(NSString *)contentType completionHandler:(void (^)(NSObject *data, NSError *error))completionHandler
{
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:httpMethod];
    if(contentType)
    {
        [request setValue:contentType forHTTPHeaderField:@"content-type"];
    }
    if(data != nil)
    {
        [request setHTTPBody:data];
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSObject *result = nil;
        
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
        if(httpResp)
        {
            if(httpResp.statusCode == kHttpStatusCodeOK || httpResp.statusCode == kHttpStatusCodeCreated || httpResp.statusCode == kHttpStatusCodeAccepted)
            {
                NSString *contentType = httpResp.allHeaderFields[@"Content-Type"];
                if([contentType containsString: @"application/json"])
                {
                    if(data)
                    {
                        //jsonResult
                        result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                        NSLog(@"%@",result);
                    }
                }
                else
                {
                    result = data;
                }
            }
            else if(data)
            {
                NSString *errorDesc = [NSString stringWithFormat:@"Http Response status code: %ld", (long)httpResp.statusCode];
                ClientError *clientError = [[ClientError alloc] initWithData:data error:&error];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorDesc, NSLocalizedDescriptionKey, clientError, @"ClientError", nil];
                error = [NSError errorWithDomain:ProjectOxfordFaceErrorDomain code:httpResp.statusCode userInfo:userInfo];
                NSLog(@"%@",error);
            }
        }
        
        if(completionHandler != nil)
        {
            completionHandler(result, error);
        }
    }];
    
    [dataTask resume];
}

@end
