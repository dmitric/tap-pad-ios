//
//  ADNHappyActivity.m
//  ADNActivityCollection
//
//  Created by Brennan Stehling on 5/12/13.
//  Copyright (c) 2013 SmallSharptools LLC. All rights reserved.
//

#import "ADNHappyActivity.h"

@implementation ADNHappyActivity

// hAppy Docs for URL Scheme
// http://dasdom.de/Dominik_Hauser_Development/hAppy_url_schemes.html
// happy://create?text=<url-encoded text>

#pragma mark - Public Implementation
#pragma mark -

- (NSString *)clientURLScheme {
    return @"happy://";
}

#pragma mark - UIActivity Override Methods
#pragma mark -

- (NSString *)activityTitle {
    return @"hAppy";
}

- (UIImage *)activityImage {
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(43, 43), NO, 0.0f);
        
        
        //// Smile Drawing
        UIBezierPath* smilePath = [UIBezierPath bezierPath];
        [smilePath moveToPoint: CGPointMake(5, 22)];
        [smilePath addCurveToPoint: CGPointMake(20.5, 29.5) controlPoint1: CGPointMake(5, 22) controlPoint2: CGPointMake(13.82, 29.5)];
        [smilePath addCurveToPoint: CGPointMake(38, 22) controlPoint1: CGPointMake(27.18, 29.5) controlPoint2: CGPointMake(38, 22)];
        [smilePath addCurveToPoint: CGPointMake(20.5, 33.5) controlPoint1: CGPointMake(38, 22) controlPoint2: CGPointMake(32.15, 33.5)];
        [smilePath addCurveToPoint: CGPointMake(5, 22) controlPoint1: CGPointMake(8.85, 33.5) controlPoint2: CGPointMake(5, 22)];
        [smilePath closePath];
        [[UIColor whiteColor] setFill];
        [smilePath fill];
        
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return image;
}

- (NSURL *)clientOpenURL {
    if (self.clientURLScheme != nil) {
        NSString *urlString = nil;
        
        // Note: URL parsing in hAppy seems to be insufficient for supporting additional parameters, like the return URL scheme
        // Once that is fixed the extra parameter can be added with the code below which is commented out.
//        NSString *appURLScheme = [self appURLScheme];
//        if (appURLScheme != nil) {
//            urlString = [NSString stringWithFormat:@"%@create?returnURLScheme=%@&text=%@", self.clientURLScheme, [self encodeText:appURLScheme], self.encodedText];
//        }
//        else {
            urlString = [NSString stringWithFormat:@"%@create?text=%@", self.clientURLScheme, self.encodedText];
//        }
#ifndef NDEBUG
        NSLog(@"clientOpenURL: %@", urlString);
        NSLog(@"  Example URL: happy://create?text=<url-encoded text>");
#endif
        NSURL *openURL = [NSURL URLWithString:urlString];
        return openURL;
    }
    
    return nil;
}

@end
