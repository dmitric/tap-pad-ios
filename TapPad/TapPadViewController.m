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
#import "Atom.h"

@interface TapPadViewController ()



@property (nonatomic, strong) NSMutableArray *atoms;
@property (nonatomic, strong) Grid *grid;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *buttonsGrid;

@end

@implementation TapPadViewController

static NSInteger seed = 0;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.grid = [[Grid alloc] initWithDimension:gridDimension];
    self.buttonsGrid = [[NSMutableArray alloc] initWithCapacity:gridDimension];
    CGFloat borderRatio = 158./256.;
    CGFloat bgRatio = 245./256.;
    for (int j = 0; j < gridDimension; j++) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:gridDimension];
        for (int i = 0; i < gridDimension; i++){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(28+(1+88)*i, 124+(1+88)*j, 88, 88)];
            [button setBackgroundColor:[UIColor colorWithRed:bgRatio green:bgRatio blue:bgRatio alpha:1]];
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = [UIColor colorWithRed:borderRatio green:borderRatio blue:borderRatio alpha:1].CGColor;
            arr[i] = button;
            [self.view addSubview:button];
        }
        [self.buttonsGrid addObject:arr];
    } 
    [self.playControlButton setTitle:@"PAUSE" forState:UIControlStateSelected];
    self.atoms = [[NSMutableArray alloc] initWithCapacity:10];
    self.timer = [[NSTimer alloc] init];
}

-(BOOL)isValidMove:(NSInteger) x and:(NSInteger) y{
    return !(x > gridDimension-1 || x < 0
             || y > gridDimension-1 || y < 0);
}

-(void)addAtomWithX:(NSInteger)x andY:(NSInteger)y {
    if (![self isValidMove:x and:y]){
        NSLog(@"Can't add, outside of bounds");
    }else{
        Atom *a = [[Atom alloc] init];
        a.x = x;
        a.y = y;
        a.direction = 1;
        a.vertical = YES;
        a.identifier = seed++;
        [self.grid addObjectWithId:[@(a.identifier) description]
                             toRow:a.x andColumn:a.y];
        [self renderAtX:x andY:y];
    }
}

-(void)moveAtom:(Atom *)a {
    
}

-(void)manageHeadOnCollisions:(Atom *)a {
    
}

-(void)renderAtX:(NSInteger)x andY:(NSInteger)y {
    
}

-(void)render {
    
}

-(void)manageIntersections {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toggleTime:(UIButton*)sender{
    if (sender.selected) { //Paused
        sender.selected = NO;
        [self.timer invalidate];
        self.timer = nil;
        
        
    } else { // stop current time
        sender.selected = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self
                                                    selector: @selector(runLoop:) userInfo: nil repeats: YES];
    }
}

-(void)dealloc {
    self.atoms = nil;
    self.grid = nil;
    self.timer = nil;
    self.buttonsGrid = nil;
}

-(void)step {
    if (self.atoms.count > 0){
        //purge old atoms
        for (Atom * a in self.atoms){
            [self moveAtom:a];
        }
        if (self.atoms.count > 1){
            for (Atom *a in self.atoms){
                [self manageHeadOnCollisions:a];
            }
            [self manageIntersections];
        }
        [self render];
        
    }
}

-(void)runLoop:(id)s{
    [self step];
}

@end
