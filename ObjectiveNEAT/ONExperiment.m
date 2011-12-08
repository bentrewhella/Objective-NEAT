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

#import "ONExperiment.h"
#import "ONParameterController.h"
#import "ONInnovationDB.h"

@implementation ONExperiment
@synthesize solutionFound;

-(ONGenome *) initialGenome {
    return [ONGenome createSimpleGenomeWithInputs:2 outputs:1];
}

-(void) initialiseExperiment {
    int seed = [ONParameterController randomSeed];
    if (seed == 0) {
        srand((unsigned int)time(NULL));
    }
    else {
        srand(seed);
    }
}

-(void) initialisePopulation {
    ONGenome * firstGenome = [self initialGenome];
    thePopulation = [ONPopulation spawnInitialGenerationFromGenome:firstGenome];
}

-(void) evaluateOrganism: (ONOrganism *) subject {
    // to be overrriden by experiment subclasses
}

-(void) runExperiment {
    
    [self initialiseExperiment];
    solutionFound = false;
    // initialise the population
    [self initialisePopulation]; 
    [self evaluatePopulation];
    while (!solutionFound && thePopulation.generation < [ONParameterController numGenerations]) {
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
