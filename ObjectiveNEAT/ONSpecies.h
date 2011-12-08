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

/**
 * An Species provides a niche in which Organisms can compete with each
 * other to try and create higly fit networks.
 *
 * Almost all mutations will initially have a lower fitness, so by using 
 * Species they are not immediately eliminated from the wider population.
 *
 * The species do not really store any organisms seperate from the main
 * population, they simply identify individuals which can be crossed.
 */

@interface ONSpecies : NSObject {
    int speciesID;
    NSMutableArray * speciesOrganisms;
    ONOrganism * fittestOrganism;
    double speciesFitnessTotal;
    int age;
    int ageSinceImprovement;
}

/**
 * An array of the organisms help temporarily for reproduction.
 */
@property (retain) NSMutableArray * speciesOrganisms;

/**
 * The fittest organism ever found in this species.  This is updated
 * as new fitter individuals arise, and used as a comparitor to test if other organisms
 * should be part of this species.
 */
@property (retain) ONOrganism * fittestOrganism;

/**
 * A convenience variable to store the total fitness within the species.
 * Used to work out how many organisms the species should reproduce.
 */
@property double speciesFitnessTotal;

/**
 * The number of generations since the species first appeared.
 * Newer species are given a fitness bonus to help them on their way,
 * older species are given a penalty as they should be pretty effective after a while.
 */
@property int age;

/** 
 * The number of generations since the fittest individual has been replaced,
 * and the species has therefore improved.
 */
@property int ageSinceImprovement;

/** 
 * returns Yes if the organism is sufficiently similar to the fittest organism.
 */
-(bool) shouldIncludeOrganism:(ONOrganism *) org;

/**
 * Add the organism to the species.
 * At the same time modifies the organisms fitness by the species age bonus / penalty.
 */
-(void) addOrganism: (ONOrganism *) org;

/** 
 * Provides the fittest organism for reporting.
 */
-(ONOrganism *) fittestOrganism;

/** 
 * Clears out the species, but retains the fittest organism.
 * Called prior to recreating the species from the fittest organism 
 * and general population.
 */
-(void) clearAndAge;

/**
 * Works out how many organsims this species should reproduce.
 * Based upon the overall population fitness average.
 */
-(double) numberToSpawnBasedOnAverageFitness: (double) averageFitness;

/**
 * Generates are returns an array of new organisms.
 */
-(NSArray *) spawnOrganisms: (int) numToSpawn;

@end
