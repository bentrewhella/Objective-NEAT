//
//  ONExperiment.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 28/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONNetwork.h"
#import "ONGenome.h"
#import "ONPopulation.h"
#import "ONPhenoNode.h"
#import "ONOrganism.h"

/**
 * The base class for experiments.
 * 
 * To subclass, simply override the initialGenome and evaluateNetwork methods.
 *
 */


@interface ONExperiment : NSObject {
    ONPopulation * thePopulation;
    bool solutionFound;
}

@property bool solutionFound;


/**
 * Performs any set up required.
 * In base class sets the random seed.
 */
-(void) initialiseExperiment;

/**
 * Returns the initial Genome.  Subclasses can create a genome here using convenience methods or file loaders. 
 */
-(ONGenome *) initialGenome;

/** 
 * Generate the initial population from the initial Genome.
 *
 * Can be overridden but will provide a simple 2 in, 1 bias and 1 output if not */
-(void) initialisePopulation;

/** Runs the experiment.
 *
 * Starts by initialising a population using a population.
 * consisting of the simplest genome possible with randomised weights.
 *
 * Then selects the top performing Organisms and begins crossover and mutation to create the next population.
 * Iterates for a number of generations (as defined by num_generations in the parameters plist),
 * at each stage evaluating the organism with the evaluateOrganism method.
 *
 */
-(void) runExperiment;

/** 
 * Evaluate any given organism and assign fitness.
 * 
 * This is usually subclassed to create a new experiment .
 * 
 * Overriding methods should follow a process something like:
 * 1. Update sensors
 * 2. Activate network
 * 3. Identify and set fitness value
 */
-(void) evaluateOrganism: (ONOrganism *) subject;

/**
 * Iterates through the population and evaluates each individual.
 * Should not need to be overridden unless required.
 */
-(void) evaluatePopulation;


/**
 * Called once the experiment has been completed, 
 * either by a solution being found, or by all generations being run without a solution being found.
 */
 
-(void) reportResults;


@end

