//
//  ADNRiposteActivity.m
//  ADNActivityCollection
//
//  Created by Brennan Stehling on 3/14/13.
//  Copyright (c) 2013 SmallSharptools LLC. All rights reserved.
//

#import "ADNRiposteActivity.h"

// Riposte docs for URL Scheme
// http://riposteapp.net/release-notes.html
// riposte://x-callback-url/createNewPost?text=blahblahblah&accountID=5952

@implementation ADNRiposteActivity

#pragma mark - Public Implementation
#pragma mark -

- (NSString *)clientURLScheme {
    return @"riposte://";
}

#pragma mark - UIActivity Override Methods
#pragma mark -

- (NSString *)activityTitle {
    return @"Riposte";
}

- (UIImage *)activityImage {
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(43, 43), NO, 0.0f);
        
        
        //// Logo Drawing
        UIBezierPath* logoPath = [UIBezierPath bezierPath];
        [logoPath moveToPoint: CGPointMake(23, 14)];
        [logoPath addLineToPoint: CGPointMake(20, 14)];
        [logoPath addLineToPoint: CGPointMake(19, 17)];
        [logoPath addLineToPoint: CGPointMake(19, 20)];
        [logoPath addLineToPoint: CGPointMake(23, 20)];
        [logoPath addCurveToPoint: CGPointMake(25, 17) controlPoint1: CGPointMake(23, 20) controlPoint2: CGPointMake(25, 17.98)];
        [logoPath addCurveToPoint: CGPointMake(23, 14) controlPoint1: CGPointMake(25, 16.02) controlPoint2: CGPointMake(23, 14)];
        [logoPath closePath];
        [logoPath moveToPoint: CGPointMake(33, 8)];
        [logoPath addCurveToPoint: CGPointMake(39, 18) controlPoint1: CGPointMake(36.2, 11.14) controlPoint2: CGPointMake(38.31, 14.56)];
        [logoPath addCurveToPoint: CGPointMake(39, 25) controlPoint1: CGPointMake(39.29, 19.43) controlPoint2: CGPointMake(39.42, 22.88)];
        [logoPath addCurveToPoint: CGPointMake(37, 31) controlPoint1: CGPointMake(38.41, 27.99) controlPoint2: CGPointMake(37, 31)];
        [logoPath addCurveToPoint: CGPointMake(31, 33) controlPoint1: CGPointMake(37, 31) controlPoint2: CGPointMake(33.89, 33.07)];
        [logoPath addCurveToPoint: CGPointMake(25, 32) controlPoint1: CGPointMake(30.18, 32.98) controlPoint2: CGPointMake(26.1, 33.04)];
        [logoPath addCurveToPoint: CGPointMake(20.5, 24.5) controlPoint1: CGPointMake(22.23, 29.37) controlPoint2: CGPointMake(20.5, 24.5)];
        [logoPath addLineToPoint: CGPointMake(17.5, 24.5)];
        [logoPath addLineToPoint: CGPointMake(14.5, 32.5)];
        [logoPath addLineToPoint: CGPointMake(11.5, 28.5)];
        [logoPath addLineToPoint: CGPointMake(15, 12)];
        [logoPath addCurveToPoint: CGPointMake(21, 10) controlPoint1: CGPointMake(15, 12) controlPoint2: CGPointMake(18, 10)];
        [logoPath addCurveToPoint: CGPointMake(29, 16) controlPoint1: CGPointMake(24, 10) controlPoint2: CGPointMake(28.16, 10.94)];
        [logoPath addCurveToPoint: CGPointMake(25, 22) controlPoint1: CGPointMake(29.84, 21.06) controlPoint2: CGPointMake(25, 22)];
        [logoPath addCurveToPoint: CGPointMake(27, 27) controlPoint1: CGPointMake(25, 22) controlPoint2: CGPointMake(25.64, 25.08)];
        [logoPath addCurveToPoint: CGPointMake(31, 29) controlPoint1: CGPointMake(28.08, 28.53) controlPoint2: CGPointMake(29.73, 29)];
        [logoPath addCurveToPoint: CGPointMake(35.5, 22.5) controlPoint1: CGPointMake(33.87, 29) controlPoint2: CGPointMake(34.84, 25.87)];
        [logoPath addCurveToPoint: CGPointMake(32.5, 13.5) controlPoint1: CGPointMake(36.16, 19.13) controlPoint2: CGPointMake(34.74, 16.82)];
        [logoPath addCurveToPoint: CGPointMake(20.5, 7.5) controlPoint1: CGPointMake(30.26, 10.18) controlPoint2: CGPointMake(26.3, 7.5)];
        [logoPath addCurveToPoint: CGPointMake(11, 12) controlPoint1: CGPointMake(14.7, 7.5) controlPoint2: CGPointMake(13.51, 9.94)];
        [logoPath addCurveToPoint: CGPointMake(7, 22) controlPoint1: CGPointMake(8.49, 14.06) controlPoint2: CGPointMake(6.94, 18.99)];
        [logoPath addCurveToPoint: CGPointMake(11.5, 32.5) controlPoint1: CGPointMake(7.06, 25.01) controlPoint2: CGPointMake(7.36, 28.76)];
        [logoPath addCurveToPoint: CGPointMake(20.5, 36.5) controlPoint1: CGPointMake(15.64, 36.24) controlPoint2: CGPointMake(17.5, 36.5)];
        [logoPath addCurveToPoint: CGPointMake(33.5, 35.5) controlPoint1: CGPointMake(23.5, 36.5) controlPoint2: CGPointMake(33.5, 35.5)];
        [logoPath addCurveToPoint: CGPointMake(21.5, 40.5) controlPoint1: CGPointMake(33.5, 35.5) controlPoint2: CGPointMake(26.34, 40.62)];
        [logoPath addCurveToPoint: CGPointMake(8.5, 35.5) controlPoint1: CGPointMake(16.66, 40.38) controlPoint2: CGPointMake(11.22, 37.89)];
        [logoPath addCurveToPoint: CGPointMake(2.5, 21.5) controlPoint1: CGPointMake(5.78, 33.11) controlPoint2: CGPointMake(2.42, 26.36)];
        [logoPath addCurveToPoint: CGPointMake(7.5, 8.5) controlPoint1: CGPointMake(2.58, 16.64) controlPoint2: CGPointMake(4.93, 11.75)];
        [logoPath addCurveToPoint: CGPointMake(20.5, 3.5) controlPoint1: CGPointMake(10.07, 5.25) controlPoint2: CGPointMake(15.42, 3.5)];
        [logoPath addCurveToPoint: CGPointMake(33, 8) controlPoint1: CGPointMake(25.58, 3.5) controlPoint2: CGPointMake(29.8, 4.86)];
        [logoPath closePath];
        [[UIColor whiteColor] setFill];
        [logoPath fill];
        
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return image;
}

- (NSURL *)clientOpenURL {
    if (self.clientURLScheme != nil) {
        // Note: Adding another slash fixes the sharing option with Netbot
        // https://alpha.app.net/edmundtay/post/3828992
        NSString *urlString = [NSString stringWithFormat:@"%@x-callback-url/createNewPost?text=%@", self.clientURLScheme, self.encodedText];
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
