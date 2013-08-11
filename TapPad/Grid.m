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
    if(self = [super init]){
        //Create our grid
        self.rows = [[NSMutableArray alloc] initWithCapacity:dim];
        [self.rows enumerateObjectsUsingBlock:^(id obj, NSUInteger idy, BOOL *stop) {
            self.rows[idy] = [[NSMutableArray alloc] initWithCapacity:dim];
            [self.rows[idy] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                self.rows[idy][idx] = [@{} mutableCopy];
            }];
        }];
    }
    return self;
}


@end
