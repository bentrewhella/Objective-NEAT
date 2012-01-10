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
    double speciesAdjustedFitness;
}

/** The genome of the organism - should be set with initialiser. */
@property (assign) ONGenome * genome;

/** the neural network that is created by the genome. */
-(ONNetwork *) network;
//@property (copy) ONNetwork * network;

/** The fitness of the organism. */
@property double fitness;

/** The fitness of the organism adjusted for species age. */
@property double speciesAdjustedFitness;

/** Initialiser */
- (id)initWithGenome: (ONGenome *) dna;

/** Allocate and expand the network. */
-(void) developNetwork;

/** 
 * Destroy the network - this implementation uses automatic reference counting 
 * so simply sets the value to nil - if the network is used by anything else it will not be destroyed. 
 */
-(void) destroyNetwork;

/** 
 * Asexual reproduction - creates a copy of its own genome then mutates before 
 * developing into an organism.
 */
-(ONOrganism *) reproduceChildOrganism;

/**
 * Sexual reproduction - performs crossover between the two parent genomes, mutates 
 * the develops into an organism.
 */
-(ONOrganism *) reproduceChildOrganismWithOrganism: (ONOrganism *) lessFitMate;

/**
 * Compare method to allow the organisms to be sorted into order of fitness
 */
-(NSComparisonResult) compareFitnessWith: (ONOrganism *) anotherOrganism;

@end
