//
//  ADNFelixActivity.m
//  ADNActivityCollection
//
//  Created by Brennan Stehling on 3/2/13.
//  Copyright (c) 2013 SmallSharptools LLC. All rights reserved.
//

#import "ADNFelixActivity.h"

// http://tigerbears.com/felix/urls.html
// felix://
// felix://compose/post?text=[text] ("text" is optional, but is expected to be URL-encoded.)

@implementation ADNFelixActivity

#pragma mark - Public Implementation
#pragma mark -

- (NSString *)clientURLScheme {
    return @"felix://";
}

#pragma mark - UIActivity Override Methods
#pragma mark -

- (NSString *)activityTitle {
    return @"Felix";
}

- (UIImage *)activityImage {
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(43, 43), NO, 0.0f);
        
        
        //// Color Declarations
        UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        
        //// Alpha Drawing
        UIBezierPath* alphaPath = [UIBezierPath bezierPath];
        [alphaPath moveToPoint: CGPointMake(39.5, 14)];
        [alphaPath addCurveToPoint: CGPointMake(34, 13) controlPoint1: CGPointMake(39.5, 14) controlPoint2: CGPointMake(37.8, 13.04)];
        [alphaPath addCurveToPoint: CGPointMake(22.5, 22.5) controlPoint1: CGPointMake(30.2, 12.96) controlPoint2: CGPointMake(22.5, 22.5)];
        [alphaPath addCurveToPoint: CGPointMake(12.5, 30.5) controlPoint1: CGPointMake(22.5, 22.5) controlPoint2: CGPointMake(18.6, 30.25)];
        [alphaPath addCurveToPoint: CGPointMake(4, 21) controlPoint1: CGPointMake(6.4, 30.75) controlPoint2: CGPointMake(4, 26.5)];
        [alphaPath addCurveToPoint: CGPointMake(12, 13) controlPoint1: CGPointMake(4, 15.5) controlPoint2: CGPointMake(6.85, 12.91)];
        [alphaPath addCurveToPoint: CGPointMake(22.5, 19.5) controlPoint1: CGPointMake(17.15, 13.09) controlPoint2: CGPointMake(22.5, 19.5)];
        [alphaPath addCurveToPoint: CGPointMake(34, 31) controlPoint1: CGPointMake(22.5, 19.5) controlPoint2: CGPointMake(30.09, 31)];
        [alphaPath addCurveToPoint: CGPointMake(39.5, 30.5) controlPoint1: CGPointMake(37.91, 31) controlPoint2: CGPointMake(39.5, 30.5)];
        [fillColor setStroke];
        alphaPath.lineWidth = 2.5;
        [alphaPath stroke];
        
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return image;
}

- (NSURL *)clientOpenURL {
    if (self.clientURLScheme != nil) {
        NSString *urlString = [NSString stringWithFormat:@"%@compose/post?text=%@", self.clientURLScheme, self.encodedText];
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
