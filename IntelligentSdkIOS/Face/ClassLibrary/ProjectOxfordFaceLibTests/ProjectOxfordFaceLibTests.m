//
//  ProjectOxfordFaceLibTests.m
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MOFFaceServiceClient.h"

@interface ProjectOxfordFaceLibTests : XCTestCase

@end

@implementation ProjectOxfordFaceLibTests
{
    MOFFaceServiceClient *client;
    NSString *imgUrl;
    NSData *imgData;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    client = [[MOFFaceServiceClient alloc] initWithSubscriptionKey:@"8794b66c2dfa4b5eb9d8c5343067921a"];
    imgUrl = @"https://oxfordportal.blob.core.windows.net/face/demo/detection%203.jpg";
    NSString* imgPath = [[NSBundle bundleForClass:[MOFFaceServiceClient class]].resourcePath stringByAppendingPathComponent:@"detection3.jpg"];
    imgData = UIImageJPEGRepresentation([UIImage imageNamed:imgPath], 1.0);
}

- (void)tearDown {
    client = nil;
    imgUrl = nil;
    imgData = nil;
    [super tearDown];
}

- (void)testDetectFacesFromImageUrl {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Ready"];
    
    [client detectFacesFromImageUrl:imgUrl analyzesFacelandmarks:true analyzesAge:true analyzesGender:true analyzesHeadPose:true completionHandler:^(NSArray<MOFFace> *result, NSError *error) {
        XCTAssertNil(error, @"detect faces from url failed.");
        XCTAssertEqual(result.count, 2, @"detect faces from url result error.");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)testDetectFacesWithImageData{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Ready"];
    
    [client detectFacesWithImageData:imgData analyzesFacelandmarks:true analyzesAge:true analyzesGender:true analyzesHeadPose:true completionHandler:^(NSArray<MOFFace> *result, NSError *error) {
        XCTAssertNil(error, @"detect faces from url failed.");
        XCTAssertEqual(result.count, 2, @"detect faces from url result error.");

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

@end
