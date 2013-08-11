//
//  ViewController.m
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#define gridDimension 8

#import "TapPadViewController.h"
#import "Grid.h"

@interface TapPadViewController ()

@property (nonatomic, strong) NSMutableArray *atoms;
@property (nonatomic, strong) Grid *grid;

@end

@implementation TapPadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.atoms = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
