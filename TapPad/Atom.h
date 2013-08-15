//
//  Atom.h
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Atom : NSObject

@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, assign) NSUInteger x;
@property (nonatomic, assign) NSUInteger y;

@property (nonatomic, assign) NSUInteger moves;
@property (nonatomic, assign) NSUInteger collisions;
@property (nonatomic, assign) NSInteger direction;

@property (nonatomic, assign) BOOL vertical;

-(id) initWithX:(NSInteger)x andY:(NSInteger)y;
-(id) initWithX:(NSInteger)x andY:(NSInteger)y
   andDirection:(NSInteger)direction andVertical:(BOOL)vertical;

-(void) changeDirection;
-(void) collide;
-(void) move;
-(NSInteger) nextX;
-(NSInteger) nextY;
-(NSString *) stringId;

-(NSDictionary *)serialize;

@end
