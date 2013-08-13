//
//  ADNActivityCollection.m
//  ADNActivityCollection
//
//  Created by Brennan Stehling on 3/20/13.
//  Copyright (c) 2013 SmallSharptools LLC. All rights reserved.
//

#import "ADNActivityCollection.h"

#import "ADNFelixActivity.h"
#import "ADNNetbotActivity.h"
#import "ADNRiposteActivity.h"
#import "ADNHappyActivity.h"

@implementation ADNActivityCollection

+ (NSArray *)allActivities {
    return @[
                [[ADNFelixActivity alloc] init],
                [[ADNNetbotActivity alloc] init],
                [[ADNRiposteActivity alloc] init],
                [[ADNHappyActivity alloc] init]
            ];
}

@end
