//
//  ADNActivity.m
//  ADNActivityCollection
//
//  Created by Brennan Stehling on 3/2/13.
//  Copyright (c) 2013 SmallSharptools LLC. All rights reserved.
//

#import "ADNActivity.h"

@implementation ADNActivity

#pragma mark - Public Implementation
#pragma mark -

- (NSString *)encodedText {
    return [self encodeText:self.text];
}

- (NSString *)clientURLScheme {
    // override with Client URL Scheme
    return nil;
}

- (BOOL)isClientInstalled {
#if TARGET_IPHONE_SIMULATOR
    // provide an option for testing in the simulator where third party apps will not be installed
    return TRUE;
#else
    if (self.clientURLScheme != nil) {
        NSURL *url = [NSURL URLWithString:self.clientURLScheme];
        return [[UIApplication sharedApplication] canOpenURL:url];
    }
    
    return FALSE;
#endif
}

- (NSURL *)clientOpenURL {
    // reference only for implementing class
    if (self.clientURLScheme != nil) {
        NSString *urlString = [NSString stringWithFormat:@"%@/?post=%@", self.clientURLScheme, self.encodedText];
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

- (NSString *)appURLScheme {
    NSArray *urlTypes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    if (urlTypes.count > 0) {
        NSDictionary *urlType = [urlTypes objectAtIndex:0];
        NSArray *urlSchemes = [urlType objectForKey:@"CFBundleURLSchemes"];
        if (urlSchemes.count > 0) {
            NSString *urlScheme = [urlSchemes objectAtIndex:0];
            NSLog(@"URL Scheme: %@", urlScheme);
            return [NSString stringWithFormat:@"%@://", urlScheme];
        }
    }
    
    return nil;
}

- (NSString *)encodeText:(NSString *)text {
    if (text == nil) {
        return nil;
    }
    
    CFStringRef ref = CFURLCreateStringByAddingPercentEscapes( NULL,
                                                              (CFStringRef)text,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8 );
    
    NSString *encoded = [NSString stringWithString: (__bridge NSString *)ref];
    
    CFRelease( ref );
    
    return encoded;
}

#pragma mark - UIActivity Override Methods
#pragma mark -

- (NSString *)activityType {
    return [NSString stringWithFormat:@"UIActivityTypePostTo%@", [self activityTitle]];
}

- (NSString *)activityTitle {
    return @"ADN";
}

- (UIImage *)activityImage {
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(43, 43), NO, 0.0f);
        
        
        //// Color Declarations
        UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(33.75, 29.5)];
        [bezierPath addCurveToPoint: CGPointMake(31.07, 30.53) controlPoint1: CGPointMake(32.72, 29.5) controlPoint2: CGPointMake(31.81, 29.92)];
        [bezierPath addLineToPoint: CGPointMake(24.59, 25.9)];
        [bezierPath addCurveToPoint: CGPointMake(25.25, 23.12) controlPoint1: CGPointMake(25, 25.05) controlPoint2: CGPointMake(25.25, 24.12)];
        [bezierPath addCurveToPoint: CGPointMake(24.06, 19.44) controlPoint1: CGPointMake(25.25, 21.75) controlPoint2: CGPointMake(24.8, 20.48)];
        [bezierPath addLineToPoint: CGPointMake(31.64, 11.86)];
        [bezierPath addCurveToPoint: CGPointMake(33.75, 12.5) controlPoint1: CGPointMake(32.27, 12.23) controlPoint2: CGPointMake(32.97, 12.5)];
        [bezierPath addCurveToPoint: CGPointMake(38, 8.25) controlPoint1: CGPointMake(36.1, 12.5) controlPoint2: CGPointMake(38, 10.6)];
        [bezierPath addCurveToPoint: CGPointMake(33.75, 4) controlPoint1: CGPointMake(38, 5.9) controlPoint2: CGPointMake(36.1, 4)];
        [bezierPath addCurveToPoint: CGPointMake(29.5, 8.25) controlPoint1: CGPointMake(31.4, 4) controlPoint2: CGPointMake(29.5, 5.9)];
        [bezierPath addCurveToPoint: CGPointMake(30.14, 10.36) controlPoint1: CGPointMake(29.5, 9.03) controlPoint2: CGPointMake(29.77, 9.73)];
        [bezierPath addLineToPoint: CGPointMake(22.56, 17.94)];
        [bezierPath addCurveToPoint: CGPointMake(18.88, 16.75) controlPoint1: CGPointMake(21.51, 17.19) controlPoint2: CGPointMake(20.25, 16.75)];
        [bezierPath addCurveToPoint: CGPointMake(13.28, 20.14) controlPoint1: CGPointMake(16.44, 16.75) controlPoint2: CGPointMake(14.35, 18.13)];
        [bezierPath addLineToPoint: CGPointMake(8.16, 18.43)];
        [bezierPath addCurveToPoint: CGPointMake(6.12, 16.75) controlPoint1: CGPointMake(7.95, 17.48) controlPoint2: CGPointMake(7.14, 16.75)];
        [bezierPath addCurveToPoint: CGPointMake(4, 18.88) controlPoint1: CGPointMake(4.95, 16.75) controlPoint2: CGPointMake(4, 17.7)];
        [bezierPath addCurveToPoint: CGPointMake(6.12, 21) controlPoint1: CGPointMake(4, 20.05) controlPoint2: CGPointMake(4.95, 21)];
        [bezierPath addCurveToPoint: CGPointMake(7.51, 20.46) controlPoint1: CGPointMake(6.66, 21) controlPoint2: CGPointMake(7.14, 20.78)];
        [bezierPath addLineToPoint: CGPointMake(12.6, 22.15)];
        [bezierPath addCurveToPoint: CGPointMake(12.5, 23.12) controlPoint1: CGPointMake(12.55, 22.47) controlPoint2: CGPointMake(12.5, 22.79)];
        [bezierPath addCurveToPoint: CGPointMake(18.88, 29.5) controlPoint1: CGPointMake(12.5, 26.64) controlPoint2: CGPointMake(15.36, 29.5)];
        [bezierPath addCurveToPoint: CGPointMake(23.37, 27.64) controlPoint1: CGPointMake(20.63, 29.5) controlPoint2: CGPointMake(22.22, 28.79)];
        [bezierPath addLineToPoint: CGPointMake(29.8, 32.24)];
        [bezierPath addCurveToPoint: CGPointMake(29.5, 33.75) controlPoint1: CGPointMake(29.62, 32.71) controlPoint2: CGPointMake(29.5, 33.21)];
        [bezierPath addCurveToPoint: CGPointMake(33.75, 38) controlPoint1: CGPointMake(29.5, 36.09) controlPoint2: CGPointMake(31.4, 38)];
        [bezierPath addCurveToPoint: CGPointMake(38, 33.75) controlPoint1: CGPointMake(36.1, 38) controlPoint2: CGPointMake(38, 36.09)];
        [bezierPath addCurveToPoint: CGPointMake(33.75, 29.5) controlPoint1: CGPointMake(38, 31.41) controlPoint2: CGPointMake(36.1, 29.5)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor setFill];
        [bezierPath fill];
        
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return image;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    if (![self isClientInstalled]) {
        return NO;
    }
    
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSString class]] || [activityItem isKindOfClass:[NSURL class]])  {
            return YES;
        }
    }
    
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    NSString *content = nil;
    NSString *link = nil;
    
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSString class]]) {
            NSString *text = activityItem;
            if ([text hasPrefix:@"http://"] || [text hasPrefix:@"https://"]) {
                link = text;
            }
            else {
                content = text;
            }
        }
        else if ([activityItem isKindOfClass:[NSURL class]]) {
            NSURL *url = activityItem;
            link = [url absoluteString];
        }
    }
    
    if (content != nil && link != nil) {
        self.text = [NSString stringWithFormat:@"%@ %@", content, link];
    }
    else if (content != nil && link == nil) {
        self.text = content;
    }
    else if (content == nil && link != nil) {
        self.text = link;
    }
    else {
        // a default just in case but should never be reached
        NSAssert(FALSE, @"This option should never be reached since canPerformWithActivityItems should return FALSE for this condition.");
        self.text = @"POST!";
    }
}

- (UIViewController *)activityViewController {
    return nil;
}

- (void)performActivity {
#ifndef NDEBUG
    NSLog(@"Sharing: %@", self.encodedText);
#endif

#if TARGET_IPHONE_SIMULATOR
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"iPhone Simulator"
                                                    message: @"Sharing does not function in the iPhone Simulator."
                                                   delegate: nil
                                          cancelButtonTitle: NSLocalizedString( @"OK", @"" )
                                          otherButtonTitles: nil];
    
    [alert show];
    [self activityDidFinish:TRUE];
#else
    [self activityDidFinish:TRUE];
    [[UIApplication sharedApplication] openURL:self.clientOpenURL];
#endif
}

@end
