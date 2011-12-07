//
//  ONGenome.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ONNetwork;

/**
 * A Genome is the primary source of genotype information used to create a phenotype.
 *
 * It contains 2 major constituents:
 *  1. A list of ONGenoNodes 
 *  2. A list of ONGenoLinks  
 *
 * (Note - this implementation is attempting to deviate from Ken Stanley's original implementation 
 * by excluding traits, which are not activated as yet in the default NEATS method.)
 */

@interface ONGenome : NSObject {
    int genomeID;
    NSMutableArray * genoNodes;
    NSMutableArray * genoLinks;
}

/** The unique literal (i.e. non-pointer) reference of the Genome */
@property int genomeID;

/** The array of ONGenoNode objects */
@property (retain) NSMutableArray * genoNodes;


/** The array of ONGenoLink objects */
@property (retain) NSMutableArray * genoLinks;

/** 
 * Creates the simplest node possible containing a number of input and output nodes with a bias input.
 * Every input is linked to every output node with a random weighting.
 *
 * NOTE: this should only be called once, and will halt the application if called again.
 * Rather than call repeatedly to create genomes, create once then duplicate.
 */
+(ONGenome *) createSimpleGenomeWithInputs: (int) nInputs outputs: (int) nOutputs;

+(ONGenome *) createXORGenome;

/** Runs through every link and sets the weight to a random number between -1 and 1. */
-(ONGenome *) randomiseWeights;
-(void) perturbLinkWeight;
-(void) toggleRandomWeight;
-(void) addLink;
-(void) addNode;
-(ONGenome *) mutateGenome;
-(ONGenome *) offspringWithGenome: (ONGenome *) mumGenome;
-(void) verifyGenome;



-(double) similarityScoreWithGenome: (ONGenome *) otherGenome;



@end
