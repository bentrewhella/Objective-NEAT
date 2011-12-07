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
 * A population holds an array of organisms (the number defined by population_size in the parameters file).
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

@property (retain) NSMutableArray * allSpecies;

@property int generation;

-(void) rePopulateFromFittest;


/** Convenience method for creating the first population */
+(ONPopulation *) spawnInitialGenerationFromGenome: (ONGenome *) genesisGenome;


@end
