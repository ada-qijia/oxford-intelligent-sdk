//
//  OthersViewController.m
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "OthersViewController.h"
#import "AppDelegate.h"

@interface OthersViewController ()

@property NSArray *APIMethods;

@end

static NSString * const PersonGroupId = @"family_test_group";
static NSString * const PersonGroupName = @"FamilyTest";
static NSString * const PersonName = @"Dad";
static NSString * const FaceGroupId = @"dad_face_test_group";
static NSString * const FaceGroupName = @"DadFaceTest";
static NSString * const UserData = @"UserData1";

@implementation OthersViewController
{
    MOFFaceServiceClient *client;
    NSData *familyImageData;
    NSData *dad1ImageData;
    NSMutableArray *familyFaceIds; //NSUUID array
    NSUUID *dadFaceId;
    NSUUID *similarFaceId;
    NSUUID *personId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"All";
    
    //Modify DescriptionLabel top constraint to relative to topLayoutGuide
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.DescriptionLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.topLayoutGuide
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:8.0];
    [self.view removeConstraint:(NSLayoutConstraint *)self.view.constraints[1]];
    [self.view addConstraint:constraint];
    
    [self prepareAPIMethods];
    
    //initialize MOFFaceServiceClient
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    client = appDelegate.client;
    familyImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"Family1.jpg"], 1.0);
    dad1ImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"Family1-Dad1.jpg"], 1.0);
    familyFaceIds = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)GoClicked:(id)sender {
    __weak OthersViewController *weakSelf = self;
    NSInteger selectedRow = [self.MethodsPikcerView selectedRowInComponent:0];
    NSString *methodName = self.APIMethods[selectedRow];
    
    self.ResultTextView.text = nil;
    [self.ResultTextView insertText:[NSString stringWithFormat:@"Start %@ ... \n", methodName]];
    
    //Detect multiple face
    if([methodName isEqualToString:@"DetectFaces"]) {
        [familyFaceIds removeAllObjects];
        [client detectFacesWithImageData:familyImageData analyzesFacelandmarks:true analyzesAge:true analyzesGender:true analyzesHeadPose:true completionHandler:^(NSArray<MOFFace> *result, NSError *error) {
            if(result)
            {
                for (MOFFace *face in result) {
                    [familyFaceIds addObject:face.FaceId];
                }
            }
            NSLog(@"familyFaceIds: %@",familyFaceIds);
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //Detect single face
    else if([methodName isEqualToString:@"DetectOneFace"]) {
        dadFaceId = nil;
        [client detectFacesWithImageData:dad1ImageData analyzesFacelandmarks:true analyzesAge:true analyzesGender:true analyzesHeadPose:true completionHandler:^(NSArray<MOFFace> *result, NSError *error) {
            if(result && result.count > 0)
            {
                dadFaceId = ((MOFFace *)result[0]).FaceId;
            }
            NSLog(@"dadFaceId: %@",dadFaceId);
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //Verify
    else if([methodName isEqualToString:@"Verify"]) {
        [client verfifyFaceWithId:familyFaceIds[0] faceId2:dadFaceId completionHandler:^(MOFVerifyResult *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //FindSimilar
    else if([methodName isEqualToString:@"FindSimilar"]) {
        [client findSimilarFacesWithFaceId:dadFaceId fromFaceIds:familyFaceIds completionHandler:^(NSArray<MOFSimilarFace> *result, NSError *error) {
            if(result.count > 0)
            {
                similarFaceId = ((MOFSimilarFace *)result[0]).FaceId;
            }
            NSLog(@"similarFaceId: %@",similarFaceId);
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    // Group
    else if([methodName isEqualToString:@"Group"]) {
        NSMutableArray *allFaceIds = [NSMutableArray arrayWithArray:familyFaceIds];
        [allFaceIds addObject:dadFaceId];
        [client groupFaces:allFaceIds completionHandler:^(MOFGroupResult *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //CreatePersonGroup
    else if([methodName isEqualToString:@"CreatePersonGroup"]) {
        [client createPersonGroup:PersonGroupId groupName:PersonGroupName userData:nil completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //GetPersonGroup
    else if([methodName isEqualToString:@"GetPersonGroup"]) {
        [client getPersonGroupWithId:PersonGroupId completionHandler:^(MOFPersonGroup *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //UpdatePersonGroup
    else if([methodName isEqualToString:@"UpdatePersonGroup"]) {
        [client updatePersonGroupWithId:PersonGroupId groupName:PersonGroupName userData:UserData completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //CreatePerson
    else if([methodName isEqualToString:@"CreatePerson"]) {
        [client createPersonWithGroupId:PersonGroupId faceIds:[NSArray arrayWithObject:dadFaceId] name:PersonName userData:nil completionHandler:^(MOFCreatePersonResult *result, NSError *error) {
            if(result)
            {
                personId = result.PersonId;
            }
            NSLog(@"personId: %@", personId);
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //GetPerson
    else if([methodName isEqualToString:@"GetPerson"]) {
        [client getPersonWithGroupId:PersonGroupId personId:personId completionHandler:^(MOFPerson *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //UpdatePerson
    else if([methodName isEqualToString:@"UpdatePerson"]) {
        [client updatePersonwithGroupId:PersonGroupId personId:personId faceIds:[NSArray arrayWithObject:dadFaceId]  name:PersonName userData:UserData completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //AddPersonFace
    else if([methodName isEqualToString:@"AddPersonFace"]) {
        [client addPersonFaceWithGroupId:PersonGroupId personId:personId faceId:similarFaceId userData:nil completionHandler:^(NSError *error){
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //GetPersonFace
    else if([methodName isEqualToString:@"GetPersonFace"]) {
        [client getPersonFaceWithGroupId:PersonGroupId personId:personId faceId:similarFaceId completionHandler:^(MOFPersonFace *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //UpdatePersonFace
    else if([methodName isEqualToString:@"UpdatePersonFace"]) {
        [client updatePersonFaceWithGroupId:PersonGroupId personId:personId faceId:similarFaceId userData:UserData completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //TrainPersonGroup
    else if([methodName isEqualToString:@"TrainPersonGroup"]) {
        [client trainPersonGroupWithId:PersonGroupId completionHandler:^(MOFTrainingStatus *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //GetTrainPersonGroupStatus
    else if([methodName isEqualToString:@"GetTrainPersonGroupStatus"]) {
        [client getPersonGroupTrainingStatusWithId:PersonGroupId completionHandler:^(MOFTrainingStatus *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //Identify
    else if([methodName isEqualToString:@"Identify"]) {
        [client identifyFacesInGroup:PersonGroupId faceIds:familyFaceIds completionHandler:^(NSArray<MOFIdentifyResult> *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //DeletePersonFace
    else if([methodName isEqualToString:@"DeletePersonFace"]) {
        [client deletePersonFaceWithGroupId:PersonGroupId personId:personId faceId:similarFaceId completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //DeletePerson
    else if([methodName isEqualToString:@"DeletePerson"]) {
        [client deletePersonWithGroupId:PersonGroupId personId:personId completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //GetPersons
    else if([methodName isEqualToString:@"GetPersons"]) {
        [client getPersonsWithGroupId:PersonGroupId completionHandler:^(NSArray<MOFPerson> *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //DeletePersonGroup
    else if([methodName isEqualToString:@"DeletePersonGroup"]) {
        [client deletePersonGroupWithId:PersonGroupId completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //GetPersonGroups
    else if([methodName isEqualToString:@"GetPersonGroups"]) {
        [client getPersonGroups:^(NSArray<MOFPersonGroup> *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //CreateFaceGroup
    else if([methodName isEqualToString:@"CreateFaceGroup"]) {
        MOFPersonFace *face1 = [[MOFPersonFace alloc] initWithId:dadFaceId userData:@"face1"];
        MOFPersonFace *face2 = [[MOFPersonFace alloc] initWithId:similarFaceId userData:@"face2"];
        NSArray<MOFPersonFace> *faces = (NSArray<MOFPersonFace> *)[NSArray arrayWithObjects:face1,face2, nil];
        
        [client createFaceGroupWithGroupId:FaceGroupId groupName:FaceGroupName faces:faces userData:nil completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //GetFaceGroup
    else if([methodName isEqualToString:@"GetFaceGroup"]) {
        [client getFaceGroupWithId:FaceGroupId completionHandler:^(MOFFaceGroup *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
    //UpdateFaceGroup
    else if([methodName isEqualToString:@"UpdateFaceGroup"]) {
        [client updateFaceGroupWithId:FaceGroupId groupName:FaceGroupName userData:UserData completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //AddFaces
    else if([methodName isEqualToString:@"AddFaces"]) {
        //need a new face
        MOFPersonFace *face3 = [[MOFPersonFace alloc] initWithId:similarFaceId userData:@"face3"];
        NSArray<MOFPersonFace> *faces = (NSArray<MOFPersonFace> *)[NSArray arrayWithObjects:face3, nil];
        
        [client addFacesToFaceGroupWithId:FaceGroupId faces:faces completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //DeleteFaces
    else if([methodName isEqualToString:@"DeleteFaces"]) {
        NSArray *deleteFaceIds = [NSArray arrayWithObjects:similarFaceId, nil];
        [client deleteFacesFromFaceGroupWithId:FaceGroupId faceIds:deleteFaceIds completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //DeleteFaceGroup
    else if([methodName isEqualToString:@"DeleteFaceGroup"]) {
        [client deleteFaceGroupWithId:FaceGroupId completionHandler:^(NSError *error) {
            [weakSelf outputResult:nil error:error methodName:methodName];
        }];
    }
    //GetFaceGroups
    else if([methodName isEqualToString:@"GetFaceGroups"]) {
        [client getFaceGroups:^(NSArray<MOFFaceGroup> *result, NSError *error) {
            [weakSelf outputResult:result.description error:error methodName:methodName];
        }];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.APIMethods.count;
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *retval = (UILabel*)view;
    if (!retval) {
        retval = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        [retval setTextAlignment:NSTextAlignmentCenter];
    }
    
    retval.font = [UIFont systemFontOfSize:18];
    retval.text = self.APIMethods[row];
    
    return retval;
}

#pragma mark - Custom Methods

//Create the API Methods name array
-(void)prepareAPIMethods
{
    self.APIMethods = @[@"DetectFaces", @"DetectOneFace", @"Verify", @"FindSimilar", @"Group",
                        @"CreatePersonGroup", @"GetPersonGroup", @"UpdatePersonGroup", @"CreatePerson",@"GetPerson",
                        @"UpdatePerson", @"AddPersonFace", @"GetPersonFace", @"UpdatePersonFace", @"TrainPersonGroup",
                        @"GetTrainPersonGroupStatus", @"Identify", @"DeletePersonFace", @"DeletePerson", @"GetPersons",
                        @"DeletePersonGroup", @"GetPersonGroups", @"CreateFaceGroup", @"GetFaceGroup", @"UpdateFaceGroup",
                        @"AddFaces", @"DeleteFaces", @"DeleteFaceGroup", @"GetFaceGroups"];
}

-(void)outputResult:(NSString *)result error:(NSError *)error methodName:(NSString *)methodName
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ResultTextView insertText:[NSString stringWithFormat:@"End %@. \n", methodName]];
        if(result != nil)
        {
            [self.ResultTextView insertText:[NSString stringWithFormat:@"%@\n",result]];
        }
        
        if(error !=nil)
        {
            [self.ResultTextView insertText:[NSString stringWithFormat:@"%@\n",error]];
        }
    });
}

@end
