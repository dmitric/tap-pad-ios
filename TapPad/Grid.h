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
@property (nonatomic, strong) NSMutableArray *rows;

-(id) initWithDimension:(NSInteger)dim;

-(void) removeObjectWithId:(NSString *)idKey fromRow:(NSInteger)row andColumn:(NSInteger)col;

-(void) addObject:(id)obj withId:(NSString *)idKey toRow:(NSInteger)row andColumn:(NSInteger)col;

-(NSInteger) countAtRow:(NSInteger)row andCol:(NSInteger)col;



@end
