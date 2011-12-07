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
#import "ONNetwork.h"
#import "ONInnovationDB.h"

#import "ONxorExperiment.h"

int main (int argc, const char * argv[])
{

    @autoreleasepool {
        
        // set up random number generator for repeatability (or not)
        //srand ((uint) time(NULL));
        srand (5);
        
        // load files
        if (argc == 2) {
            NSString * filename = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
            [ONParameterController loadParametersFromPList:filename];
        }
        else {
            [ONParameterController loadParametersFromPList:nil];
        }
                
        ONxorExperiment * xorExperiment = [[ONxorExperiment alloc] init];
        [xorExperiment runExperiment];
        
    }
    return 0;
}

