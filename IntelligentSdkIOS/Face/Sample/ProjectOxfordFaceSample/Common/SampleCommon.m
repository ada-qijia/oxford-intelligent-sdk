//
//  SampleCommon.m
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "SampleCommon.h"

@implementation SampleCommon

+(void)AddFaceRectsToImageView:(UIImageView *)imageView faces:(NSArray *)faces{
    for (MOFFace *face in faces) {
        if([face isKindOfClass:[MOFFace class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect faceRect = [self getAspectTargetRect:imageView.image.size targetSize:imageView.frame.size realRect:CGRectMake(face.FaceRectangle.Left, face.FaceRectangle.Top, face.FaceRectangle.Width, face.FaceRectangle.Height)];
                
                CALayer *faceLayer = [CALayer layer];
                faceLayer.frame = faceRect;
                faceLayer.borderWidth = 3;
                faceLayer.borderColor = [[UIColor blueColor] CGColor];
                [imageView.layer addSublayer:faceLayer];
            });
        }
    }
}

+(void)RemoveAllFaceRectsInImageView:(UIImageView *)imageView{
    dispatch_async(dispatch_get_main_queue(), ^{
        imageView.layer.sublayers = nil;
    });
}

+(CGRect)getAspectTargetRect:(CGSize)realSize targetSize:(CGSize)targetSize realRect:(CGRect)realRect
{
    CGFloat ratio = MAX(realSize.height/targetSize.height, realSize.width/targetSize.width);
    CGSize targetRectSize = CGSizeMake(realRect.size.width/ratio, realRect.size.height/ratio);
    CGFloat top = (targetSize.height - realSize.height/ratio)/2 + realRect.origin.y/ratio;
    CGFloat left = (targetSize.width - realSize.width/ratio)/2 + realRect.origin.x/ratio;
    return CGRectMake(left, top, targetRectSize.width, targetRectSize.height);
}

@end
