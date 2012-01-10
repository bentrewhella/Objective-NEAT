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

#import "ONPopulation.h"
#import "ONGenome.h"
#import "ONParameterController.h"
#import "ONOrganism.h"
#import "ONUtilities.h"
#import "ONSpecies.h"

@implementation ONPopulation
@synthesize allOrganisms, allSpecies, generation;

- (id)init
{
    self = [super init];
    if (self) {
        allOrganisms = [[NSMutableArray alloc] init];
        allSpecies = [[NSMutableArray alloc] init];
        generation = 0;
    }
    return self;
}



-(void) rePopulateFromFittest {
    
    // go through each species, purge then sort by fitness
    NSMutableArray * speciesToDestroy = [NSMutableArray array];
    for (ONSpecies * nextSpecies in allSpecies) {
        [nextSpecies clearAndAge];
        if (nextSpecies.ageSinceImprovement > [ONParameterController speciesAgeSinceImprovementLimit]) {
            //&& nextSpecies.fittestOrganism.fitness < fittestOrganismEver.fitness) {
            [speciesToDestroy addObject:nextSpecies];
        }
    }
    [allSpecies removeObjectsInArray:speciesToDestroy];
    [speciesToDestroy removeAllObjects];
    [allSpecies sortUsingSelector:@selector(compareBestFitnessWith:)];
    
    
    
    double sumFitness = 0;
    double sumAdjustedFitness = 0;
    for (ONOrganism * nextOrganism in allOrganisms) {
        bool foundSpecies = false;
        for (ONSpecies * nextSpecies in allSpecies) {
            if (!foundSpecies && [nextSpecies shouldIncludeOrganism:nextOrganism]) {
                foundSpecies = true;
                [nextSpecies addOrganism:nextOrganism];
                sumFitness += nextOrganism.fitness;
                sumAdjustedFitness += nextOrganism.speciesAdjustedFitness;
                break;
            }
        }
        if (!foundSpecies) {
            // need to create a new species
            ONSpecies * newSpecies = [[ONSpecies alloc] init];
            [newSpecies addOrganism:nextOrganism];
            sumFitness += nextOrganism.fitness;
            sumAdjustedFitness += nextOrganism.speciesAdjustedFitness;
            [allSpecies addObject:newSpecies];
            [newSpecies release];
        }
        
        if (nextOrganism.fitness > fittestOrganismEver.fitness) {
            [fittestOrganismEver release];
            fittestOrganismEver = [nextOrganism copy];
        }
    }
    
    for (ONSpecies * nextSpecies in allSpecies) {
        if (nextSpecies.speciesOrganisms.count == 0) {
            [speciesToDestroy addObject:nextSpecies];
        }
    }
    [allSpecies removeObjectsInArray:speciesToDestroy];
    
    // create new species and add to the general population
    double averageFitness = sumAdjustedFitness / allOrganisms.count;
    
    // sort the entire population and find out if we have a new best
    [allOrganisms sortUsingSelector:@selector(compareFitnessWith:)];
    
    [allOrganisms removeAllObjects];
    for (ONSpecies * nextSpecies in allSpecies) {
        int numberToCreate = (int) [nextSpecies numberToSpawnBasedOnAverageFitness:averageFitness];
        NSArray * newGeneration = [nextSpecies spawnOrganisms:numberToCreate];
        [allOrganisms addObjectsFromArray:newGeneration];
        [newGeneration release];
    }
    // this was fixed 
    int speciesIndex = 0;
    for (int i = (int) [allOrganisms count] ; i < [ONParameterController populationSize]; i++) {
        ONSpecies * nextSpecies = [allSpecies objectAtIndex:speciesIndex];
        speciesIndex++;
        if (speciesIndex <= [allSpecies count]) {
            speciesIndex = 0;
        }
        NSArray * newGeneration = [nextSpecies spawnOrganisms:1];
        [allOrganisms addObjectsFromArray:newGeneration];
        [newGeneration release];
    }
    generation++;
    
}

-(NSString *) description {
    return [NSString stringWithFormat: @"Generation %d, highest fitness to date %1.3f: %@", 
            generation, fittestOrganismEver.fitness, [allSpecies description]];   
}


+(ONPopulation *) spawnInitialGenerationFromGenome: (ONGenome *) genesisGenome {
    
    ONPopulation * newPopulation = [[ONPopulation alloc] init];
    
    ONOrganism * firstLife = [[ONOrganism alloc] initWithGenome: genesisGenome];
    [genesisGenome release];
    
    [newPopulation.allOrganisms addObject:firstLife];
    [firstLife release];
    
    int nOrganisms = [ONParameterController populationSize] - 1; // we've already added one
    
    for (int i = 0; i < nOrganisms; i++) {
        ONGenome * newGenome = [[genesisGenome copy] randomiseWeights];
        ONOrganism *nextLife = [[ONOrganism alloc] initWithGenome: newGenome];
        [newGenome release];
        [newPopulation.allOrganisms addObject:nextLife];
        [nextLife release];
    }
    return newPopulation;
}

-(void) dealloc {
    [allOrganisms release];
    [allSpecies release];
    [super dealloc];
}

@end
