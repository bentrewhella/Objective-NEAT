//
//  ONxorExperiment.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 02/12/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONExperiment.h"
@class ONOrganism;

/**
 * The XOR reference test.
 * 
 * Should be solvable in less than 100 generations.
 *
 * As other experiments should do, overrides followng methods:
 * - initialGenome, to provide the base genome.
 * - evaluateOrganism, the actual XOR experiment.
 * - reportResults, to provide solution or failure result.
 */


@interface ONxorExperiment : ONExperiment {
    ONOrganism * solutionOrganism;
}

@end
