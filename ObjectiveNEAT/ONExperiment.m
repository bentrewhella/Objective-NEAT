//
//  ONExperiment.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 28/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONExperiment.h"
#import "ONGenome.h"

@implementation ONExperiment


+(void) xorExperimentRunWithGenome: (ONGenome *) testGenome {
    double sensorInputs[4][2] = {{0.0, 0.0}, {1.0, 0.0}, {0.0, 1.0}, {1.0, 1.0}};
    double finalOutput[4];
    
    // to start with we're just going to run through the single genome
    for (int i = 0; i < 4; i++) {
        // load in the initial sensor data
        [testGenome updateSensors:[NSArray arrayWithObjects:
                                   [NSNumber numberWithDouble:sensorInputs[i][0]], 
                                   [NSNumber numberWithDouble:sensorInputs[i][1]], nil]];
        
        // now activate the network
        [testGenome activateNetwork];
        
        finalOutput[i] = [[[testGenome outputArray] lastObject] doubleValue];
        
        // now print the results
        //NSLog(@"Run number %d has final value %1.3f, is %@", i, finalOutput[i], (finalOutput[i] < 0.0? @"negative": @"positive")); // [testGenome description]);
    }
    //NSLog(@"_____________");
    if ((finalOutput[0] < 0.0) && 
        (finalOutput[1] > 0.0) && 
        (finalOutput[2] > 0.0) &&
        (finalOutput[3] < 0.0)) {
        NSLog(@"We've found a winner!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
}

@end
