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

/** The unique literal (i.e. non-pointer) reference of the Genome. */
@property int genomeID;

/** The array of ONGenoNode objects. */
@property (retain) NSMutableArray * genoNodes;


/** The array of ONGenoLink objects. */
@property (retain) NSMutableArray * genoLinks;

/** 
 * Creates the simplest node possible containing a number of input and output nodes with a bias input.
 * Every input is linked to every output node with a random weighting.
 *
 * NOTE: this should only be called once, and will halt the application if called again.
 * Rather than call repeatedly to create genomes, create once then duplicate.
 */
+(ONGenome *) createSimpleGenomeWithInputs: (int) nInputs outputs: (int) nOutputs;

/**
 * Test facility to generate a network which is close to an optimal XOR network.
 * Does not include a bias node, probably best avoided.
 */
+(ONGenome *) createXORGenome;

/** 
 * Runs through every link and sets the weight to a random number between -1 and 1. 
 * Used to randomise the initial population, then ignored in favour of crossover and mutation.
 */
-(ONGenome *) randomiseWeights;

/** 
 * Runs through each link in the Genome and perturbs each individual link.
 * Links will either be replaced wth an entirely new chance (rare) or perturbed with a maximum range.
 */
-(void) perturbLinkWeight;

/**
 * Finds a disabled single link and reenables.
 */
-(void) reEnableRandomWeight;

/**
 * Selects a link randomly and either turn it on or off.
 */
-(void) toggleRandomLink;

/**
 * Adds a link between existing nodes.
 * Selects two nodes at random, makes a few checks to ensure the nodes should be linked, 
 * then creates a new link (or picks up the same innovation link in the innovations db and adds this).
 */
-(void) addLink;

/**
 * Adds a node to the genome if possible.
 * Selects a link at random, and tries to insert a node and rewire with two new links, 
 * deactivating the old link.
 * Checks the innovation DB to see if any of these innovations have already been made, 
 * and if so makes use of the existing innovations.
 */
-(void) addNode;

/**
 * Makes one or more mutations.
 * 1) Attempts to add a node with a small probability (about 4% is good) (as long as we've not already added to many)
 * 2) If could not add a node, tries to make a new link with another small probability (about 5%).
 * 3) Regardless of success at above, attempts to either mutate weights with a reasonable probability (say 50%).
 * 4) If no weights mutated, tries to toggle a link activation (about 20%)
 * 5) If no weights or toggles, then tries to reenable any link which is disabled (20% chance).
 */
-(ONGenome *) mutateGenome;

/** 
 * Creates a new Genome from the called Genome and mumGenome, 
 * which without any connotations intended should be passed in as genome with weaker fitness.
 *
 * Runs through each link in both parents.
 * 1) Where finds lnks which match, copies the link from one or the other at random.
 * 2) Where finds a disjoint link that the fitter parent owns, copies this over.
 * 2a) In this implementation disjoint links are copied from the weaker parent, 
 *     as it appears to have better results (at XOR at least)
 * 3) Where finds excess links from the stronger parent, copies these over.  
 *    Ignores excess links from the weaker individual.
 *
 * Finally runs through all links in the new genome and copies in the relevant nodes.
 */
-(ONGenome *) offspringWithGenome: (ONGenome *) mumGenome;

/**
 * Used to verify that genomes are being created / mutated correctly.
 * Not used within active program.  Note if used, will cause the program to cause an exception if it 
 * identifies a dodgy network.
 */
-(void) verifyGenome;

/**
 * Compares this genome with another to see if they could be considered part of the same species.
 * 
 * Runs through the links in each, counting the disjoint and excess links as well as weight variance.
 * Multiples by co-efficients in parameters file and provides score.
 */
-(double) similarityScoreWithGenome: (ONGenome *) otherGenome;



@end
