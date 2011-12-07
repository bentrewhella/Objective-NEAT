//
//  ONPopulation.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 30/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONOrganism;
@class ONGenome;

/** 
 * A population holds all the active organisms.
 *
 * The population are in turns evaluated then replaced through speciation.
 *
 */

@interface ONPopulation : NSObject {
    NSMutableArray * allOrganisms;
    NSMutableArray * allSpecies;
    ONOrganism * fittestOrganismEver;
    int generation;
}

/** The array of currently existing organisms */
@property (retain) NSMutableArray * allOrganisms;

/** An array of all the existing species */
@property (retain) NSMutableArray * allSpecies;

/** The current number of complete population changes - also know as epochs. */
@property int generation;

/** 
 * Creates a new population from the last.
 *
 * 1) First gets rid of any species that are old (as long as they don't contain the fittest organism.
 * 2) Runs through each organasim and looks for a suitable species, creating a new species if none found.
 * 3) Asks each species to recreate a number of organisms to create a new population.
 * Note: the species together generally provide a few more organisms than was present in the last population.
 * This can be fixed but should present a problem for most uses.
 */
-(void) rePopulateFromFittest;


/** 
 * Convenience method for creating the first population.
 * Simply takes the initial genome and copies with random weights.
 */
+(ONPopulation *) spawnInitialGenerationFromGenome: (ONGenome *) genesisGenome;


@end
