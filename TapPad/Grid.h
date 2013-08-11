//
//  Grid.h
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grid : NSObject

@property (nonatomic, assign) NSInteger dimension;

-(id)initWithDimension:(NSInteger)dim;

-(id) objectAtIndex:(NSUInteger)idx;

-(void) removeObjectWithId:(NSString *)idKey fromRow:(NSInteger)row andColumn:(NSInteger)col;

@end
