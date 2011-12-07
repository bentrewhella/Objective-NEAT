//
//  ONSpecies.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 06/12/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONOrganism;

@interface ONSpecies : NSObject {
    int speciesID;
    NSMutableArray * speciesOrganisms;
    ONOrganism * fittestOrganism;
    double speciesFitnessTotal;
    int age;
    int ageSinceImprovement;
}

@property (retain) NSMutableArray * speciesOrganisms;
@property (retain) ONOrganism * fittestOrganism;
@property double speciesFitnessTotal;
@property int age;
@property int ageSinceImprovement;


-(void) addOrganism: (ONOrganism *) org;
-(ONOrganism *) fittestOrganism;
-(bool) shouldIncludeOrganism:(ONOrganism *) org;
-(void) clearAndAge;
-(double) numberToSpawnBasedOnAverageFitness: (double) averageFitness;
-(NSArray *) spawnOrganisms: (int) numToSpawn;

@end
