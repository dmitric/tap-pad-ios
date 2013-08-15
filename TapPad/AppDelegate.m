//
//  AppDelegate.m
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#import "AppDelegate.h"

#import "TapPadViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[TapPadViewController alloc]
                           initWithNibName:@"TapPadViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self handleOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self handleOpenUrl:url];
    return YES;
}

-(void)handleOpenUrl:(NSURL *)url
{
    NSString *action = [url.host lowercaseString];
    if (action) {
        if ([action isEqualToString:@"grid"]
            && url.pathComponents.count > 1) {
            NSString *code = url.pathComponents[1];
            [self.viewController loadSound:code];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.viewController pause];
}

@end
