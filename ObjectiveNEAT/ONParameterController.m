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

#import "ONParameterController.h"

@implementation ONParameterController 

static int maxNeuralNetworkLoops;
static int populationSize;
static int numGenerations;
static double mutationProbabilityReplaceWeight;
static double mutationMaximumPerturbation;
static double chanceMutateWeight;
static double chanceToggleLinks;
static double changeReenableLinks;
static double c1ExcessCoefficient;
static double c2DisjointCoefficient;
static double c3weightCoefficient;
static double speciesCompatibilityThreshold;
static int speciesAgeSinceImprovementLimit;
static double speciesPercentOrganismsSurvive;
static int maximumNeurons;
static double chanceAddLink;
static double chanceAddNode;
static double mutateWeightOnlyDontCrossover;
static int youngSpeciesAgeThreshold;
static double youngSpeciesFitnessBonus;
static int oldSpeciesAgeThreshold;
static double oldSpeciesFitnessBonus;
static int randomSeed;

+(Boolean) loadParametersFromPList: (NSString *) filename {
    if (filename == nil) {
        NSLog(@"No PList name provided, using p2test as a default");
        filename = @"p2test";
    }
    // just in case the user passed in a filename with extension .plist, remove this
    filename = [filename stringByReplacingOccurrencesOfString:@".plist" withString:@""];
    
    NSString * errorDesc = nil;
    NSPropertyListFormat format;
    NSString *pListPath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"plist"];
    
    
    NSData * plistXML = [[NSFileManager defaultManager] contentsAtPath:pListPath];
    NSDictionary *temp = (NSDictionary *) [NSPropertyListSerialization propertyListFromData:plistXML 
                                                                           mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                                                     format:&format 
                                                                           errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading parameters %@.plist: %@, format: %lu", filename, errorDesc, format);
        return FALSE;
    }
    
    NSLog(@"Parameters file %@.plist loaded ok", filename);
    
    // now we have the file - set the parameters 
    maxNeuralNetworkLoops = [(NSNumber *) [temp objectForKey:@"max_neural_net_loops"] intValue];
    populationSize = [(NSNumber *) [temp objectForKey:@"population_size"] intValue];
    numGenerations = [(NSNumber *) [temp objectForKey:@"num_generations"] intValue];
    mutationProbabilityReplaceWeight = [(NSNumber *) [temp objectForKey:@"mut_weight_max_perturbation"] doubleValue];
    mutationMaximumPerturbation = [(NSNumber *) [temp objectForKey:@"mut_weight_prob_replace"] doubleValue];
    chanceMutateWeight = [(NSNumber *) [temp objectForKey:@"chance_mutate_weights"] doubleValue];
    chanceToggleLinks = [(NSNumber *) [temp objectForKey:@"chance_toggle_link"] doubleValue];
    changeReenableLinks = [(NSNumber *) [temp objectForKey:@"chance_reenable_link"] doubleValue];
    c1ExcessCoefficient = [(NSNumber *) [temp objectForKey:@"c1_excess_coefficient"] doubleValue];
    c2DisjointCoefficient = [(NSNumber *) [temp objectForKey:@"c2_disjoint_coefficient"] doubleValue];
    c3weightCoefficient = [(NSNumber *) [temp objectForKey:@"c3_weight_coefficient"] doubleValue];
    speciesCompatibilityThreshold = [(NSNumber *) [temp objectForKey:@"species_compatibility_threshold"] doubleValue];
    speciesAgeSinceImprovementLimit = [(NSNumber *) [temp objectForKey:@"species_age_without_improvement_limit"] intValue];
    speciesPercentOrganismsSurvive = [(NSNumber *) [temp objectForKey:@"species_percent_organisms_survive"] doubleValue];
    maximumNeurons = [(NSNumber *) [temp objectForKey:@"maximum_neurons"] intValue];
    chanceAddLink = [(NSNumber *) [temp objectForKey:@"chance_add_link"] doubleValue];
    chanceAddNode = [(NSNumber *) [temp objectForKey:@"chance_add_node"] doubleValue];
    mutateWeightOnlyDontCrossover = [(NSNumber *) [temp objectForKey:@"mutate_rather_than_crossover_probability"] doubleValue];
    youngSpeciesAgeThreshold = [(NSNumber *) [temp objectForKey:@"young_species_age_threshold"] intValue];
    youngSpeciesFitnessBonus = [(NSNumber *) [temp objectForKey:@"young_species_fitness_bonus"] doubleValue];
    oldSpeciesAgeThreshold = [(NSNumber *) [temp objectForKey:@"old_species_age_threshold"] intValue];
    oldSpeciesFitnessBonus = [(NSNumber *) [temp objectForKey:@"old_species_fitness_penalty"] doubleValue];
    randomSeed = [(NSNumber *) [temp objectForKey:@"random_seed"] intValue];
    return TRUE;
}

+(int) maxNeuralNetworkLoops {
    return maxNeuralNetworkLoops;
}

+(int) populationSize {
    return populationSize;
}

+(int) numGenerations {
    return numGenerations;
}

+(double) mutationProbabilityReplaceWeight {
    return mutationProbabilityReplaceWeight;
}

+(double) mutationMaximumPerturbation {
    return mutationMaximumPerturbation;
}

+(double) chanceMutateWeight {
    return chanceMutateWeight;
}

+(double) chanceToggleLinks {
    return chanceToggleLinks;
}

+(double) changeReenableLinks {
    return changeReenableLinks;
}

+(double) c1ExcessCoefficient {
    return c1ExcessCoefficient;
}

+(double) c2DisjointCoefficient {
    return c2DisjointCoefficient;
}

+(double) c3weightCoefficient {
    return c3weightCoefficient;
}

+(double) speciesCompatibilityThreshold {
    return speciesCompatibilityThreshold;
}

+(int) speciesAgeSinceImprovementLimit {
    return speciesAgeSinceImprovementLimit;
}

+(double) speciesPercentOrganismsSurvive {
    return speciesPercentOrganismsSurvive;
}

+(int) maximumNeurons {
    return maximumNeurons;
}

+(double) chanceAddLink {
    return chanceAddLink;
}

+(double) chanceAddNode {
    return chanceAddNode;
}

+(double) mutateWeightOnlyDontCrossover {
    return mutateWeightOnlyDontCrossover;
}

+(int) youngSpeciesAgeThreshold {
    return youngSpeciesAgeThreshold;
}

+(double) youngSpeciesFitnessBonus {
    return youngSpeciesFitnessBonus;
}

+(int) oldSpeciesAgeThreshold {
    return oldSpeciesAgeThreshold;
}

+(double) oldSpeciesFitnessBonus {
    return oldSpeciesFitnessBonus;
}
+(int) randomSeed {
    return randomSeed;
}

@end
