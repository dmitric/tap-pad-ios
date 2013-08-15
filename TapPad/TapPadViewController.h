//
//  ViewController.h
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapPadViewController : UIViewController

-(void) loadSound:(NSString *)soundCode;

-(void) pause;

-(void) play;

@end
