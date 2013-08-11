//
//  Grid.m
//  TapPad
//
//  Created by Dmitri Cherniak on 8/11/13.
//  Copyright (c) 2013 Dmitri Cherniak. All rights reserved.
//

#import "Grid.h"

@interface Grid ()

@property (nonatomic, strong) NSMutableArray *rows;

@end

@implementation Grid

-(id) initWithDimension:(NSInteger)dim {
    self.dimension = dim;
    if(self = [super init]){
        //Create our grid
        self.rows = [[NSMutableArray alloc] initWithCapacity:dim];
        for (int j = 0; j < dim; j++) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:dim];
            for (int i = 0; i < dim; i++){
                arr[i] = [@{} mutableCopy];
            }
            [self.rows addObject:arr];
            
        }
    }
    return self;
}

-(id) objectAtIndex:(NSUInteger)idx{
    return self.rows[idx];
}

-(void) removeObjectWithId:(NSString *)idKey fromRow:(NSInteger)row andColumn:(NSInteger)col {
    [self.rows[row][col] removeObjectForKey:idKey];
}


@end
