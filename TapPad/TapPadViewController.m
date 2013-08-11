//
//  ViewController.m
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#define gridDimension 8
#define bgRatio (245./256.)
#define bgColor [UIColor colorWithRed:bgRatio green:bgRatio blue:bgRatio alpha:1]

#import "TapPadViewController.h"
#import "Grid.h"
#import "Atom.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TapPadViewController (){
    SystemSoundID sound0;
    SystemSoundID sound1;
    SystemSoundID sound2;
    SystemSoundID sound3;
    SystemSoundID sound4;
    SystemSoundID sound5;
    SystemSoundID sound6;
    SystemSoundID sound7;
}



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
    self.collisionsLimit = 100;
    self.movesLimit = 300;
	// Do any additional setup after loading the view, typically from a nib.
    self.grid = [[Grid alloc] initWithDimension:gridDimension];
    self.buttonsGrid = [[NSMutableArray alloc] initWithCapacity:gridDimension];
    CGFloat borderRatio = 158./256.;
    
    for (int j = 0; j < gridDimension; j++) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:gridDimension];
        for (int i = 0; i < gridDimension; i++){
            CGRect r = CGRectMake(28+(1+88)*i, 124+(1+88)*j, 88, 88);
            UIView *backingView = [[UIView alloc] initWithFrame:r];
            [backingView setBackgroundColor:bgColor];
            backingView.layer.borderWidth = 1.0;
            backingView.layer.borderColor = [UIColor colorWithRed:borderRatio
                                                            green:borderRatio
                                                             blue:borderRatio alpha:1].CGColor;
            
            UIButton *button = [[UIButton alloc] initWithFrame:r];
            
            [button setBackgroundColor:[UIColor clearColor]];
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = [UIColor clearColor].CGColor;
            arr[i] = backingView;
            button.tag = (j+1)*10 + i;
            
            [button addTarget:self action:@selector(shrinkBacking:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(resize:) forControlEvents:UIControlEventTouchDragExit];
            [button addTarget:self action:@selector(shrinkBacking:) forControlEvents:UIControlEventTouchDragEnter];
            [button addTarget:self action:@selector(resize:) forControlEvents:UIControlEventTouchDragExit];
            [self.view addSubview:backingView];
            [self.view addSubview:button];
        }
        [self.buttonsGrid addObject:arr];
    }
    
    [self.playControlButton setTitle:@"PLAY" forState:UIControlStateHighlighted];
    [self.playControlButton setTitle:@"PAUSE" forState:UIControlStateSelected];
    self.playControlButton.hidden = YES;
    self.atoms = [[NSMutableArray alloc] initWithCapacity:5];
    self.timer = [[NSTimer alloc] init];
    [self loadSounds];
}

-(void)loadSounds{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:soundPath]), &sound0);
}

-(void)shrinkBacking:(UIButton *)b {
    int y = b.tag/10 - 1;
    int x = b.tag % 10;
    UIView *v = self.buttonsGrid[y][x];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.1];
        v.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.73, 0.73);
    [UIView commitAnimations];
    
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
        [self.atoms addObject:a];
        [self.grid addObject:a withId:[@(a.identifier) description]
                             toRow:a.y andColumn:a.x];
        [self renderAtX:x andY:y];
    }
}

-(void)tapButton:(UIButton *)b {
    int y = b.tag/10 - 1;
    int x = b.tag % 10;
    [self resize:b];
    [self addAtomWithX:x andY:y];
    if(self.playControlButton.hidden) {
        [self toggleTime:self.playControlButton];
        self.playControlButton.hidden = NO;
    }
    
}

-(void)resize:(UIButton *)b{
    int y = b.tag/10 - 1;
    int x = b.tag % 10;
    UIView *v = self.buttonsGrid[y][x];
    [self resizeBackingView:v];
    
}

-(void)resizeBackingView:(UIView *)v {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.1];
    v.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [UIView commitAnimations];
}

-(void)moveAtom:(Atom *)atom {
    NSInteger curX = atom.x;
    NSInteger curY = atom.y;
    NSInteger nextX = [atom nextX];
    NSInteger nextY = [atom nextY];
    
    if (![self isValidMove:nextX and:nextY]){
        [atom changeDirection];
        if (atom.vertical){
            [self play:curX];
        }else{
            [self play:curY];
        }
    }
    NSString *atomId = [@(atom.identifier) description];
    [self.grid removeObjectWithId:atomId
                          fromRow:curY andColumn:curX];
    [atom move];
                
    curX = atom.x;
    curY = atom.y;
    
    [self.grid addObject:atom withId:atomId toRow:curY andColumn:curX];
}

-(void)manageHeadOnCollisions:(Atom *)atom {
    int nextX = [atom nextX];
    int nextY = [atom nextY];
    if ([self isValidMove:nextX and:nextY]){
        if ([self.grid countAtRow:nextY andCol:nextX] >= 1){
            NSMutableDictionary *d = self.grid.rows[nextY][nextX];
            for (NSString *otherAtomId in [d allKeys]){
                Atom *otherAtom = self.grid.rows[nextY][nextX][otherAtomId];
                BOOL diffDirection = atom.direction != otherAtom.direction;
                BOOL sameOrientation = atom.vertical == otherAtom.vertical;
                if (diffDirection && sameOrientation){
                    [otherAtom changeDirection];
                }
            }
            [atom changeDirection];
        }
    }
    
}

-(void)play:(NSInteger)sound{
    switch (sound) {
        case 0:
            AudioServicesPlaySystemSound(sound0);
            break;
    }
    
}

-(void)renderAtX:(NSInteger)x andY:(NSInteger)y {
    NSInteger count = [self.grid countAtRow:y andCol:x];
    UIView * b = self.buttonsGrid[y][x];
    UIColor *c = nil;
    if (count == 0){
        c = bgColor;
    }else if(count == 1){
        c = [UIColor colorWithRed:194/256.
                            green:221./256.
                            blue:255./256.
                            alpha:0.97];
    }else{
        c = [UIColor colorWithRed:249./256.
                           green:83./256.
                            blue:59./256.
                           alpha:1.0];
    }
    [UIView animateWithDuration:0.1 delay:0. options:UIViewAnimationOptionCurveEaseIn animations:^{
        [b setBackgroundColor:c];
    } completion:^(BOOL finished) { }];
    
}

-(void)render {
    for (int j = 0; j < gridDimension; j++) {
        for (int i = 0; i < gridDimension; i++){
            [self renderAtX:i andY:j];
        }
    }
}

-(void)manageIntersections {
    
    for (int j = 0; j < gridDimension; j++) {
        for (int i = 0; i < gridDimension; i++){
            int sizeOfCell = [self.grid countAtRow:j andCol:i];
            if (sizeOfCell > 1){
                NSDictionary *d = self.grid.rows[j][i];
                for (Atom *atom in [d allValues]){
                    [atom collide];
                }
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toggleTime:(UIButton*)sender{
    if (sender.selected) { //Paused
        sender.selected = NO;
        [self.playControlButton setTitle:@"PLAY" forState:UIControlStateHighlighted];
        [self.timer invalidate];
        self.timer = nil;
        
        
    } else { // stop current time
        sender.selected = YES;
        [self.playControlButton setTitle:@"PAUSE" forState:UIControlStateHighlighted];
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self
                                                    selector: @selector(runLoop:) userInfo: nil repeats: YES];
    }
}

-(void)purgeOldAtoms {
    NSMutableArray *keep = [@[] mutableCopy];
    
    for (Atom *atom in self.atoms){
        if (atom.collisions > self.collisionsLimit ||
            atom.moves > self.movesLimit) {
            [self.grid removeObjectWithId:[@(atom.identifier) description]
                                  fromRow:atom.y andColumn:atom.x];
            
        }else{
            [keep addObject:atom];
        }
    }
    self.atoms = keep;
    
}

-(void)dealloc {
    self.atoms = nil;
    self.grid = nil;
    self.timer = nil;
    self.buttonsGrid = nil;
    AudioServicesDisposeSystemSoundID(sound0);
    AudioServicesDisposeSystemSoundID(sound1);
    AudioServicesDisposeSystemSoundID(sound2);
    AudioServicesDisposeSystemSoundID(sound3);
    AudioServicesDisposeSystemSoundID(sound4);
    AudioServicesDisposeSystemSoundID(sound5);
    AudioServicesDisposeSystemSoundID(sound6);
    AudioServicesDisposeSystemSoundID(sound7);
}

-(void)step {
    if (self.atoms.count > 0){
        [self purgeOldAtoms];
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
