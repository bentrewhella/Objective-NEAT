//
//  ONExperiment.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 28/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONGenome;

@interface ONExperiment : NSObject


+(void) xorExperimentRunWithGenome: (ONGenome *) testGenome;


@end
