//
//  MOFFaceLandmark.h
//  ProjectOxfordFaceLib
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionalPropJSONModel.h"
#import "MOFFeatureCoordinate.h"

@interface MOFFaceLandmarks : OptionalPropJSONModel

/** The coordinate of left pupil. */
@property (nonatomic, strong) MOFFeatureCoordinate *PupilLeft;

/** The coordinate of right pupil. */
@property (nonatomic, strong) MOFFeatureCoordinate *PupilRight;

/** The coordinate of nose tip. */
@property (nonatomic, strong) MOFFeatureCoordinate *NoseTip;

/** The coordinate of mouth left. */
@property (nonatomic, strong) MOFFeatureCoordinate *MouthLeft;

/** The coordinate of mouth right. */
@property (nonatomic, strong) MOFFeatureCoordinate *MouthRight;

/** The coordinate of eyebrow left outer. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyebrowLeftOuter;

/** The coordinate of eyebrow left inner. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyebrowLeftInner;

/** The coordinate of eye left outer. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyeLeftOuter;

/** The coordinate of eye left top. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyeLeftTop;

/** The coordinate of eye left bottom. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyeLeftBottom;

/** The coordinate of eye left inner. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyeLeftInner;

/** The coordinate of eyebrow right outer. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyebrowRightOuter;

/** The coordinate of eyebrow right inner. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyebrowRightInner;

/** The coordinate of eye right outer. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyeRightOuter;

/** The coordinate of eye right top. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyeRightTop;

/** The coordinate of eye right bottom. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyeRightBottom;

/** The coordinate of eye right inner. */
@property (nonatomic, strong) MOFFeatureCoordinate *EyeRightInner;

/** The coordinate of nose root left. */
@property (nonatomic, strong) MOFFeatureCoordinate *NoseRootLeft;

/** The coordinate of nose root right. */
@property (nonatomic, strong) MOFFeatureCoordinate *NoseRootRight;

/** The coordinate of nose left alar top. */
@property (nonatomic, strong) MOFFeatureCoordinate *NoseLeftAlarTop;

/** The coordinate of nose right alar top. */
@property (nonatomic, strong) MOFFeatureCoordinate *NoseRightAlarTop;

/** The coordinate of nose left alar out tip. */
@property (nonatomic, strong) MOFFeatureCoordinate *NoseLeftAlarOutTip;

/** The coordinate of nose right alar out tip. */
@property (nonatomic, strong) MOFFeatureCoordinate *NoseRightAlarOutTip;

/** The coordinate of upper lip top. */
@property (nonatomic, strong) MOFFeatureCoordinate *UpperLipTop;

/** The coordinate of upper lip bottom. */
@property (nonatomic, strong) MOFFeatureCoordinate *UpperLipBottom;

/** The coordinate of under lip top. */
@property (nonatomic, strong) MOFFeatureCoordinate *UnderLipTop;

/** The coordinate of under lip bottom. */
@property (nonatomic, strong) MOFFeatureCoordinate *UnderLipBottom;

@end
