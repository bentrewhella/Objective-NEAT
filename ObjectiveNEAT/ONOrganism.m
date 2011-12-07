//
//  ONOrganism.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 30/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONOrganism.h"
#import "ONGenome.h"
#import "ONNetwork.h"

@implementation ONOrganism
@synthesize genome, network, fitness;


- (id)initWithGenome: (ONGenome *) dna 
{
    self = [super init];
    if (self) {
        genome = dna;
        fitness = 0;
    }
    return self;
}

-(void) developNetwork {
    NSAssert(genome != nil, @"This organisms genome has not been set - cannot develop network without a genome");
    network = [[ONNetwork alloc] initWithGenome:genome];
}

-(void) destroyNetwork {
    network = nil;
}

-(ONOrganism *) reproduceChildOrganism {
    ONGenome * childGenome = [genome copy];
    [childGenome mutateGenome];
    ONOrganism * childOrganism = [[ONOrganism alloc] initWithGenome:childGenome];
    return childOrganism;
}

-(ONOrganism *) reproduceChildOrganismWithOrganism: (ONOrganism *) lessFitMate {
    ONGenome * childGenome = [genome offspringWithGenome: lessFitMate.genome];
    [childGenome mutateGenome];
    ONOrganism * childOrganism = [[ONOrganism alloc] initWithGenome:childGenome];
    return childOrganism;
}

-(NSComparisonResult) compareFitnessWith: (ONOrganism *) anotherOrganism {
    if (self.fitness < anotherOrganism.fitness) {
        return NSOrderedDescending;
    }
    if (self.fitness == anotherOrganism.fitness) {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

-(ONOrganism *) copyWithZone: (NSZone *) zone {
    ONOrganism * copiedOrganism = [[ONOrganism alloc] init];
    copiedOrganism.genome = [genome copy];
    copiedOrganism.fitness = fitness;
    return copiedOrganism;
}


-(NSString *) description {
    return [NSString stringWithFormat: @"Organism with fitness: %1.3f", fitness];   
}


@end
