//
//  ONParameterController.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The ParameterController loads and stores global variables
 *
 *  Will be called by default with the p2test parameter set on program initialisation.
 *  This can be overridden by passing in another parameter file name, as long as this exists in the main bundle.
 *  Parameter files are stored as PLists to enable easy editing and manipulation.
 *  New parameter files can be copied from the original p2test.plist.  
 *  By default these should be added to the source code and compiled to be available in the main bundle
 *  To allow the user to create new parameter lists on the fly, 
 *  adapt to use the documents / application support directory with save functionaility
 */

@interface ONParameterController : NSObject 

/** 
 * Loads a parameter file from the main bundle.
 * Pass in the file name without .plist, as this is added by the application
 * If no parameter is passed in, uses p2test.plist.
 */
+(Boolean) loadParametersFromPList: (NSString *) filename;


/** The total number of fresh runs (i.e. developed from base neuron) to be evaluated in the test */
+(int) numRuns;

/** The maximum number of loops any neural net can go through, in case of recurrant networks.
 *  Start with something like 5
 */
+(int) maxNeuralNetworkLoops;

+(int) populationSize;

+(int) numGenerations;

+(double) mutationProbabilityReplaceWeight;

+(double) mutationMaximumPerturbation;

+(double) mutationProbabilityMutateWeight;

+(double) c1ExcessCoefficient;
+(double) c2DisjointCoefficient;
+(double) c3weightCoefficient;

+(double) speciesCompatibilityThreshold;

+(int) speciesAgeSinceImprovementLimit;

+(double) speciesPercentOrganismsSurvive;
+(int) maximumNeurons;

+(double) chanceAddLink;
+(double) chanceAddNode;
+(double) mutateWeightOnlyDontCrossover;

+(int) youngSpeciesAgeThreshold;

+(double) youngSpeciesFitnessBonus;

+(int) oldSpeciesAgeThreshold;

+(double) oldSpeciesFitnessBonus;

@end
