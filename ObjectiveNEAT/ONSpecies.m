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

#import "ONSpecies.h"
#import "ONOrganism.h"
#import "ONParameterController.h"
#import "ONGenome.h"
#import "ONUtilities.h"

@implementation ONSpecies
@synthesize speciesOrganisms, fittestOrganism, speciesFitnessTotal, age, ageSinceImprovement;

static int speciesCounter = 0;

- (id)init
{
    self = [super init];
    if (self) {
        speciesID = speciesCounter++;
        speciesOrganisms = [[NSMutableArray alloc] init];
        age = 0;
        ageSinceImprovement = 0;
        speciesFitnessTotal = 0.0;
    }
    return self;
}

-(void) addOrganism: (ONOrganism *) org {
    [speciesOrganisms addObject:org];
    
    //modify fitness for young / old species
    if (age < [ONParameterController youngSpeciesAgeThreshold]) {
        org.fitness *= [ONParameterController youngSpeciesFitnessBonus];
    }
    else if (age > [ONParameterController oldSpeciesAgeThreshold]) {
        org.fitness *= [ONParameterController oldSpeciesFitnessBonus];
    }
    speciesFitnessTotal += org.fitness;
    if (org.fitness > fittestOrganism.fitness) {
        [fittestOrganism release];
        fittestOrganism = [org copy];
        ageSinceImprovement = 0;
    }
}


-(void) clearAndAge {
    [speciesOrganisms removeAllObjects];
    age++;
    ageSinceImprovement++;
    speciesFitnessTotal = fittestOrganism.fitness;
}

-(bool) shouldIncludeOrganism:(ONOrganism *) org {
    if ([fittestOrganism.genome similarityScoreWithGenome: org.genome] < [ONParameterController speciesCompatibilityThreshold]) {
        return true;
    }
    return false;
}

-(NSComparisonResult) compareBestFitnessWith: (ONSpecies *) anotherSpecies {
    if (self.fittestOrganism.fitness < anotherSpecies.fittestOrganism.fitness) {
        return NSOrderedDescending;
    }
    if (self.fittestOrganism.fitness == anotherSpecies.fittestOrganism.fitness) {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Species %d: %d organisms, best fitness %1.3f.  %d generations, %d without improvement",
            speciesID, [speciesOrganisms count], fittestOrganism.fitness, age, ageSinceImprovement];
}

-(double) numberToSpawnBasedOnAverageFitness: (double) averageFitness {
    double numToSpawn = 0.0;
    
    for (ONOrganism * nextOrganism in speciesOrganisms) {
        numToSpawn += nextOrganism.fitness / averageFitness;
    }
    return numToSpawn;
}

-(NSArray *) spawnOrganisms: (int) numToSpawn {
    
    NSMutableArray * newOrganisms = [[NSMutableArray alloc] init];
    
    [newOrganisms addObject:fittestOrganism];
    
    int survivingOrganisms = [speciesOrganisms count] * [ONParameterController speciesPercentOrganismsSurvive];
    if (survivingOrganisms < 1) {
        survivingOrganisms = 1;
    }
    
    for (int i = 1; i < numToSpawn; i++) {
        ONOrganism * dadOrganism = [speciesOrganisms objectAtIndex:(rand() % survivingOrganisms)];
        ONOrganism * mumOrganism = [speciesOrganisms objectAtIndex:(rand() % survivingOrganisms)];
        if (mumOrganism.fitness > dadOrganism.fitness) {
            ONOrganism * swapOrganism = dadOrganism;
            dadOrganism = mumOrganism;
            mumOrganism = swapOrganism;
        }
        if (dadOrganism == mumOrganism || randomDouble() < [ONParameterController mutateWeightOnlyDontCrossover]) {
            ONOrganism * childOrganism = [dadOrganism reproduceChildOrganism];
            [newOrganisms addObject:childOrganism];
            [childOrganism release];
        }
        else {
            ONOrganism * childOrganism = [dadOrganism reproduceChildOrganismWithOrganism: mumOrganism];
            [newOrganisms addObject:childOrganism];
            [childOrganism release];
        }
    }
    return newOrganisms;
}

-(void) dealloc {
    [speciesOrganisms release];
    [super dealloc];
}

@end
