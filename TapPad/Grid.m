//
//  Grid.m
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#import "Grid.h"

@implementation Grid

-(id) initWithDimension:(NSInteger)dim {
    self.dimension = dim;
    if (self = [super init]) {
        //Create our grid
        self.rows = [[NSMutableArray alloc] initWithCapacity:dim];
        for (int j = 0; j < dim; j++) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:dim];
            for (int i = 0; i < dim; i++) {
                arr[i] = [@{} mutableCopy];
            }
            [self.rows addObject:arr];
        }
    }
    return self;
}

-(void) removeObjectWithId:(NSString *)idKey fromRow:(NSInteger)row andColumn:(NSInteger)col
{
    [self.rows[row][col] removeObjectForKey:idKey];
}

-(void) addObject:(id)obj withId:(NSString *)idKey toRow:(NSInteger)row andColumn:(NSInteger)col
{
    self.rows[row][col][idKey] = obj;
}

-(NSInteger) countAtRow:(NSInteger)row andCol:(NSInteger)col
{
    return [self.rows[row][col] allKeys].count;
}

-(void) dealloc
{
    self.rows = nil;
}


@end
