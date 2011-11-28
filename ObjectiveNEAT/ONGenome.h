//
//  ONGenome.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A Genome is the primary source of genotype information used to create a phenotype.
 *
 * It contains 2 major constituents:
 *  1. A list of ONNodes 
 *  2. A list of Genes, each of which consists of a Link with an innovation number.  
 *
 * (Note - this implementation is attempting to deviate from Ken Stanley's original implementation 
 * by excluding traits, which are not activated as yet in the default NEATS method.)
 *
 * Genes can be used to speciate the population, and the list of Genes provides an evolutionary 
 * history of innovation and link-building 
 */

@interface ONGenome : NSObject {
    int genomeID;
    NSMutableArray * nodes;
    NSMutableArray * inputNodes; // this will be moved to network soon
    NSMutableArray * genes;
}

/** The unique reference of the Genome */
@property int genomeID;

/** The array of ONNNode objects */
@property (retain) NSMutableArray * nodes;

@property (retain) NSMutableArray * inputNodes;

/** The array of ONGene objects */
@property (retain) NSMutableArray * genes;

/** 
 * Creates the simplest node possible
 * A number of input and output nodes with a bias input
 * Every input is linked to every output node with a random weighting
 */
+(ONGenome *) createSimpleGenomeWithInputs: (int) nInputs outputs: (int) nOutputs;

/**
 * Takes in an array of doubles representing sensor input values
 * Fills each sensor one by one - if mismatch fills with 0.0 and ignores extra values
 */
-(void) updateSensors: (NSArray *) inputValuesArray;

/**
 * Runs through each neural (i.e. non-sensor) node and updates the node value
 */
-(void) activateNetwork;


/**
 * Returns an array of the final output values
 */
-(NSArray *) outputArray;

@end
