//
//  ADNNetbotActivity.m
//  ADNActivityCollection
//
//  Created by Brennan Stehling on 3/2/13.
//  Copyright (c) 2013 SmallSharptools LLC. All rights reserved.
//

#import "ADNNetbotActivity.h"

// User docs for Tweetbot URL Scheme
// http://tapbots.com/blog/development/tweetbot-url-scheme
// netbot:///post?text=abc

@implementation ADNNetbotActivity

#pragma mark - Public Implementation
#pragma mark -

- (NSString *)clientURLScheme {
    return @"netbot://";
}

#pragma mark - UIActivity Override Methods
#pragma mark -

- (NSString *)activityTitle {
    return @"Netbot";
}

- (UIImage *)activityImage {
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(43, 43), NO, 0.0f);
        
        
        //// Color Declarations
        UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        
        //// Face Drawing
        UIBezierPath* facePath = [UIBezierPath bezierPath];
        [facePath moveToPoint: CGPointMake(23.5, 4)];
        [facePath addLineToPoint: CGPointMake(19.5, 4)];
        [facePath addCurveToPoint: CGPointMake(19, 4.5) controlPoint1: CGPointMake(19.22, 4) controlPoint2: CGPointMake(19, 4.22)];
        [facePath addCurveToPoint: CGPointMake(19.5, 5) controlPoint1: CGPointMake(19, 4.78) controlPoint2: CGPointMake(19.22, 5)];
        [facePath addLineToPoint: CGPointMake(23.5, 5)];
        [facePath addCurveToPoint: CGPointMake(24, 4.5) controlPoint1: CGPointMake(23.78, 5) controlPoint2: CGPointMake(24, 4.78)];
        [facePath addCurveToPoint: CGPointMake(23.5, 4) controlPoint1: CGPointMake(24, 4.22) controlPoint2: CGPointMake(23.78, 4)];
        [facePath closePath];
        [facePath moveToPoint: CGPointMake(26.5, 7.5)];
        [facePath addLineToPoint: CGPointMake(14.5, 7.5)];
        [facePath addLineToPoint: CGPointMake(10.5, 11.5)];
        [facePath addLineToPoint: CGPointMake(10.5, 24.5)];
        [facePath addLineToPoint: CGPointMake(14.5, 28.5)];
        [facePath addLineToPoint: CGPointMake(27.5, 28.5)];
        [facePath addLineToPoint: CGPointMake(32.5, 24.5)];
        [facePath addLineToPoint: CGPointMake(32.5, 11.5)];
        [facePath addLineToPoint: CGPointMake(26.5, 7.5)];
        [facePath closePath];
        [facePath moveToPoint: CGPointMake(22.5, 32.5)];
        [facePath addLineToPoint: CGPointMake(20.5, 32.5)];
        [facePath addLineToPoint: CGPointMake(18.5, 34.5)];
        [facePath addLineToPoint: CGPointMake(18.5, 36.5)];
        [facePath addLineToPoint: CGPointMake(20.5, 38.5)];
        [facePath addLineToPoint: CGPointMake(22.5, 38.5)];
        [facePath addLineToPoint: CGPointMake(24.5, 36.5)];
        [facePath addLineToPoint: CGPointMake(24.5, 34.5)];
        [facePath addLineToPoint: CGPointMake(22.5, 32.5)];
        [facePath closePath];
        [facePath moveToPoint: CGPointMake(15.77, 2.5)];
        [facePath addLineToPoint: CGPointMake(27.21, 2.5)];
        [facePath addCurveToPoint: CGPointMake(32, 5) controlPoint1: CGPointMake(27.21, 2.5) controlPoint2: CGPointMake(29.96, 3.2)];
        [facePath addCurveToPoint: CGPointMake(35.5, 9.87) controlPoint1: CGPointMake(34.04, 6.8) controlPoint2: CGPointMake(35.5, 9.87)];
        [facePath addLineToPoint: CGPointMake(35.5, 33.08)];
        [facePath addCurveToPoint: CGPointMake(32, 38) controlPoint1: CGPointMake(35.5, 33.08) controlPoint2: CGPointMake(34.69, 35.71)];
        [facePath addCurveToPoint: CGPointMake(27.25, 40.5) controlPoint1: CGPointMake(29.31, 40.29) controlPoint2: CGPointMake(27.25, 40.5)];
        [facePath addLineToPoint: CGPointMake(14.82, 40.5)];
        [facePath addCurveToPoint: CGPointMake(10.12, 37.87) controlPoint1: CGPointMake(14.82, 40.5) controlPoint2: CGPointMake(13.34, 40.8)];
        [facePath addCurveToPoint: CGPointMake(7.5, 32.08) controlPoint1: CGPointMake(6.91, 34.94) controlPoint2: CGPointMake(7.5, 32.08)];
        [facePath addLineToPoint: CGPointMake(7.5, 11.03)];
        [facePath addCurveToPoint: CGPointMake(10, 5) controlPoint1: CGPointMake(7.5, 11.03) controlPoint2: CGPointMake(6.93, 7.64)];
        [facePath addCurveToPoint: CGPointMake(15.77, 2.5) controlPoint1: CGPointMake(12.83, 2.56) controlPoint2: CGPointMake(15.39, 2.49)];
        [facePath closePath];
        [fillColor setFill];
        [facePath fill];
        
        
        //// Left Eye Drawing
        UIBezierPath* leftEyePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(15, 13, 4, 7) cornerRadius: 2];
        [fillColor setFill];
        [leftEyePath fill];
        
        
        //// Right Eye Drawing
        UIBezierPath* rightEyePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(24, 13, 4, 7) cornerRadius: 2];
        [fillColor setFill];
        [rightEyePath fill];
        
        
        //// Mouth Drawing
        UIBezierPath* mouthPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(19.5, 33.5, 4, 4)];
        [fillColor setFill];
        [mouthPath fill];
        
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return image;
}


- (NSURL *)clientOpenURL {
    if (self.clientURLScheme != nil) {
        // Note: Adding another slash fixes the sharing option with Netbot
        // https://alpha.app.net/edmundtay/post/3828992
        NSString *urlString = [NSString stringWithFormat:@"%@/post?text=%@", self.clientURLScheme, self.encodedText];
        NSString *appURLScheme = [self appURLScheme];
        if (appURLScheme != nil) {
            urlString = [NSString stringWithFormat:@"%@&returnURLScheme=%@", urlString, [self encodeText:appURLScheme]];
        }
#ifndef NDEBUG
        NSLog(@"clientOpenURL: %@", urlString);
#endif
        NSURL *openURL = [NSURL URLWithString:urlString];
        return openURL;
    }
    
    return nil;
}

@end
