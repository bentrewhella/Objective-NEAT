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
    
    
    for (int i = 0; i < [ONParameterController numGenerations]; i++) {
        if (i == 0) {
            // initialise the population
            [self initialisePopulation]; 
        }
        else {
            [thePopulation rePopulateFromFittest];
        }
        [self evaluatePopulation];
    }
    
}

-(void) evaluatePopulation {
    for (ONOrganism * nextOrganism in thePopulation.allOrganisms) {
        [nextOrganism developNetwork];
        
        [self evaluateOrganism: nextOrganism];
        
        [nextOrganism destroyNetwork];
    }
    NSLog(@"%@", [thePopulation description]);
}

@end
