//
//  ONExperiment.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 28/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONExperiment.h"
#import "ONParameterController.h"
#import "ONInnovationDB.h"

@implementation ONExperiment
@synthesize solutionFound;

-(ONGenome *) initialGenome {
    return [ONGenome createSimpleGenomeWithInputs:2 outputs:1];
}

-(void) initialisePopulation {
    ONGenome * firstGenome = [self initialGenome];
    thePopulation = [ONPopulation spawnInitialGenerationFromGenome:firstGenome];
}

-(void) evaluateOrganism: (ONOrganism *) subject {
    // to be overrriden by experiment subclasses
}

-(void) runExperiment {
    
    solutionFound = false;
    // initialise the population
    [self initialisePopulation]; 
    [self evaluatePopulation];
    while (!solutionFound) {
        [thePopulation rePopulateFromFittest];
        NSLog(@"%@", [thePopulation description]);
        [self evaluatePopulation];
    }
    [self reportResults];
}

-(void) evaluatePopulation {
    for (ONOrganism * nextOrganism in thePopulation.allOrganisms) {
        [nextOrganism developNetwork];
        
        [self evaluateOrganism: nextOrganism];
        
        [nextOrganism destroyNetwork];
    }
}

-(void) reportResults {
    // called when the experiment ends, override as required
}

@end
