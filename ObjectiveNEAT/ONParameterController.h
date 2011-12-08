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

/**
 * The ParameterController loads and stores global variables.
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


/** 
 * The maximum number of loops any neural net can go through, in case of recurrant networks.
 * Start with something like 5.
 * 'max_neural_net_loops' in parameters plist.
 */
+(int) maxNeuralNetworkLoops;

/**
 * The number of organims / genomes / networks evaluated in each generaton / epoch.
 * 'population_size' in paramters plist.
 */
+(int) populationSize;

/**
 * The total number of generations to be evaluated before giving up 
 * 'num_generations' in parameters plist.
 */
+(int) numGenerations;

/**
 * The probability that an individual link will have it's weight completely randomised
 * rather than simple perturbed, once it's been determined this genome will have all it's links modified.
 * 'mut_weight_prob_replace' in parameters plist.
 */
+(double) mutationProbabilityReplaceWeight;

/**
 * The maximum amount that any weight can be perturbed (+/-).
 * 'mut_weight_max_perturbation' in plist.
 */
+(double) mutationMaximumPerturbation;

/**
 * The probability that the weight of all links will be modified.
 * 'chance_mutate_weights' in paramters plist.
 */
+(double) chanceMutateWeight;

/**
 * The probability that any single link will have be enabled / diabled.
 * 'chance_toggle_link' in parameters plist.
 */
+(double) chanceToggleLinks;

/**
 * The probability that any single deactivated link will be reactivated.
 * 'chance_reenable_link' in parameters plist.
 */
+(double) changeReenableLinks;

/**
 * A weighting given to excess links when evaluating similarity with another genome.
 * Used in speciation.
 * 'c1_excess_coefficient' in parameters plist.
 */
+(double) c1ExcessCoefficient;

/**
 * A weighting given to disjoint links when evaluating similarity with another genome.
 * Used in speciation.
 * 'c2_disjoint_coefficient' in parameters plist.
 */
+(double) c2DisjointCoefficient;

/**
 * A weighting given to link weights when evaluating similarity with another genome.
 * Used in speciation.
 * 'c3_weight_coefficient' in parameters plist.
 */
+(double) c3weightCoefficient;

/**
 * A threshold above which two individual organisms can not be considered part of the same species.
 * Lower is less forgiving i.e. will result in more species.
 * 'species_compatibility_threshold' in parameters plist.
 */
+(double) speciesCompatibilityThreshold;

/**
 * Any species that have not shown any improvement over this many generations will be culled.
 * 'species_age_without_improvement_limit' in parameters plist.
 */
+(int) speciesAgeSinceImprovementLimit;

/**
 * The percentage of best performing organisms in a species that will be selected from to 
 * create the next species.
 * 'species_percent_organisms_survive' in parameters plist.
 */
+(double) speciesPercentOrganismsSurvive;

/** 
 * Will not add any more nodes if this limit has been reached.  
 * Note it's still possible for crossover to breach this number of nodes.
 * 'maximum_neurons' in parameters plist.
 */
+(int) maximumNeurons;

/**
 * The probability of adding a new link / gene when mutating a genome.
 * 'chance_add_link' in parameters plist.
 */
+(double) chanceAddLink;

/**
 * The probability of adding a new node when mutating a genome.
 * 'chance_add_node' in parameters plist.
 */
+(double) chanceAddNode;

/**
 * The probability of just spawning from an existing organism rather than crossing two.
 * Note this may be forced if there is only one organism in the species.
 * 'mutate_rather_than_crossover_probability' in parameters plist.
 */
+(double) mutateWeightOnlyDontCrossover;

/** 
 * Any species that are less than this old get a bonus to each organisms fitness.
 * 'young_species_age_threshold' in parameters plist.
 */
+(int) youngSpeciesAgeThreshold;

/** 
 * Give members of any young species this mutliplier to their fitness.
 * 'young_species_fitness_bonus' in parameters plist.
 */
+(double) youngSpeciesFitnessBonus;

/**
 * Any species that are older than this get a penalty to each organisms fitness.
 * 'old_species_age_threshold' in parameters plist.
 */
+(int) oldSpeciesAgeThreshold;


/**
 * Give members of old species this multiplier to their fitness.
 * 'old_species_fitness_penalty' in parameters plist.
 */
+(double) oldSpeciesFitnessBonus;

/**
 * Seed for the random number generator.
 * If all experiments turn out the same, consider changing this.
 * Using the value 0 sets this to the current time (i.e non-repeatable).
 */
+(int) randomSeed;

@end
