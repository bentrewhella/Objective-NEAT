//
//  main.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONParameterController.h"
#import "ONGenome.h"
#import "ONExperiment.h"

int main (int argc, const char * argv[])
{

    @autoreleasepool {
        
        // set up random number generator for repeatability (or not)
        //srand ((uint) time(NULL));
        srand (1);
        
        // load files
        if (argc == 2) {
            NSString * filename = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
            [ONParameterController loadParametersFromPList:filename];
        }
        else {
            [ONParameterController loadParametersFromPList:nil];
        }
        
        
        for (int i = 0; i < 100000; i++) {
            // create the simplest node structure
            ONGenome * simpleGenome = [ONGenome createSimpleGenomeWithInputs:2 outputs:1];
            //NSLog(@"Starting Position: %@",[simpleGenome description]);
            
            // run the simplest xor experiment
            [ONExperiment xorExperimentRunWithGenome:simpleGenome];
        }
        
    }
    return 0;
}

