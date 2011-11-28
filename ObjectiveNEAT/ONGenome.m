//
//  ONGenome.m
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import "ONGenome.h"
#import "ONGene.h"
#import "ONNNode.h"

@implementation ONGenome
@synthesize genomeID, nodes, genes;
@synthesize inputNodes;

static int genomeCounter = 0;

- (id)init
{
    self = [super init];
    if (self) {
        nodes = [[NSMutableArray alloc] init];
        inputNodes = [[NSMutableArray alloc] init];
        genes = [[NSMutableArray alloc] init];
        genomeID = genomeCounter++;
    }
    return self;
}

-(void) updateSensors: (NSArray *) inputValuesArray {
    
    for (int i = 0; i < [inputNodes count]; i++) {
        ONNNode * nextInputNode = [inputNodes objectAtIndex:i];
        NSNumber * nextInputValue = [inputValuesArray objectAtIndex:i];
        if (nextInputValue != nil) {
            nextInputNode.activation = [nextInputValue doubleValue];
        }
        else {
            nextInputNode.activation = 0.0;
            NSLog(@"Runtime Warning - not enough input parameters to sensors: filling sensor %d with vaue 0.0", i);
        }
    }
    if ([inputValuesArray count] > [inputNodes count]) {
        NSLog(@"Runtime Warning - there are %lu input values but only %lu input sensors in the network: ignoring the extra ones", 
              [inputValuesArray count], [inputNodes count]);
    }
}

-(void) activateNetwork {
    // run forward through each node - should be loaded in an order that will ensure 
    for (ONNNode * nextNode in nodes) {
        if (!nextNode.nodeType == SENSOR) {
           [nextNode activate];
        }
    }
}

-(NSArray *) outputArray {
    NSMutableArray * results = [NSMutableArray array];
    for (ONNNode * nextNode in nodes) {
        if (nextNode.nodePosition == OUTPUT) {
            [results addObject:[NSNumber numberWithDouble:nextNode.activation]];
        }
    }
    return results;
}


+(ONGenome *) createSimpleGenomeWithInputs: (int) nInputs outputs: (int) nOutputs {
    ONGenome * newGenome = [[ONGenome alloc] init];
    
    // set up input nodes
    for (int i = 0; i < nInputs; i++) {
        ONNNode * inputNode = [[ONNNode alloc] init];
        inputNode.nodeType = SENSOR;
        inputNode.nodePosition = INPUT;
        inputNode.activation = 0.0;
        [newGenome.nodes addObject: inputNode];
        [newGenome.inputNodes addObject:inputNode];  // to be removed to network
    }
    
    // set up bias node
    ONNNode * biasNode = [[ONNNode alloc] init];
    biasNode.nodeType = SENSOR;
    biasNode.nodePosition = BIAS;
    biasNode.activation = 1.0;
    [newGenome.nodes addObject: biasNode];
    
    // set up output nodes
    for (int i = 0; i < nOutputs; i++) {
        ONNNode * outputNode = [[ONNNode alloc] init];
        outputNode.nodeType = NEURON;
        outputNode.nodePosition = OUTPUT;
        outputNode.activation = 0.0;
        [newGenome.nodes addObject: outputNode];
    }
    
    // link all input / bias nodes to all output nodes
    for (int i = 0; i < nInputs + 1 /*bias*/; i++) {
        for (int j = 0; j < nOutputs; j++) {
            ONGene * newGene = [[ONGene alloc] 
                                initGeneFromNode: [newGenome.nodes objectAtIndex:i]
                                toNode: [newGenome.nodes objectAtIndex:nInputs + 1 /*bias*/ + j] 
                                weight:((float)rand()/(float)RAND_MAX - (float)rand()/(float)RAND_MAX)];
            [newGenome.genes addObject:newGene];
        }
    }
    
    return newGenome;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"\nGenome %d\nNodes: %@\nGenes: %@", 
            genomeID,
            nodes,
            genes];
}

@end
