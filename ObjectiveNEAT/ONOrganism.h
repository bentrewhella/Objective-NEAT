//
//  ONOrganism.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 30/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONGenome;
@class ONNetwork;

/**
 * An organsim has both a genotype (genome) and phenotype (network or brain),
 * as well as a fitness as judged by any given experiment.
 *
 * It should be initialised with a genome, then the experiment will generally 
 * expand the network while evaluating a population, evaluate the netwwork and assign fitness,
 * then collapse the network to save memory.
 *
 * Users may prefer not to destroy the network immediately, for example
 * you would not want to expand and collapse if contineous sensor updates were required.
 *
 * Note Organisms can be subclassed to contain more fitness factors or retain agent state.
 */


@interface ONOrganism : NSObject {
    ONGenome * genome;
    ONNetwork * network;
    
    double fitness;
}

/** The genome of the organism - should be set with initialiser. */
@property (retain) ONGenome * genome;

/** the neural network that is created by the genome. */
@property (retain) ONNetwork * network;

/** The fitness of the organism. */
@property double fitness;

/** Initialiser */
- (id)initWithGenome: (ONGenome *) dna;

/** Allocate and expand the network. */
-(void) developNetwork;

/** 
 * Destroy the network - this implementation uses automatic reference counting 
 * so simply sets the value to nil - if the network is used by anything else it will not be destroyed. 
 */
-(void) destroyNetwork;

-(ONOrganism *) reproduceChildOrganism;
-(ONOrganism *) reproduceChildOrganismWithOrganism: (ONOrganism *) lessFitMate;

/**
 * Compare method to allow the organisms to be sorted into order of fitness
 */
-(NSComparisonResult) compareFitnessWith: (ONOrganism *) anotherOrganism;

@end
