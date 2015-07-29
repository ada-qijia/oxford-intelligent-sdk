
//
//  Rectangle.m
//  projectoxford.vision
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle

+(instancetype)FromString:(NSString *)str
{
    if(str.length>0)
    {
        NSArray *box = [str componentsSeparatedByString:@","];
        int left, top, width, height;
        
        if(box.count == 4)
        {
            if([self scanIntValue:box[0] output: &left] &&
               [self scanIntValue:box[1] output: &top] &&
               [self scanIntValue:box[2] output: &width] &&
               [self scanIntValue:box[3] output: &height])
            {
                Rectangle *rect = [super init];
                if(rect)
                {
                    rect.Left = left;
                    rect.Top = top;
                    rect.Width = width;
                    rect.Height = height;
                }
                return rect;
            }
        }
    }
    
    return nil;
}

+ (BOOL)scanIntValue:(NSString *) inputStr output:(int *) intValue
{
    NSScanner* scan = [NSScanner scannerWithString:inputStr];
    if([scan scanInt:intValue] && [scan isAtEnd])
    {
        return true;
    }
    return false;
}

@end
