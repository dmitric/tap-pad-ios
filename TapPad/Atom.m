//
//  Atom.m
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#import "Atom.h"

@implementation Atom

-(id) initWithX:(NSInteger)x andY:(NSInteger)y
{
    self = [self initWithX:x andY:y andDirection:1 andVertical:YES];
    if (self) {
        
    }
    return self;
}

-(id) initWithX:(NSInteger)x andY:(NSInteger)y
   andDirection:(NSInteger)direction andVertical:(BOOL)vertical
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.vertical = vertical;
        self.direction = direction;
    }
    return self;
}

-(void) changeDirection
{
    self.direction *= -1;
    self.collisions++;
}

-(void)collide
{
    self.vertical = !self.vertical;
    self.collisions++;
}

-(void)move
{
    if (self.vertical) {
        self.y += self.direction;
    }
    else {
        self.x += self.direction;
    }
    self.moves++;
}

-(NSInteger) nextX
{
    NSInteger nextX = self.x;
    if (!self.vertical) {
        nextX += self.direction;
    }
    return nextX;
}

-(NSInteger) nextY
{
    NSInteger nextY = self.y;
    if (self.vertical) {
        nextY += self.direction;
    }
    return nextY;
}

-(NSDictionary *) serialize
{
    return @{
             @"direction": @(self.direction),
             @"x": @(self.x),
             @"y": @(self.y),
             @"vertical": @(self.vertical)
        };
    
}

-(NSString *) stringId
{
    return [@(self.identifier) description];
}

@end
