/*
 * ObjectiveNEAT 0.1.0
 * Author: Ben Trewhella
 *
 * Copyright (c) 2011 OpposableIntelligence.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "ONOrganism.h"
#import "ONGenome.h"
#import "ONNetwork.h"

@implementation ONOrganism
@synthesize genome, fitness;


- (id)initWithGenome: (ONGenome *) dna 
{
    self = [super init];
    if (self) {
        genome = [dna retain];
        fitness = 0;
    }
    return self;
}

-(ONNetwork *) network {
    return network;
}

-(void) developNetwork {
    NSAssert(genome != nil, @"This organisms genome has not been set - cannot develop network without a genome");
    network = [[ONNetwork alloc] initWithGenome:genome];
}

-(void) destroyNetwork {
    [network release];
    network = nil;
}

-(ONOrganism *) reproduceChildOrganism {
    ONGenome * childGenome = [genome copy];
    [childGenome mutateGenome];
    ONOrganism * childOrganism = [[ONOrganism alloc] initWithGenome:childGenome];
    [childGenome release];
    return childOrganism;
}

-(ONOrganism *) reproduceChildOrganismWithOrganism: (ONOrganism *) lessFitMate {
    ONGenome * childGenome = [genome offspringWithGenome: lessFitMate.genome];
    [childGenome mutateGenome];
    ONOrganism * childOrganism = [[ONOrganism alloc] initWithGenome:childGenome];
    [childGenome release];
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

-(void) dealloc {
    if (network != nil) {
        [network release];
    }
    [genome release];
    [super dealloc];
}


@end
