//
//  MOFFaceServiceClientProtocol1.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#ifndef ProjectOxfordFaceLib_MOFFaceServiceClientProtocol_h
#define ProjectOxfordFaceLib_MOFFaceServiceClientProtocol_h

#import <Foundation/Foundation.h>
#import "MOFFace.h"
#import "MOFIdentifyResult.h"

/**
 * @discussion Face service client protocol.
 */
@protocol MOFFaceServiceClientProtocol <NSObject>

#pragma mark - Face

/**
 * Detects an URL asynchronously.
 * @param imageUrl The image URL.
 * @param analyzesFacelandmarks If true, analyzes face landmarks.
 * @param analyzesAge If true, analyzes age.
 * @param analyzesGender If true, analyzes gender.
 * @param analyzesHeadPose If true, analyzes head pose.
 * @param completionHandler The block to execute upon completion which returns detected faces.
 */
-(void)detectFacesFromImageUrl:(NSString *)imageUrl analyzesFacelandmarks:(BOOL)analyzesFacelandmarks analyzesAge:(BOOL)analyzesAge analyzesGender:(BOOL)analyzesGender analyzesHeadPose:(BOOL)analyzesHeadPose completionHandler:(void (^)(NSArray<MOFFace> *result, NSError *error))completionHandler;

/**
 * Detects an image asynchronously.
 * @param imageData The image data.
 * @param analyzesFacelandmarks If true, analyzes face landmarks.
 * @param analyzesAge If true, analyzes age.
 * @param analyzesGender If true, analyzes gender.
 * @param analyzesHeadPose If true, analyzes head pose.
 * @param completionHandler The block to execute upon completion which returns detected faces.
 */
-(void)detectFacesWithImageData:(NSData *)imageData analyzesFacelandmarks:(BOOL)analyzesFacelandmarks analyzesAge:(BOOL)analyzesAge analyzesGender:(BOOL)analyzesGender analyzesHeadPose:(BOOL)analyzesHeadPose completionHandler:(void (^)(NSArray<MOFFace> *result, NSError *error))completionHandler;

/**
 * Verifies whether the specified two faces belong to the same person asynchronously.
 * @param faceId1 The face identifier 1.
 * @param faceId2 The face identifier 2.
 * @param completionHandler The block to execute upon completion which returns verification result.
 */
-(void)verfifyFaceWithId:(NSUUID *)faceId1 faceId2:(NSUUID *)faceId2 completionHandler:(void (^)(MOFVerifyResult *result, NSError *error))completionHandler;

/**
 * Identities the faces in a given person group asynchronously.
 * @param personGroupId The person group id.
 * @param faceIds The face ids. Array of NSUUID.
 * @param completionHandler The block to execute upon completion which returns identification results.
 */
-(void)identifyFacesInGroup:(NSString *)personGroupId faceIds:(NSArray *)faceIds completionHandler:(void (^)(NSArray<MOFIdentifyResult> *result, NSError *error))completionHandler;

/**
 * Identities the faces in a given person group asynchronously.
 * @param personGroupId The person group id.
 * @param faceIds The face ids. Array of NSUUID.
 * @param maxNumOfCandidatesReturned The maximum number of candidates returned for each face.
 * @param completionHandler The block to execute upon completion which returns identification results.
 */
-(void)identifyFacesInGroup:(NSString *)personGroupId faceIds:(NSArray *)faceIds maxNumOfCandidatesReturned:(int) maxNumOfCandidatesReturned completionHandler:(void (^)(NSArray<MOFIdentifyResult> *result, NSError *error))completionHandler;

/**
 * Finds the similar faces with maxNumOfCandidatesReturned default 20.
 * @param faceId The face id.
 * @param faceIds The face ids. Array of NSUUID.
 * @param completionHandler The block to execute upon completion which returns similar face array.
 */
-(void)findSimilarFacesWithFaceId:(NSUUID *)faceId fromFaceIds:(NSArray *)faceIds completionHandler:(void (^)(NSArray<MOFSimilarFace> *result,NSError *error))completionHandler;

/**
 * Finds the similar faces.
 * @param faceId The face id.
 * @param faceIds The face ids. Array of NSUUID.
 * @param completionHandler The block to execute upon completion which returns similar face array.
 */
-(void)findSimilarFacesWithFaceId:(NSUUID *)faceId fromFaceIds:(NSArray *)faceIds maxNumOfCandidatesReturned:(int)maxNumOfCandidatesReturned completionHandler:(void (^)(NSArray<MOFSimilarFace> *result,NSError *error))completionHandler;

/**
 * Finds the similar faces with maxNumOfCandidatesReturned default 20.
 * @param faceId The face id.
 * @param faceGroupId The face group id.
 * @param completionHandler The block to execute upon completion which returns similar face array.
 */
-(void)findSimilarFacesWithFaceId:(NSUUID *)faceId fromGroupId:(NSString *)faceGroupId completionHandler:(void (^)(NSArray<MOFSimilarFace> *result,NSError *error))completionHandler;

/**
 * Finds the similar faces with maxNumOfCandidatesReturned default 20.
 * @param faceId The face id.
 * @param faceGroupId The face group id.
 * @param completionHandler The block to execute upon completion which returns similar face array.
 */
-(void)findSimilarFacesWithFaceId:(NSUUID *)faceId fromGroupId:(NSString *)faceGroupId maxNumOfCandidatesReturned:(int)maxNumOfCandidatesReturned completionHandler:(void (^)(NSArray<MOFSimilarFace> *result,NSError *error))completionHandler;

///!!!the result format is not perfect.
/**
 * Groups the face.
 * @param faceIds The face ids.
 * @param completionHandler The block to execute upon completion which returns group result entity.
 */
-(void)groupFaces:(NSArray *)faceIds completionHandler:(void (^)(MOFGroupResult *result,NSError *error))completionHandler;

#pragma mark - PersonGroup

/**
 * Creates the person group asynchronously.
 * @param personGroupId The person group id.
 * @param groupName The group name.
 * @param userData The user data.
 * @param completionHandler The block to execute upon completion.
 */
-(void)createPersonGroup:(NSString *)personGroupId groupName:(NSString *)groupName userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Gets a person group asynchronously.
 * @param personGroupId The person group id.
 * @param completionHandler The block to execute upon completion which returns a person group entity.
 */
-(void)getPersonGroupWithId:(NSString *)personGroupId completionHandler:(void (^)(MOFPersonGroup *result, NSError *error))completionHandler;

/**
 * Updates a person group asynchronously.
 * @param personGroupId The person group id.
 * @param groupName The group name.
 * @param userData The user data.
 * @param completionHandler The block to execute upon completion.
 */
-(void)updatePersonGroupWithId:(NSString *)personGroupId groupName:(NSString *)groupName userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Deletes a person group asynchronously.
 * @param personGroupId The person group id.
 * @param completionHandler The block to execute upon completion.
 */
-(void)deletePersonGroupWithId:(NSString *)personGroupId completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Gets all person groups asynchronously.
 * @param completionHandler The block to execute upon completion which returns a person group entity array.
 */
-(void)getPersonGroups:(void (^)(NSArray<MOFPersonGroup> *result, NSError *error))completionHandler;

/**
 * Trains the person group asynchronously.
 * @param personGroupId The person group id.
 * @param completionHandler The block to execute upon completion.
 */
-(void)trainPersonGroupWithId:(NSString *)personGroupId completionHandler:(void (^)(MOFTrainingStatus *result, NSError *error))completionHandler;

/**
 * Gets person group training status asynchronously.
 * @param personGroupId The person group id.
 * @param completionHandler The block to execute upon completion which returns the person group training status.
 */
-(void)getPersonGroupTrainingStatusWithId:(NSString *)personGroupId completionHandler:(void (^)(MOFTrainingStatus *result, NSError *error))completionHandler;

#pragma mark - Person

/**
 * Creates a person asynchronously.
 * @param personGroupId The person group id.
 * @param faceIds The face ids.
 * @param name The name.
 * @param userData The user data.
 * @param completionHandler The block to execute upon completion which returns MOFCreatePersonResult entity.
 */
-(void)createPersonWithGroupId:(NSString *)personGroupId faceIds:(NSArray *)faceIds name:(NSString *)name userData:(NSString *)userData completionHandler:(void (^)(MOFCreatePersonResult *result, NSError *error))completionHandler;

/**
 * Gets a person asynchronously.
 * @param personGroupId The person group id.
 * @param personId The person id.
 * @param completionHandler The block to execute upon completion which returns person entity.
 */
-(void)getPersonWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId completionHandler:(void (^)(MOFPerson *result, NSError *error))completionHandler;

/**
 * Updates a person asynchronously.
 * @param personGroupId The person group id.
 * @param faceIds The face ids.
 * @param name The name.
 * @param userData The user data.
 * @param completionHandler The block to execute upon completion.
 */
-(void)updatePersonwithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId faceIds:(NSArray *)faceIds name:(NSString *)name userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Deletes a person asynchronously.
 * @param personGroupId The person group id.
 * @param personId The person id.
 * @param completionHandler The block to execute upon completion.
 */
-(void)deletePersonWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Gets all persons inside a person group asynchronously.
 * @param personGroupId The person group id.
 * @param completionHandler The block to execute upon completion which returns person entity array.
 */
-(void)getPersonsWithGroupId:(NSString *)personGroupId completionHandler:(void (^)(NSArray<MOFPerson> *result,NSError *error))completionHandler;

/**
 * Adds a face to a person asynchronously.
 * @param personGroupId The person group id.
 * @param personId The person id.
 * @param faceId The face id.
 * @param userData The user data.
 * @param completionHandler The block to execute upon completion.
 */
-(void)addPersonFaceWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId faceId:(NSUUID *)faceId userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Gets a face of a person asynchronously.
 * @param personGroupId The person group id.
 * @param personId The person id.
 * @param faceId The face id.
 * @param completionHandler The block to execute upon completion which returns person face entity.
 */
-(void)getPersonFaceWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId faceId:(NSUUID *)faceId completionHandler:(void (^)(MOFPersonFace *result, NSError *error))completionHandler;

/**
 * Updates a face of a person asynchronously.
 * @param personGroupId The person group id.
 * @param personId The person id.
 * @param faceId The face id.
 * @param userData The user data.
 * @param completionHandler The block to execute upon completion.
 */
-(void)updatePersonFaceWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId faceId:(NSUUID *)faceId userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Deletes a face of a person asynchronously.
 * @param personGroupId The person group id.
 * @param personId The person id.
 * @param faceId The face id.
 * @param completionHandler The block to execute upon completion.
 */
-(void)deletePersonFaceWithGroupId:(NSString *)personGroupId personId:(NSUUID *)personId faceId:(NSUUID *)faceId completionHandler:(void (^)(NSError *error))completionHandler;

#pragma mark - FaceGroup

/**
 * Creates the face group asynchronously.
 * @param faceGroupId The face group id.
 * @param groupName The group name.
 * @param faces The faces in the face group.
 * @param userData The user data.
 * @param completionHandler The block to execute upon completion.
 */
-(void)createFaceGroupWithGroupId:(NSString *)faceGroupId groupName:(NSString *)groupName faces:(NSArray<MOFPersonFace> *)faces userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Gets a face group asynchronously.
 * @param faceGroupId The face group id.
 * @param completionHandler The block to execute upon completion which returns a face group entity.
 */
-(void)getFaceGroupWithId:(NSString *)faceGroupId completionHandler:(void (^)(MOFFaceGroup *result, NSError *error))completionHandler;

/**
 * Gets all face groups asynchronously.
 * @param completionHandler The block to execute upon completion which returns a face group entity array.
 */
-(void)getFaceGroups:(void (^)(NSArray<MOFFaceGroup> *result, NSError *error))completionHandler;

/**
 * Updates a face group asynchronously.
 * @param faceGroupId The face group id.
 * @param groupName The group name.
 * @param userData The user data.
 * @param completionHandler The block to execute upon completion.
 */
-(void)updateFaceGroupWithId:(NSString *)faceGroupId groupName:(NSString *)groupName userData:(NSString *)userData completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Deletes a face group asynchronously.
 * @param faceGroupId The face group id.
 * @param completionHandler The block to execute upon completion.
 */
-(void)deleteFaceGroupWithId:(NSString *)faceGroupId completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Add faces to a face group asynchronously.
 * @param faceGroupId The face group id.
 * @param faces The faces to be added.
 * @param completionHandler The block to execute upon completion.
 */
-(void)addFacesToFaceGroupWithId:(NSString *)faceGroupId faces:(NSArray<MOFPersonFace> *)faces completionHandler:(void (^)(NSError *error))completionHandler;

/**
 * Delete faces from a face group asynchronously.
 * @param faceGroupId The face group id.
 * @param faceIds The faceIds to be deleted. Array of NSUUID.
 * @param completionHandler The block to execute upon completion.
 */
-(void)deleteFacesFromFaceGroupWithId:(NSString *)faceGroupId faceIds:(NSArray *)faceIds completionHandler:(void (^)(NSError *error))completionHandler;

@end

#endif