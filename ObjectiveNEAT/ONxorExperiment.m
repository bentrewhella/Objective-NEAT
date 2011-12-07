//
//  ONxorExperiment.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 02/12/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONxorExperiment.h"


@implementation ONxorExperiment

-(ONGenome *) initialGenome {
    //return [ONGenome createXORGenome];
    return [ONGenome createSimpleGenomeWithInputs:2 outputs:1];
}

-(void) evaluateOrganism: (ONOrganism *) subject {
    
    double sensorInputs[4][2] = {{0.0, 0.0}, {1.0, 0.0}, {0.0, 1.0}, {1.0, 1.0}};
    double finalOutput[4];
    
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
        NSLog(@"Winner is %@", [subject.genome description]);
        NSAssert(false, @"Winner Found");
    }
}

@end
