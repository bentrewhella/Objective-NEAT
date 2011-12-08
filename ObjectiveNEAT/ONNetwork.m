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

#import "ONNetwork.h"
#import "ONGenome.h"
#import "ONGenoNode.h"
#import "ONGenoLink.h"
#import "ONPhenoNode.h"
#import "ONPhenoLink.h"
#import "ONParameterController.h"


@implementation ONNetwork
@synthesize genome, numLinks, numNodes, allNodes, inputNodes, outputNodes;



-(ONPhenoNode *) getNodeWithID: (int) nID {
    for (ONPhenoNode * nextPhenoNode in allNodes) {
        if (nextPhenoNode.nodeID == nID) {
            return nextPhenoNode;
        }
    }
    return nil;
}

- (id)initWithGenome:(ONGenome *) genotype
{
    self = [super init];
    if (self) {
        genome = genotype;
        
        allNodes = [[NSMutableArray alloc] init];
        inputNodes = [[NSMutableArray alloc] init];
        outputNodes = [[NSMutableArray alloc] init];
        allLinks = [[NSMutableArray alloc] init];
        
        numNodes = 0;
        
        // set up phenonodes
        for (ONGenoNode * nextGenoNode in genome.genoNodes) {
            ONPhenoNode * newPhenoNode = [[ONPhenoNode alloc] init];
            newPhenoNode.nodeID = nextGenoNode.nodeID;
            newPhenoNode.nodeType = nextGenoNode.nodeType;
            
            [allNodes addObject:newPhenoNode];
            if (nextGenoNode.nodeType == INPUT) {
                [inputNodes addObject:newPhenoNode];
            }
            if (nextGenoNode.nodeType == OUTPUT) {
                [outputNodes addObject:newPhenoNode];
            }
            numNodes++;
        }
        
        // set up phenolinks
        for (ONGenoLink * nextGenoLink in genome.genoLinks) {
            if (nextGenoLink.isEnabled) {
                ONPhenoLink * newPhenoLink = [[ONPhenoLink alloc] init];
                
                ONPhenoNode * fNode = [self getNodeWithID:nextGenoLink.fromNode];
                if (fNode == nil) {
                    NSLog(@"Warning - In building Phenotype: PhenoNode %d referred to by a genoLink cannot be found", 
                          nextGenoLink.fromNode);
                }
                newPhenoLink.fromNode = fNode; 
                [newPhenoLink.fromNode.outgoingPhenoLinks addObject:newPhenoLink];
                
                ONPhenoNode * tNode = [self getNodeWithID:nextGenoLink.toNode];
                if (tNode == nil) {
                    NSLog(@"Warning - In building Phenotype: PhenoNode %d referred to by a genoLink cannot be found", 
                          nextGenoLink.toNode);
                }
                newPhenoLink.toNode = tNode; 
                [newPhenoLink.toNode.incomingPhenoLinks addObject:newPhenoLink];
                
                newPhenoLink.weight = nextGenoLink.weight;
                newPhenoLink.isEnabled = nextGenoLink.isEnabled;
                
                [allLinks addObject:newPhenoLink];
                numLinks++;
            }
        }
    }
    return self;
}

-(void) updateSensors: (NSArray *) inputValuesArray {
    for (int i = 0; i < [inputNodes count]; i++) {
        ONPhenoNode * nextInputNode = [inputNodes objectAtIndex:i];
        NSNumber * nextInputValue = [inputValuesArray objectAtIndex:i];
        if (nextInputValue != nil) {
            nextInputNode.activationValue = [nextInputValue doubleValue];
        }
        else {
            nextInputNode.activationValue = 0.0;
            NSLog(@"Runtime Warning - not enough input parameters to sensors: filling sensor %d with vaue 0.0", i);
        }
    }
    if ([inputValuesArray count] > [inputNodes count]) {
        NSLog(@"Runtime Warning - there are %lu input values but only %lu input sensors in the network: ignoring the extra ones", 
              [inputValuesArray count], [inputNodes count]);
    }
    for (ONPhenoNode * nextPhenoNode in allNodes) {
        if (nextPhenoNode.nodeType == BIAS) {
            nextPhenoNode.activationValue = 1.0;
        }
    }
}

-(void) activateNetwork {
    
    bool stabilised = false;
    int remainingLoops = [ONParameterController maxNeuralNetworkLoops];
    
    while (!stabilised && remainingLoops > 0) {
        stabilised = true;
        // run forward through each node
        for (ONPhenoNode * nextPhenoNode in allNodes) {
            if (nextPhenoNode.nodeType == HIDDEN || 
                nextPhenoNode.nodeType == OUTPUT) {
                [nextPhenoNode activate];
                if (nextPhenoNode.hasChangedSinceLastTraversal) {
                    stabilised = false;
                }
            }
        }
        remainingLoops--;
        
    }
     
}

-(void) flushNetwork {
    for (ONPhenoNode * nextPhenoNode in allNodes) {
        nextPhenoNode.activationValue = 0;
        nextPhenoNode.lastActivationValue = 0;
    }
}

-(NSString *) description {
    return [NSString stringWithFormat: @"Nodes: %@ Links: %@",
            [allNodes description],
            [allLinks description]];   
}


@end
