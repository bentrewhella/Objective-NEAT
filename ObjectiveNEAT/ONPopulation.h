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
