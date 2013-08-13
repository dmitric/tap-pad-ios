//
//  ViewController.m
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#define gridDimension 8

#define bgGray (245./256.)
#define borderGray (158./256.)

#define bgColor [UIColor colorWithRed:bgGray green:bgGray blue:bgGray alpha:1.]
#define cellBorderColor [UIColor colorWithRed:borderGray green:borderGray blue:borderGray alpha:1.]
#define singleAutomatonColor [UIColor colorWithRed:194/256. green:221./256. blue:255./256. alpha:0.97]
#define multipleAutomatonColor [UIColor colorWithRed:249./256. green:83./256. blue:59./256. alpha:1.0]


#define iPhoneCellWidth 39.
#define iPadCellWidth 88.

#define hostName @"http://tap-pad.herokuapp.com"

#define loadingGridText @"LOADING GRID"
#define successfulLoadGridText @"LOADED GRID :)"
#define generatingLinkText @"GENERATING LINK"
#define errorGeneratingLinkText @"LINK FAILED :("
#define shareMessage @"Are we just automatons that make beautiful music? Listen to this."

#import "TapPadViewController.h"
#import "Grid.h"
#import "Atom.h"
#import "ADNActivityCollection.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AFNetworking/AFNetworking.h>

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
@property (nonatomic, strong) AFHTTPClient *httpClient;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UIActivityViewController *activityViewController;
@property (nonatomic, weak) IBOutlet UIButton *playControlButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIView *buttonEnclosure;
@property (nonatomic, weak) IBOutlet UILabel *accessoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *shoutoutLabel;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, assign) NSInteger collisionsLimit;
@property (nonatomic, assign) NSInteger movesLimit;

@end

@implementation TapPadViewController

static NSInteger seed = 0;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        self = [super initWithNibName:[NSString stringWithFormat:@"%@~iPad", nibNameOrNil]
                               bundle:nibBundleOrNil];
    } else {
        self = [super initWithNibName:[NSString stringWithFormat:@"%@~iPhone", nibNameOrNil] bundle:nibBundleOrNil];
    }
    
    if (self) {
        self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:hostName]];
        [self.httpClient setParameterEncoding:AFFormURLParameterEncoding];
        [self.httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        self.atoms = [[NSMutableArray alloc] initWithCapacity:gridDimension];
        
        self.grid = [[Grid alloc] initWithDimension:gridDimension];
        self.buttonsGrid = [[NSMutableArray alloc] initWithCapacity:gridDimension];
        
        self.collisionsLimit = 100;
        self.movesLimit = 300;
    }
    return self;
}

- (void) viewDidLoad
{
    
    [super viewDidLoad];
    [self setupFonts];
    
    self.accessoryLabel.alpha = 0;
    self.accessoryLabel.text = generatingLinkText;
    
    for (int j = 0; j < gridDimension; j++) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:gridDimension];
        for (int i = 0; i < gridDimension; i++){
            
            CGRect r;
            
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
                r = CGRectMake(28.+(1.+iPadCellWidth)*i, 124.+(1.+iPadCellWidth)*j,
                               iPadCellWidth, iPadCellWidth);
            }else{
                r = CGRectMake(0.5+(1.+iPhoneCellWidth)*i,
                               101.+(1.+iPhoneCellWidth)*j,
                               iPhoneCellWidth,
                               iPhoneCellWidth);
            }
            
            UIView *backingView = [[UIView alloc] initWithFrame:r];
            backingView.backgroundColor = bgColor;
            backingView.layer.borderWidth = 1.0;
            backingView.layer.borderColor = cellBorderColor.CGColor;
            
            UIButton *button = [[UIButton alloc] initWithFrame:r];
            button.backgroundColor = [UIColor clearColor];
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = [UIColor clearColor].CGColor;
            arr[i] = backingView;
            
            //a hack to encode 2d positon -- +1 on the 2nd digit to deal with 0 case
            button.tag = (j+1)*10 + i;
            
            [button addTarget:self action:@selector(shrinkBacking:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(resize:) forControlEvents:UIControlEventTouchDragExit];
            [button addTarget:self action:@selector(shrinkBacking:) forControlEvents:UIControlEventTouchDragEnter];
            [button addTarget:self action:@selector(resize:) forControlEvents:UIControlEventTouchDragExit];
            [button addTarget:self action:@selector(resize:) forControlEvents:UIControlEventTouchCancel];
            
            [self.view addSubview:backingView];
            [self.view addSubview:button];
        }
        [self.buttonsGrid addObject:arr];
    }
    self.playControlButton.hidden = YES;
    [self setPlayButtonTitle:@"PAUSE"];
    [self loadSounds];
}

-(void) loadSounds{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:soundPath]), &sound0);
    soundPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:soundPath]), &sound1);
    soundPath = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:soundPath]), &sound2);
    soundPath = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:soundPath]), &sound3);
    soundPath = [[NSBundle mainBundle] pathForResource:@"4" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:soundPath]), &sound4);
    soundPath = [[NSBundle mainBundle] pathForResource:@"5" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:soundPath]), &sound5);
    soundPath = [[NSBundle mainBundle] pathForResource:@"6" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:soundPath]), &sound6);
    soundPath = [[NSBundle mainBundle] pathForResource:@"7" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:soundPath]), &sound7);
}

-(void) setPlayButtonTitle:(NSString *)s {
    [self.playControlButton setTitle:s forState:UIControlStateNormal];
    [self.playControlButton setTitle:s forState:UIControlStateHighlighted];
}

-(void) shrinkBacking:(UIButton *)b {
    int y = b.tag/10 - 1;
    int x = b.tag % 10;
    UIView *v = self.buttonsGrid[y][x];
    [UIView animateWithDuration:0.1 delay:0.
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         v.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.75, 0.75);
                     } completion:nil];
    
}

-(BOOL) isValidMove:(NSInteger) x and:(NSInteger) y{
    return !(x > gridDimension-1 || x < 0
             || y > gridDimension-1 || y < 0);
}

-(void) addAtomWithX:(NSInteger)x andY:(NSInteger)y andRender:(BOOL)render{
    [self addAtomWithX:x andY:y andDirection:1 andVertical:YES andRender:render];
}

-(void) addAtomWithX:(NSInteger)x andY:(NSInteger)y andDirection:(NSInteger)d
         andVertical:(BOOL)vertical andRender:(BOOL)render {
    
    if (![self isValidMove:x and:y]){
        NSLog(@"Can't add, outside of bounds");
    }else{
        Atom *a = [[Atom alloc] init];
        a.x = x;
        a.y = y;
        a.direction = d;
        a.vertical = vertical;
        a.identifier = seed++;
        [self.atoms addObject:a];
        [self.grid addObject:a withId:[a stringId]
                       toRow:a.y andColumn:a.x];
        if (render) {
            [self renderAtX:x andY:y];
        }
    }
}

-(void) tapButton:(UIButton *)b {
    int y = b.tag/10 - 1;
    int x = b.tag % 10;
    [self resize:b];
    [self addAtomWithX:x andY:y andRender:YES];
    if (self.playControlButton.hidden) {
        [self play];
        self.playControlButton.hidden = NO;
    }
    
}

-(void) resize:(UIButton *)b{
    int y = b.tag/10 - 1;
    int x = b.tag % 10;
    UIView *v = self.buttonsGrid[y][x];
    [self resizeBackingView:v];
    
}

-(void) resizeBackingView:(UIView *)v {
    
    [UIView animateWithDuration:0.1 delay:0.
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         v.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     } completion:nil];
}

-(void) moveAtom:(Atom *)atom {
    NSInteger curX = atom.x;
    NSInteger curY = atom.y;
    NSInteger nextX = [atom nextX];
    NSInteger nextY = [atom nextY];
    
    if (![self isValidMove:nextX and:nextY]){
        [atom changeDirection];
        if (atom.vertical){
            [self playAudio:curX];
        }else{
            [self playAudio:curY];
        }
    }
    
    [self.grid removeObjectWithId:[atom stringId]
                          fromRow:curY andColumn:curX];
    [atom move];
                
    curX = atom.x;
    curY = atom.y;
    
    [self.grid addObject:atom withId:[atom stringId] toRow:curY andColumn:curX];
}

-(void) manageHeadOnCollisions:(Atom *)atom {
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

-(void) playAudio:(NSInteger)sound{
    switch (sound) {
        case 0:
            AudioServicesPlaySystemSound(sound0);
            break;
        case 1:
            AudioServicesPlaySystemSound(sound1);
            break;
        case 2:
            AudioServicesPlaySystemSound(sound2);
            break;
        case 3:
            AudioServicesPlaySystemSound(sound3);
            break;
        case 4:
            AudioServicesPlaySystemSound(sound4);
            break;
        case 5:
            AudioServicesPlaySystemSound(sound5);
            break;
        case 6:
            AudioServicesPlaySystemSound(sound6);
            break;
        case 7:
            AudioServicesPlaySystemSound(sound7);
            break;
    }
    
}

-(void) renderAtX:(NSInteger)x andY:(NSInteger)y {
    NSInteger count = [self.grid countAtRow:y andCol:x];
    UIView * b = self.buttonsGrid[y][x];
    UIColor *c = nil;
    if (count == 0){
        c = bgColor;
    }else if(count == 1){
        c = singleAutomatonColor;
    }else{
        c = multipleAutomatonColor;
    }
    [UIView animateWithDuration:0.1 delay:0.
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        b.backgroundColor = c;
    } completion:nil];
    
}

-(void) render {
    for (int j = 0; j < gridDimension; j++) {
        for (int i = 0; i < gridDimension; i++){
            [self renderAtX:i andY:j];
        }
    }
}

-(void) manageIntersections {
    
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

-(IBAction) toggleTime:(UIButton*)sender{
    if (self.isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

-(void) play {
    [self setPlayButtonTitle:@"PAUSE"];
    self.isPlaying = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self
                                                selector: @selector(runLoop:) userInfo: nil repeats: YES];
}

-(void) pause {
    [self setPlayButtonTitle:@"PLAY"];
    self.isPlaying = NO;
    [self.timer invalidate];
    self.timer = nil;
}

-(void) purgeOldAtoms {
    NSMutableArray *keep = [@[] mutableCopy];
    
    for (Atom *atom in self.atoms){
        if (atom.collisions > self.collisionsLimit ||
            atom.moves > self.movesLimit) {
            [self.grid removeObjectWithId:[atom stringId]
                                  fromRow:atom.y andColumn:atom.x];
            
        }else{
            [keep addObject:atom];
        }
    }
    self.atoms = keep;
    
}

-(void)loadSound:(NSString *)soundCode {
    self.shareButton.enabled = NO;
    [self pause];
    self.accessoryLabel.alpha = 0;
    self.accessoryLabel.text = loadingGridText;
    
    [UIView animateWithDuration:0.1 delay:0. options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.accessoryLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [self addLoadingPulseAnimation];
        
        [self.httpClient postPath:[NSString stringWithFormat:@"grid/%@" ,soundCode] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:0 error:&error];
            [self removeLoadingPulseAnimation];
            if (!error && json[@"atoms"]) {
                [self loadAtoms:json[@"atoms"]];
            }else{
                [self handleConnectionError:error];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self removeLoadingPulseAnimation];
            [self handleConnectionError:error];
        }];
    }];
    
}

-(void)loadAtoms:(NSArray *)atomList{
    
    [self clearAtoms];
    [atomList enumerateObjectsUsingBlock:^(NSDictionary *atomDict, NSUInteger idx, BOOL *stop) {
        @try {
            [self addAtomWithX:[atomDict[@"x"] integerValue]
                          andY:[atomDict[@"y"] integerValue]
                  andDirection:[atomDict[@"direction"] integerValue] == 1 ? 1 : -1
                   andVertical:[atomDict[@"vertical"] boolValue]
                     andRender:NO];

        }
        @catch (NSException *exception) {
            NSLog(@"Failed to load atom");
        }
        
    }];
    
    [self render];
    
    self.accessoryLabel.text = successfulLoadGridText;
    [UIView animateWithDuration:0.1 delay:0. options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.accessoryLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (self.playControlButton.hidden)
            self.playControlButton.hidden = NO;
        [UIView animateWithDuration:0.1 delay:1.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.accessoryLabel.alpha = 0;
        } completion:^(BOOL finished){
            self.accessoryLabel.text = generatingLinkText;
            self.shareButton.enabled = YES;
        }];
    }];
    
}

-(void) clearAtoms {
    [self.atoms removeAllObjects];
    [self.grid.rows enumerateObjectsUsingBlock:^(NSMutableArray *cols, NSUInteger idx, BOOL *stop) {
        [cols enumerateObjectsUsingBlock:^(NSMutableDictionary *map, NSUInteger idx, BOOL *stop) {
            [map removeAllObjects];
        }];
    }];
}

-(NSArray *) serializeAtoms {
    NSMutableArray *d = [@[] mutableCopy];
    [self.atoms enumerateObjectsUsingBlock:^(Atom *obj, NSUInteger idx, BOOL *stop) {
        [d addObject:[obj serialize]];
    }];
    return d;
}

-(IBAction) shareBoardState:(UIButton *)button {
    self.shareButton.enabled = NO;
    self.accessoryLabel.text = generatingLinkText;
    
    __block BOOL state = self.isPlaying;
    if (state){
        [self pause];
    }
    
    [UIView animateWithDuration:0.1 delay:0. options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.accessoryLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [self addLoadingPulseAnimation];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:[self serializeAtoms] options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *encodedString = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.httpClient postPath:@"link-for-mobile"
                  parameters: @{@"atoms": encodedString }
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSError *error = nil;
                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                              options:0 error:&error];
                         [self removeLoadingPulseAnimation];
                         if (!error && json[@"link"]) {
                             [self shareLink:json[@"link"] andReturnToState:state];
                         } else {
                             [self handleConnectionError:error];
                         }
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self removeLoadingPulseAnimation];
                         [self handleConnectionError:error];
                     }];
    }];
    
}

-(void)addLoadingPulseAnimation{
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pulse.duration=0.5;
    pulse.repeatCount=HUGE_VALF;
    pulse.autoreverses=YES;
    pulse.fromValue=[NSNumber numberWithFloat:1.0];
    pulse.toValue=[NSNumber numberWithFloat:0.2];
    [self.accessoryLabel.layer addAnimation:pulse forKey:@"pulse"];
}

-(void)setupFonts {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        self.shareButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:18];
        self.titleLabel.font = [UIFont fontWithName:@"Raleway-ExtraBold" size:30];
        self.playControlButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:25];
    }else{
        self.titleLabel.font = [UIFont fontWithName:@"Raleway-ExtraBold" size:25];
        self.shareButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:15];
        self.playControlButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:20];
    }
    self.accessoryLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:15];
}

-(void) removeLoadingPulseAnimation {
    [self.accessoryLabel.layer removeAnimationForKey:@"pulse"];
}

-(void) shareLink:(NSString *)link andReturnToState:(BOOL)state {
    
    NSArray * activityItems = @[
        [NSString stringWithFormat:shareMessage],
        [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", hostName, link]]
    ];
    
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:[ADNActivityCollection allActivities]];
    
    self.activityViewController.excludedActivityTypes = @[
        UIActivityTypePostToWeibo, UIActivityTypePrint
    ];
    
    __block id myself = self;
    
    [self.activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if (state) {
            [myself play];
        }
    }];
    
    [self presentViewController:self.activityViewController animated:YES completion:^{
        [UIView animateWithDuration:0.1 delay:0. options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.accessoryLabel.alpha = 0.0;
        } completion:^(BOOL complete){
           self.shareButton.enabled = YES; 
        }];
    }];
    
}

-(void) handleConnectionError:(NSError *)error {
    self.accessoryLabel.text = errorGeneratingLinkText;
    [UIView animateWithDuration:0.1 delay:0. options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.accessoryLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:1.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.accessoryLabel.alpha = 0;
        } completion:^(BOOL finished){
            self.accessoryLabel.text = generatingLinkText;
            self.shareButton.enabled = YES;
        }];
    }];
    
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

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    self.atoms = nil;
    self.grid = nil;
    [self.timer invalidate];
    self.timer = nil;
    self.buttonsGrid = nil;
    self.activityViewController = nil;
    self.httpClient = nil;
    AudioServicesDisposeSystemSoundID(sound0);
    AudioServicesDisposeSystemSoundID(sound1);
    AudioServicesDisposeSystemSoundID(sound2);
    AudioServicesDisposeSystemSoundID(sound3);
    AudioServicesDisposeSystemSoundID(sound4);
    AudioServicesDisposeSystemSoundID(sound5);
    AudioServicesDisposeSystemSoundID(sound6);
    AudioServicesDisposeSystemSoundID(sound7);
}


@end
