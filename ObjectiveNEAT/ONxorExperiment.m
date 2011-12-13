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

#import "ONxorExperiment.h"


@implementation ONxorExperiment

-(ONGenome *) initialGenome {
    //return [ONGenome createXORGenome];
    return [ONGenome createSimpleGenomeWithInputs:2 outputs:1];
}

-(void) evaluateOrganism: (ONOrganism *) subject {
    
    double sensorInputs[4][2] = {{0.0, 0.0}, {1.0, 0.0}, {0.0, 1.0}, {1.0, 1.0}};
    double finalOutput[4];
    
    //int count = [[subject network] retainCount];
    
    // to start with we're just going to run through the single genome
    for (int i = 0; i < 4; i++) {
        // load in the initial sensor data
        
        [subject.network updateSensors:[NSArray arrayWithObjects:
                                    [NSNumber numberWithDouble:sensorInputs[i][0]], 
                                    [NSNumber numberWithDouble:sensorInputs[i][1]], nil]];
        
        // now activate the network
        [subject.network activateNetwork];
        ONPhenoNode * outputNode = [[subject.network outputNodes] lastObject];
        finalOutput[i] = outputNode.activationValue;
        
        [subject.network flushNetwork];
        
        // now print the results
        //NSLog(@"Run number %d has final value %1.3f, is %@", i, finalOutput[i], (finalOutput[i] < 0.5? @"negative": @"positive")); 
    }
    subject.fitness = pow(4.0-(fabs(finalOutput[0]) + fabs(1-finalOutput[1]) + fabs(1-finalOutput[2]) + fabs(finalOutput[3])), 2);
    //NSLog(@"\nGenome %d developed into an organism with fitness %1.3f", subject.genome.genomeID, subject.fitness);
    if ((finalOutput[0] < 0.5) && 
        (finalOutput[1] > 0.5) && 
        (finalOutput[2] > 0.5) &&
        (finalOutput[3] < 0.5)) {
        NSLog(@"We've found a winner!!!!!!!!!!!!!!!!!!");
        solutionOrganism = [subject copy];
        solutionFound = true;
    }
}

-(void) reportResults {
    if (solutionOrganism != nil) {
        NSLog(@"Winner is %@", [solutionOrganism.genome description]);
    }
    else {
        NSLog(@"Unable to find a solution in %d generations", thePopulation.generation);
    }
}

-(void) dealloc {
    if (solutionOrganism != nil) {
        [solutionOrganism release];
    }
    [super dealloc];
}

@end
