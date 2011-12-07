//
//  ONNetwork.h
//  ObjectiveNEAT
//
//  Created by Ben Trewhella on 27/11/2011.
//  Copyright (c) 2011 OpposableIntelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONGenome;

/**
 * A Network is the Neural Net that is spawned from a single Genome.
 *
 * The network looks very similar to the ONGenome, however the nodes and links are 
 * connected with pointers to allow fast traversal.
 *
 * It basically consists of an array of input ONNodes and an array of output ONNodes
 * with a few extra convenience arrays.
 *
 * It also retains a link to it's ONGenome from which it spawned.
 *
 * Normal usage is to: 
 * 1) generate the Network with initWithGenome:
 * 2) Update the sensors (with an array of inputs (excluding bias)) using updateSensors:  
 * 3) Run the network with activateNetwork.  
 * 4) Grab the output data from the outputNodes activationValue
 *
 * Note due to the fact that this implementation does not keep nodes in activation order 
 * (very difficult when recursion is used) the network needs to be activated a few times
 * to ensure all nodes are evaluated with the complete set of inputs.  The simplest method 
 * to do this is to activate until each Node's value does not change significantly, to a maximum 
 * of the value max_neural_net_loops value loaded in from the parameters plist (5 is a good start).
 */

@interface ONNetwork : NSObject {
    ONGenome * genome;
    int numNodes;
    int numLinks;
    
    NSMutableArray * allNodes;
    NSMutableArray * inputNodes;
    NSMutableArray * outputNodes;
    NSMutableArray * allLinks;
}

/** A pointer to the Genome which creates this network */
@property (retain) ONGenome * genome;

/** The number of ONPhenoNode objects in this network */
@property int numNodes;

/** The number of ONPhenoLink objects in the network */
@property int numLinks;

/** An array of all nodes in the network */
@property (retain) NSMutableArray * allNodes;

/** An array of the input nodes */
@property (retain) NSMutableArray * inputNodes;

/** An array of the output nodes */
@property (retain) NSMutableArray * outputNodes;


- (id)initWithGenome:(ONGenome *) genotype;

/**
 * Takes in an array of doubles representing sensor input values
 * Fills each sensor one by one - if mismatch fills with 0.0 and ignores extra values
 */
-(void) updateSensors: (NSArray *) inputValuesArray;

/**
 * Runs through each neural (i.e. non-sensor) node and updates the node value
 */
-(void) activateNetwork;

/** Clears all the node values */
-(void) flushNetwork;

@end
