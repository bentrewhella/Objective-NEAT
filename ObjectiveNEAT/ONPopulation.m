//
//  ONPopulation.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 30/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

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
        if (nextSpecies.ageSinceImprovement > [ONParameterController speciesAgeSinceImprovementLimit] &&
            nextSpecies.fittestOrganism.fitness < fittestOrganismEver.fitness) {
            [speciesToDestroy addObject:nextSpecies];
        }
    }
    [allSpecies removeObjectsInArray:speciesToDestroy];
    [speciesToDestroy removeAllObjects];
    [allSpecies sortUsingSelector:@selector(compareBestFitnessWith:)];
    
    
    
    double sumFitness = 0;
    for (ONOrganism * nextOrganism in allOrganisms) {
        bool foundSpecies = false;
        for (ONSpecies * nextSpecies in allSpecies) {
            if (!foundSpecies && [nextSpecies shouldIncludeOrganism:nextOrganism]) {
                foundSpecies = true;
                [nextSpecies addOrganism:nextOrganism];
                sumFitness += nextOrganism.fitness;
                break;
            }
        }
        if (!foundSpecies) {
            // need to create a new species
            ONSpecies * newSpecies = [[ONSpecies alloc] init];
            [newSpecies addOrganism:nextOrganism];
            sumFitness += nextOrganism.fitness;
            [allSpecies addObject:newSpecies];
        }
    }
    
    for (ONSpecies * nextSpecies in allSpecies) {
        if (nextSpecies.speciesOrganisms.count == 0) {
            [speciesToDestroy addObject:nextSpecies];
        }
    }
    [allSpecies removeObjectsInArray:speciesToDestroy];
    
    // create new species and add to the general population
    double averageFitness = sumFitness / allOrganisms.count;
    
    // sort the entire population and find out if we have a new best
    [allOrganisms sortUsingSelector:@selector(compareFitnessWith:)];
    ONOrganism * mostFitCandidate = [allOrganisms objectAtIndex:0];
    if (mostFitCandidate.fitness > fittestOrganismEver.fitness) {
        fittestOrganismEver = mostFitCandidate;
    }
    
    [allOrganisms removeAllObjects];
    for (ONSpecies * nextSpecies in allSpecies) {
        // need to improve this so fitter species create more organisms
        int numberToCreate = (int) [nextSpecies numberToSpawnBasedOnAverageFitness:averageFitness] + 1;
        [allOrganisms addObjectsFromArray:[nextSpecies spawnOrganisms:numberToCreate]];
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
    
    [newPopulation.allOrganisms addObject:firstLife];
    
    int nOrganisms = [ONParameterController populationSize] - 1; // we've already added one
    
    for (int i = 0; i < nOrganisms; i++) {
        ONGenome * newGenome = [[genesisGenome copy] randomiseWeights];
        ONOrganism *nextLife = [[ONOrganism alloc] initWithGenome: newGenome];
        [newPopulation.allOrganisms addObject:nextLife];
    }
    return newPopulation;
}

@end
