//
//  ONUtilities.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 29/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONUtilities.h"



@implementation ONUtilities


double randomDouble (void) {
    return (rand())/(RAND_MAX+1.0);
}

double randomClampedDouble (void) {
    return randomDouble() - randomDouble();
}


@end
